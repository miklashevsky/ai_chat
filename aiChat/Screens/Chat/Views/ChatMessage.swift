import SwiftUI

struct ChatMessage: View {
    private static let horizontalOffset: CGFloat = 30.0
    
    let text: String
	@State var textInProgress: String = ""
	
    let isUser: Bool
	let shouldTriggerTyping: Bool
    
    let elements: [ChatViewModel.ContextAction]
	let onTypingUpdate: () -> Void
	let onTypingCompleted: () -> Void
    let onMenuAction: (ChatViewModel.ContextAction) -> Void
    
    var contentShape: UnevenRoundedRectangle {
        let cornerRadius: CGFloat = 20
        return .rect(topLeadingRadius: cornerRadius,
                     bottomLeadingRadius: isUser ? cornerRadius : 3,
                     bottomTrailingRadius: isUser ? 3 : cornerRadius,
                     topTrailingRadius: cornerRadius)
    }
	
	var shouldAnimateTyping: Bool {
		!isUser && shouldTriggerTyping
	}
	
	var textToDisplay: String {
		if typingTask != nil {
			return textInProgress
		} else {
			return text
		}
	}
	
	@State var typingTask: Task<Void, Error>?
    
    var body: some View {
        HStack {
            if isUser {
                Spacer(minLength: Self.horizontalOffset)
            }
			Text(textToDisplay)
                .padding(12)
                .foregroundColor(isUser ? .white : .labelsPrimary)
                .background(isUser ? .mainBlue : .backgroundSecond)
                .clipShape(contentShape)
                .contentShape(.contextMenuPreview, contentShape)
                .contextMenu(menuItems: {
                    ForEach(Array(elements.enumerated()), id: \.offset) { _, element in
                        if element == .divider {
                            Divider()
                        } else {
                            Button(action: { onMenuAction(element) }, label: {
                                Label(element.title, systemImage: element.systemImage)
                            })
                        }
                    }
                })
				.onAppear(perform: appearAnimation)
				.onDisappear(perform: {
					typingTask?.cancel()
				})
            if !isUser {
                Spacer(minLength: Self.horizontalOffset)
            }
        }
    }
	
	@MainActor
	func appearAnimation() {
		guard shouldAnimateTyping else { return }
		let iterator = AsyncTypingSequence(sourceString: text,
										   chunkSize: 5,
										   popDelay: 100_000_000)
		typingTask = Task {
			defer { typingTask = nil }
			for try await subString in iterator {
				if Task.isCancelled {
					return
				}
				textInProgress += subString
				onTypingUpdate()
			}
			onTypingCompleted()
			
		}
	}
}

struct LoadingIndicator: View {
    
    var body: some View {
        HStack {
            ProgressView()
                .padding(12)
                .background(.backgroundSecond)
                .progressViewStyle(CircularProgressViewStyle(tint: .labelsPrimary))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            Spacer()
        }
    }
}

#Preview {
    Color.backgroundPrimary
        .overlay(alignment: .top) {
            LazyVStack {
				ChatMessage(text: "Hello, how can I help you today?", isUser: false, shouldTriggerTyping: false, elements: [], onTypingUpdate: {}, onTypingCompleted: {}, onMenuAction: { _ in })
				ChatMessage(text: "How to make a backflip?", isUser: true, shouldTriggerTyping: false, elements: [], onTypingUpdate: {}, onTypingCompleted: {}, onMenuAction: { _ in })
            }
            .padding(.top, 20)
            .padding(.horizontal, 16)
            .padding(.bottom, 80)
        }
}
