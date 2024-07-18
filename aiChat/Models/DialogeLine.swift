import Foundation
import CoreData

@objc(DialogeLine)
public class DialogeLine: NSManagedObject {
}

extension DialogeLine {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DialogeLine> {
        return NSFetchRequest<DialogeLine>(entityName: "DialogeLine")
    }
    
    @NSManaged public var date: Date
    @NSManaged public var id: UUID
    @NSManaged public var authorEnum: Int16
    @NSManaged public var text: String
    @NSManaged public var dialoge: Dialoge?
    
}

extension DialogeLine : Identifiable {
    
}

extension DialogeLine {
    @objc public enum Author: Int16 {
        case user, system
    }
    
    public var author: Author {
        get { Author(rawValue: authorEnum) ?? .system }
        set { authorEnum = newValue.rawValue }
    }
}

extension DialogeLine {
    convenience init(context: NSManagedObjectContext, text: String, author: Author) {
        self.init(context: context)
        self.date = Date()
        self.id = UUID()
        self.text = text
        self.author = author
    }
}
