import Foundation
import CoreData

@objc(CDFastingSession)
public class CDFastingSession: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var planId: UUID?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var actualFastingHours: Double
}

extension CDFastingSession {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDFastingSession> {
        return NSFetchRequest<CDFastingSession>(entityName: "CDFastingSession")
    }
}
