import SwiftUI

struct ChatMessage: View {
    private static let horizontalOffset: CGFloat = 30.0
    
    let text: String
    let isUser: Bool
    
    let elements: [ChatViewModel.ContextAction]
    let onMenuAction: (ChatViewModel.ContextAction) -> Void
    
    var contentShape: UnevenRoundedRectangle {
        let cornerRadius: CGFloat = 20
        return .rect(topLeadingRadius: cornerRadius,
                     bottomLeadingRadius: isUser ? cornerRadius : 3,
                     bottomTrailingRadius: isUser ? 3 : cornerRadius,
                     topTrailingRadius: cornerRadius)
    }
    
    var body: some View {
        HStack {
            if isUser {
                Spacer(minLength: Self.horizontalOffset)
            }
            Text(text)
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
            if !isUser {
                Spacer(minLength: Self.horizontalOffset)
            }
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
                ChatMessage(text: "Hello, how can I help you today?", isUser: false, elements: [], onMenuAction: { _ in })
                ChatMessage(text: "How to make a backflip?", isUser: true, elements: [], onMenuAction: { _ in })
            }
            .padding(.top, 20)
            .padding(.horizontal, 16)
            .padding(.bottom, 80)
        }
}
