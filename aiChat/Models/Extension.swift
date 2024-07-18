import Foundation

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
