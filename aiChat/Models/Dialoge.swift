import Foundation
import CoreData

@objc(Dialoge)
public class Dialoge: NSManagedObject {
}

extension Dialoge {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dialoge> {
        return NSFetchRequest<Dialoge>(entityName: "Dialoge")
    }
    
    @NSManaged public var customTitle: String?
    @NSManaged public var date: Date
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var dialogeLine: NSOrderedSet?
    
}

// MARK: Generated accessors for dialogeLine
extension Dialoge {
    
    @objc(insertObject:inDialogeLineAtIndex:)
    @NSManaged public func insertIntoDialogeLine(_ value: DialogeLine, at idx: Int)
    
    @objc(removeObjectFromDialogeLineAtIndex:)
    @NSManaged public func removeFromDialogeLine(at idx: Int)
    
    @objc(insertDialogeLine:atIndexes:)
    @NSManaged public func insertIntoDialogeLine(_ values: [DialogeLine], at indexes: NSIndexSet)
    
    @objc(removeDialogeLineAtIndexes:)
    @NSManaged public func removeFromDialogeLine(at indexes: NSIndexSet)
    
    @objc(replaceObjectInDialogeLineAtIndex:withObject:)
    @NSManaged public func replaceDialogeLine(at idx: Int, with value: DialogeLine)
    
    @objc(replaceDialogeLineAtIndexes:withDialogeLine:)
    @NSManaged public func replaceDialogeLine(at indexes: NSIndexSet, with values: [DialogeLine])
    
    @objc(addDialogeLineObject:)
    @NSManaged public func addToDialogeLine(_ value: DialogeLine)
    
    @objc(removeDialogeLineObject:)
    @NSManaged public func removeFromDialogeLine(_ value: DialogeLine)
    
    @objc(addDialogeLine:)
    @NSManaged public func addToDialogeLine(_ values: NSOrderedSet)
    
    @objc(removeDialogeLine:)
    @NSManaged public func removeFromDialogeLine(_ values: NSOrderedSet)
    
}

extension Dialoge : Identifiable {
    
}

extension Dialoge {
    convenience init(context: NSManagedObjectContext, title: String) {
        self.init(context: context)
        self.date = Date()
        self.id = UUID()
        self.title = title
    }
}
