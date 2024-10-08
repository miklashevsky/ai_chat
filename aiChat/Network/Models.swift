import Foundation

struct ChatQuery: Equatable, Codable {
    let messages: [ChatLine]
}

struct ChatResult: Codable, Equatable {
    let messages: [ChatLine]
}

struct ChatLine: Codable, Equatable {
    
    let role: Role
    let text: String?
    
    enum Role: String, Codable, Equatable {
        case system
        case user
    }
}

extension ChatLine {
    func toDialogeLine() -> DialogeLine {
        let author: DialogeLine.Author
        switch role {
        case .system:
            author = .system
        case .user:
            author = .user
        }
        return .init(text: text ?? "", author: author)
    }
}
