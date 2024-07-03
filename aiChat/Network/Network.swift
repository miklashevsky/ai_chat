import Foundation

protocol Networkable: Actor {
    func requestChat(query: ChatQuery) async throws -> ChatResult
}

actor NetworkStub: Networkable {
    func requestChat(query: ChatQuery) async throws -> ChatResult {
        try? await Task.sleep(nanoseconds: 1_000_000_000 * 3)
        let newLine: ChatLine = .init(role: .system,
                                      text: ["Thank you for sharing your thoughts. I appreciate your perspective.",
                                             "That's an interesting point. I'll definitely consider it.",
                                             "I understand where you're coming from. Let's see how we can address this.",
                                             "Thank you for bringing this to my attention. I'll look into it.",
                                             "I appreciate your patience and understanding. Let's work on finding a solution together."].randomElement()
        )
        return .init(messages: query.messages + [newLine])
    }
}

actor Network: Networkable {
    func requestChat(query: ChatQuery) async throws -> ChatResult {
        try? await Task.sleep(nanoseconds: 1_000_000_000 * 1)
        return .init(messages: query.messages)
    }
}
