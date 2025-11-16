import Foundation
import EventKit
import Combine

/// Manages calendar integration and event-based fasting suggestions
class CalendarManager: ObservableObject {
    static let shared = CalendarManager()
    
    @Published var isAuthorized = false
    @Published var upcomingEvents: [CalendarEvent] = []
    @Published var fastingSuggestion: String?
    
    private let eventStore = EKEventStore()
    
    private init() {
        checkAuthorization()
    }
    
    // MARK: - Authorization
    
    func requestAuthorization() {
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents { [weak self] granted, error in
                DispatchQueue.main.async {
                    self?.isAuthorized = granted
                    if granted {
                        self?.fetchUpcomingEvents()
                    }
                }
            }
        } else {
            eventStore.requestAccess(to: .event) { [weak self] granted, error in
                DispatchQueue.main.async {
                    self?.isAuthorized = granted
                    if granted {
                        self?.fetchUpcomingEvents()
                    }
                }
            }
        }
    }
    
    func requestAccess(completion: @escaping (Bool) -> Void) {
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents { granted, error in
                if let error = error {
                    print("Calendar access error: \(error.localizedDescription)")
                }
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        } else {
            eventStore.requestAccess(to: .event) { granted, error in
                if let error = error {
                    print("Calendar access error: \(error.localizedDescription)")
                }
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
    }
    
    private func checkAuthorization() {
        if #available(iOS 17.0, *) {
            let status = EKEventStore.authorizationStatus(for: .event)
            isAuthorized = (status == .fullAccess)
        } else {
            let status = EKEventStore.authorizationStatus(for: .event)
            isAuthorized = (status == .authorized)
        }
        
        if isAuthorized {
            fetchUpcomingEvents()
        }
    }
    
    // MARK: - Fetch Events
    
    func fetchUpcomingEvents() {
        guard isAuthorized else { return }
        
        let calendars = eventStore.calendars(for: .event)
        
        // Fetch events for next 7 days
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: 7, to: startDate) ?? startDate
        
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
        let events = eventStore.events(matching: predicate)
        
        // Convert to our model
        upcomingEvents = events.map { event in
            CalendarEvent(
                title: event.title,
                startDate: event.startDate,
                endDate: event.endDate,
                isAllDay: event.isAllDay,
                location: event.location
            )
        }
        
        // Generate fasting suggestions based on events
        generateFastingSuggestions()
    }
    
    // MARK: - Smart Suggestions
    
    private func generateFastingSuggestions() {
        guard !upcomingEvents.isEmpty else {
            fastingSuggestion = nil
            return
        }
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let tomorrowEnd = Calendar.current.date(byAdding: .day, value: 1, to: tomorrow) ?? tomorrow
        
        // Find tomorrow's events
        let tomorrowEvents = upcomingEvents.filter { event in
            event.startDate >= tomorrow && event.startDate < tomorrowEnd
        }
        
        if tomorrowEvents.isEmpty {
            fastingSuggestion = "📅 Your schedule looks clear tomorrow. You can try a longer fast (18/6 or 20/4)!"
            return
        }
        
        // Check for morning events
        let morningEvents = tomorrowEvents.filter { event in
            let hour = Calendar.current.component(.hour, from: event.startDate)
            return hour >= 6 && hour < 12
        }
        
        // Check for important/work events
        let importantEvents = tomorrowEvents.filter { event in
            event.title?.localizedCaseInsensitiveContains("meeting") == true ||
            event.title?.localizedCaseInsensitiveContains("interview") == true ||
            event.title?.localizedCaseInsensitiveContains("conference") == true ||
            event.title?.localizedCaseInsensitiveContains("presentation") == true
        }
        
        // Generate suggestions
        var suggestion = ""
        
        if !morningEvents.isEmpty {
            let firstEvent = morningEvents.first!
            let hourFormatter = DateFormatter()
            hourFormatter.dateFormat = "HH:mm"
            
            suggestion = "📅 Tomorrow morning at \(hourFormatter.string(from: firstEvent.startDate)) you have '\(firstEvent.title ?? "Event")'. We recommend a lighter fast like 12/12 or 14/10."
        } else if !importantEvents.isEmpty {
            suggestion = "📅 You have an important meeting tomorrow. To maintain energy levels, consider a moderate fast like 14/10 or 16/8."
        } else if tomorrowEvents.count >= 3 {
            suggestion = "📅 You have a busy day tomorrow (\(tomorrowEvents.count) events). You might prefer beginner programs like 12/12 or 14/10."
        } else {
            suggestion = "📅 You have \(tomorrowEvents.count) event(s) tomorrow. You can continue with your normal fasting schedule."
        }
        
        fastingSuggestion = suggestion
        
        // Send notification for tomorrow's plan
        if !suggestion.isEmpty {
            NotificationManager.shared.scheduleCalendarBasedSuggestion(message: suggestion)
        }
    }
    
    // MARK: - Check for Conflicts
    
    func checkFastingConflict(startTime: Date, endTime: Date) -> [CalendarEvent] {
        return upcomingEvents.filter { event in
            // Check if event overlaps with fasting window
            return event.startDate < endTime && event.endDate > startTime
        }
    }
    
    func hasImportantEventsDuring(hours: Int) -> Bool {
        let endDate = Calendar.current.date(byAdding: .hour, value: hours, to: Date()) ?? Date()
        
        let conflictingEvents = upcomingEvents.filter { event in
            event.startDate >= Date() && event.startDate < endDate &&
            (event.title?.localizedCaseInsensitiveContains("meeting") == true ||
             event.title?.localizedCaseInsensitiveContains("interview") == true ||
             event.title?.localizedCaseInsensitiveContains("conference") == true ||
             event.title?.localizedCaseInsensitiveContains("presentation") == true)
        }
        
        return !conflictingEvents.isEmpty
    }
    
    // MARK: - Recommended Plans
    
    func getRecommendedPlan() -> FastingPlan? {
        guard isAuthorized else { return nil }
        
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let tomorrowEnd = Calendar.current.date(byAdding: .day, value: 1, to: tomorrow) ?? tomorrow
        
        let tomorrowEvents = upcomingEvents.filter { event in
            event.startDate >= tomorrow && event.startDate < tomorrowEnd
        }
        
        // Busy day → shorter fast
        if tomorrowEvents.count >= 3 {
            return FastingPlan.allPlans.first { $0.name.contains("12/12") }
        }
        
        // Important events → moderate fast
        let hasImportant = tomorrowEvents.contains { event in
            event.title?.localizedCaseInsensitiveContains("toplantı") == true ||
            event.title?.localizedCaseInsensitiveContains("meeting") == true
        }
        
        if hasImportant {
            return FastingPlan.allPlans.first { $0.name.contains("14/10") }
        }
        
        // Free day → longer fast possible
        if tomorrowEvents.isEmpty {
            return FastingPlan.allPlans.first { $0.name.contains("18/6") }
        }
        
        // Default
        return FastingPlan.allPlans.first { $0.name.contains("16/8") }
    }
}

// MARK: - Models

struct CalendarEvent: Identifiable {
    let id = UUID()
    let title: String?
    let startDate: Date
    let endDate: Date
    let isAllDay: Bool
    let location: String?
}
