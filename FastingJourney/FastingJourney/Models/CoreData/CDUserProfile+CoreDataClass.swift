import Foundation
import CoreData

@objc(CDUserProfile)
public class CDUserProfile: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var totalCompletedFasts: Int32
    @NSManaged public var totalHoursFasted: Double
    @NSManaged public var currentStreak: Int32
    @NSManaged public var longestStreak: Int32
    @NSManaged public var level: Int32
    @NSManaged public var lastFastingDate: Date?
}

extension CDUserProfile {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUserProfile> {
        return NSFetchRequest<CDUserProfile>(entityName: "CDUserProfile")
    }
}
