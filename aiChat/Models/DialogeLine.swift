import Foundation
import SwiftData

@Model
class DialogeLine {
    @Attribute(.unique) let id = UUID().uuidString
    let date: Date
    let text: String
    let author: Author
    
    enum Author: Codable {
        case user, system
    }
    
    init(date: Date = Date(), text: String, author: Author) {
        self.date = date
        self.text = text
        self.author = author
    }
}

extension DialogeLine {
    func toChatLine() -> ChatLine {
        let role: ChatLine.Role
        switch author {
        case .system:
            role = .system
        case .user:
            role = .user
        }
        return .init(role: role, text: text)
    }
}
