import Foundation

protocol Networkable: Actor {
    func requestChat(query: ChatQuery) async throws -> ChatResult
}

actor NetworkStub: Networkable {
    func requestChat(query: ChatQuery) async throws -> ChatResult {
        try? await Task.sleep(nanoseconds: 1_000_000_000 * 3)
        let newLine: ChatLine = .init(role: .system,
                                      text: ["That's an interesting question! It really depends on various factors and the specific context. Generally, it's best to gather as much information as possible, weigh the pros and cons, and consider the potential outcomes before making a decision. Seeking advice from experts or those with experience can also provide valuable insights.",
                                             "This topic has been widely debated, and there are multiple perspectives to consider. Some people argue in favor of one approach, while others support an alternative. Ultimately, it boils down to individual preferences and circumstances. It’s important to stay informed, keep an open mind, and continually reassess your stance as new information becomes available.",
                                             "The answer to that question can vary depending on the circumstances and specific details involved. In general, it’s advisable to thoroughly research the topic, consult with knowledgeable individuals, and consider all possible outcomes before forming a conclusion. Additionally, being open to different viewpoints can lead to a more well-rounded understanding of the issue.",
                                             "Thank you for bringing this to my attention. I'll look into it. I'll look into it. I'll look into it. I'll look into it.Thank you for bringing this to my attention. I'll look into it. I'll look into it. I'll look into it. I'll look into it.",
                                             "While there's no one-size-fits-all answer to this question, it's essential to approach it thoughtfully. Consider the various aspects and implications involved, and try to gather diverse opinions. Sometimes, taking a step back to reflect can provide new insights. Ultimately, the best course of action may depend on your personal goals and values."].randomElement()
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
