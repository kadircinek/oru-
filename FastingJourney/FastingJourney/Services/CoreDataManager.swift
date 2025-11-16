import Foundation
import CoreData

/// CoreData stack manager with UserDefaults migration support
class CoreDataManager {
    static let shared = CoreDataManager()
    
    // MARK: - Core Data Stack
    
    private var _persistentContainer: NSPersistentContainer?
    
    var persistentContainer: NSPersistentContainer {
        if let container = _persistentContainer {
            return container
        }
        
        let modelName = "FastingJourney"
        let container: NSPersistentContainer
        
        // Check if model file exists
        if let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd"),
           let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) {
            print("✅ Found CoreData model at: \(modelURL)")
            container = NSPersistentContainer(name: modelName, managedObjectModel: managedObjectModel)
        } else {
            print("⚠️ Using default CoreData initialization")
            container = NSPersistentContainer(name: modelName)
        }
        
        // Enable iCloud sync
        let description = container.persistentStoreDescriptions.first
        description?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        let semaphore = DispatchSemaphore(value: 0)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("❌ CoreData load error: \(error), \(error.userInfo)")
            } else {
                print("✅ CoreData store loaded successfully")
            }
            semaphore.signal()
        }
        
        // Wait for store to load
        _ = semaphore.wait(timeout: .now() + 5.0)
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        _persistentContainer = container
        return container
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        // Don't initialize container here to avoid initialization order issues
        // It will be lazily loaded when first accessed
    }
    
    // Lazy migration - only runs once when first needed
    private var migrationCompleted = false
    private func ensureMigration() {
        guard !migrationCompleted else { return }
        migrationCompleted = true
        
        if !hasMigratedFromUserDefaults {
            print("🔄 Starting migration from UserDefaults to CoreData...")
            migrateFromUserDefaults()
        }
    }
    
    // MARK: - Save Context
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("❌ CoreData save error: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Migration from UserDefaults
    
    private var hasMigratedFromUserDefaults: Bool {
        get { UserDefaults.standard.bool(forKey: "HasMigratedToCoreData") }
        set { UserDefaults.standard.set(newValue, forKey: "HasMigratedToCoreData") }
    }
    
    private func migrateFromUserDefaults() {
        print("🔄 Starting migration from UserDefaults to CoreData...")
        
        let persistenceManager = PersistenceManager.shared
        let context = self.context
        
        // Migrate UserProfile
        let oldProfile = persistenceManager.loadUserProfile()
        let cdProfile = CDUserProfile(context: context)
        cdProfile.id = UUID()
        cdProfile.totalCompletedFasts = Int32(oldProfile.totalCompletedFasts)
        cdProfile.totalHoursFasted = oldProfile.totalHoursFasted
        cdProfile.currentStreak = Int32(oldProfile.currentStreak)
        cdProfile.longestStreak = Int32(oldProfile.longestStreak)
        cdProfile.level = Int32(oldProfile.level)
        cdProfile.lastFastingDate = oldProfile.lastFastingDate
        print("✅ Migrated UserProfile")
        
        // Migrate Sessions
        let oldSessions: [FastingSession] = persistenceManager.loadSessions()
        for session in oldSessions {
            let cdSession = CDFastingSession(context: context)
            cdSession.id = session.id
            cdSession.planId = session.planId
            cdSession.startDate = session.startDate
            cdSession.endDate = session.endDate
            cdSession.isCompleted = session.isCompleted
            cdSession.actualFastingHours = session.actualFastingHours
        }
        print("✅ Migrated \(oldSessions.count) sessions")
        
        // Migrate WeightEntry data from WeightTrackingManager
        let oldWeightEntries: [WeightEntry] = WeightTrackingManager.shared.entries
        for entry in oldWeightEntries {
            let cdEntry = CDWeightEntry(context: context)
            cdEntry.id = UUID(uuidString: entry.id) ?? UUID()
            cdEntry.weight = entry.weight
            cdEntry.date = entry.date
            cdEntry.notes = entry.note
            saveContext()
        }
        
        // Migrate Hydration Entry (today's only)
        if let oldHydration: HydrationEntry = persistenceManager.load(forKey: "hydrationToday") {
            let cdHydration = CDHydrationEntry(context: context)
            cdHydration.id = UUID()
            cdHydration.date = Date()
            cdHydration.consumedMl = Int32(oldHydration.consumedMl)
            cdHydration.targetMl = Int32(oldHydration.targetMl)
            print("✅ Migrated hydration entry")
        }
        
        // Save all migrated data
        do {
            try context.save()
            hasMigratedFromUserDefaults = true
            print("✅ Migration completed successfully!")
        } catch {
            print("❌ Migration failed: \(error)")
        }
    }
    
    // MARK: - CRUD Operations
    
    // Fasting Sessions
    func saveFastingSession(_ session: FastingSession) {
        let cdSession = CDFastingSession(context: context)
        cdSession.id = session.id
        cdSession.planId = session.planId
        cdSession.startDate = session.startDate
        cdSession.endDate = session.endDate
        cdSession.isCompleted = session.isCompleted
        cdSession.actualFastingHours = session.actualFastingHours
        saveContext()
    }
    
    func fetchAllSessions() -> [FastingSession] {
        ensureMigration()
        let request: NSFetchRequest<CDFastingSession> = CDFastingSession.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
        
        do {
            let cdSessions = try context.fetch(request)
            return cdSessions.map { $0.toFastingSession() }
        } catch {
            print("❌ Fetch sessions error: \(error)")
            return []
        }
    }
    
    func updateSession(_ session: FastingSession) {
        let request: NSFetchRequest<CDFastingSession> = CDFastingSession.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", session.id as CVarArg)
        
        do {
            if let cdSession = try context.fetch(request).first {
                cdSession.endDate = session.endDate
                cdSession.isCompleted = session.isCompleted
                cdSession.actualFastingHours = session.actualFastingHours
                saveContext()
            }
        } catch {
            print("❌ Update session error: \(error)")
        }
    }
    
    // User Profile
    func saveUserProfile(_ profile: UserProfile) {
        // Try to fetch existing profile
        let request: NSFetchRequest<CDUserProfile> = CDUserProfile.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            let cdProfile = results.first ?? CDUserProfile(context: context)
            
            if cdProfile.id == nil {
                cdProfile.id = UUID()
            }
            
            cdProfile.totalCompletedFasts = Int32(profile.totalCompletedFasts)
            cdProfile.totalHoursFasted = profile.totalHoursFasted
            cdProfile.currentStreak = Int32(profile.currentStreak)
            cdProfile.longestStreak = Int32(profile.longestStreak)
            cdProfile.level = Int32(profile.level)
            cdProfile.lastFastingDate = profile.lastFastingDate
            
            saveContext()
        } catch {
            print("❌ Save profile error: \(error)")
        }
    }
    
    func fetchUserProfile() -> UserProfile? {
        let request: NSFetchRequest<CDUserProfile> = CDUserProfile.fetchRequest()
        
        do {
            if let cdProfile = try context.fetch(request).first {
                return cdProfile.toUserProfile()
            }
        } catch {
            print("❌ Fetch profile error: \(error)")
        }
        return nil
    }
    
    // Weight Entries
    func saveWeightEntry(_ entry: WeightEntry) {
        let cdEntry = CDWeightEntry(context: context)
        cdEntry.id = UUID(uuidString: entry.id) ?? UUID()
        cdEntry.weight = entry.weight
        cdEntry.date = entry.date
        cdEntry.notes = entry.note
        saveContext()
    }
    
    func fetchWeightEntries() -> [WeightEntry] {
        let request: NSFetchRequest<CDWeightEntry> = CDWeightEntry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let cdEntries = try context.fetch(request)
            return cdEntries.map { $0.toWeightEntry() }
        } catch {
            print("❌ Fetch weight entries error: \(error)")
            return []
        }
    }
    
    func deleteWeightEntry(_ entry: WeightEntry) {
        let request: NSFetchRequest<CDWeightEntry> = CDWeightEntry.fetchRequest()
        if let uuid = UUID(uuidString: entry.id) {
            request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
            
            do {
                if let cdEntry = try context.fetch(request).first {
                    context.delete(cdEntry)
                    saveContext()
                }
            } catch {
                print("❌ Delete weight entry error: \(error)")
            }
        }
    }
    
    // Hydration
    func saveHydrationEntry(_ entry: HydrationEntry) {
        // Find today's entry or create new
        let request: NSFetchRequest<CDHydrationEntry> = CDHydrationEntry.fetchRequest()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        
        do {
            let results = try context.fetch(request)
            let cdEntry = results.first ?? CDHydrationEntry(context: context)
            
            if cdEntry.id == nil {
                cdEntry.id = UUID()
            }
            
            cdEntry.date = Date()
            cdEntry.consumedMl = Int32(entry.consumedMl)
            cdEntry.targetMl = Int32(entry.targetMl)
            
            saveContext()
        } catch {
            print("❌ Save hydration error: \(error)")
        }
    }
    
    func fetchTodayHydration() -> HydrationEntry? {
        let request: NSFetchRequest<CDHydrationEntry> = CDHydrationEntry.fetchRequest()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        
        do {
            if let cdEntry = try context.fetch(request).first {
                return cdEntry.toHydrationEntry()
            }
        } catch {
            print("❌ Fetch hydration error: \(error)")
        }
        return nil
    }
}

// MARK: - CoreData Entity Extensions

extension CDFastingSession {
    func toFastingSession() -> FastingSession {
        return FastingSession(
            id: id ?? UUID(),
            planId: planId ?? UUID(),
            startDate: startDate ?? Date(),
            endDate: endDate,
            isCompleted: isCompleted,
            actualFastingHours: actualFastingHours
        )
    }
}

extension CDUserProfile {
    func toUserProfile() -> UserProfile {
        return UserProfile(
            level: Int(level),
            totalCompletedFasts: Int(totalCompletedFasts),
            longestStreak: Int(longestStreak),
            currentStreak: Int(currentStreak),
            lastFastingDate: lastFastingDate,
            totalHoursFasted: totalHoursFasted,
            notificationPreferences: NotificationPreferences()
        )
    }
}

extension CDWeightEntry {
    func toWeightEntry() -> WeightEntry {
        return WeightEntry(
            id: (id ?? UUID()).uuidString,
            date: date ?? Date(),
            weight: weight,
            unit: .kg,
            note: notes
        )
    }
}

extension CDHydrationEntry {
    func toHydrationEntry() -> HydrationEntry {
        return HydrationEntry(
            consumedMl: Int(consumedMl),
            targetMl: Int(targetMl)
        )
    }
}
