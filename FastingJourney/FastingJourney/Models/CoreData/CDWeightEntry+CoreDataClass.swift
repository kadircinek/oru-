import Foundation
import CoreData

@objc(CDWeightEntry)
public class CDWeightEntry: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var weight: Double
    @NSManaged public var date: Date?
    @NSManaged public var notes: String?
    @NSManaged public var photoData: Data?
}

extension CDWeightEntry {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDWeightEntry> {
        return NSFetchRequest<CDWeightEntry>(entityName: "CDWeightEntry")
    }
}
