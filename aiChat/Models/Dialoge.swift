import Foundation
import SwiftData

@Model
class Dialoge {
    @Attribute(.unique) let id = UUID().uuidString
    var date: Date
    var title: String
    var customTitle: String?
    
    @Relationship(deleteRule: .cascade) var messages = [DialogeLine]()
    
    init(date: Date = Date(), title: String, messages: [DialogeLine]) {
        self.date = date
        self.title = title
        self.messages = messages
    }
}
