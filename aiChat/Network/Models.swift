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
