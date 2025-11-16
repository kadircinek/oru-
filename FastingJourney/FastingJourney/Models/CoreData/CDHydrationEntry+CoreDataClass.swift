import Foundation
import CoreData

@objc(CDHydrationEntry)
public class CDHydrationEntry: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var consumedMl: Int32
    @NSManaged public var targetMl: Int32
}

extension CDHydrationEntry {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDHydrationEntry> {
        return NSFetchRequest<CDHydrationEntry>(entityName: "CDHydrationEntry")
    }
}
