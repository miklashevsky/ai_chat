import SwiftUI

struct ChatFooter: View {
    private static let minHeight: CGFloat = 44
    
    @Binding var text: String
    @Binding var isPlusPresented: Bool
    
    @FocusState var isFocused: Bool
    let namespace: Namespace.ID
    
    let onTap: () -> Void
    
    var shouldShowChat: Bool {
        !text.isEmpty
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            if !isPlusPresented {
                Button(action: {
                    Haptic.impact(.light)
                    isPlusPresented.toggle()
                }, label: {
                    ZStack {
                        Color.clear
                        Image(systemName: "plus")
                            .foregroundStyle(Color.labelsPrimary)
                            .rotationEffect(.degrees(isPlusPresented ? 45 : 0))
                    }
                })
                .frame(width: Self.minHeight, height: Self.minHeight)
                .background(Color.backgroundSecond)
                .clipShape(Circle())
                .matchedGeometryEffect(id: "isPlusPresented",
                                       in: namespace,
                                       properties: [.frame, .position, .size])
            } else {
                Spacer()
                    .frame(width: 100, height: Self.minHeight)
            }
            
            HStack(alignment: .bottom) {
                TextField("Message AI Chat", text: $text, axis: .vertical)
                    .focused($isFocused)
                    .lineLimit(1...5)
                    .padding(10)
                if shouldShowChat {
                    Button(action: {
                        Haptic.impact(.light)
                        onTap()
                    }, label: {
                        ZStack {
                            Color.clear
                            Image(systemName: "arrow.up")
                                .foregroundStyle(Color.white)
                        }
                    })
                    .frame(width: 32, height: 32)
                    .background(Color.mainBlue)
                    .clipShape(Circle())
                    .padding(6)
                    .transition(.scale(scale: 0.3).combined(with: .opacity))
                }
            }
            .frame(minHeight: Self.minHeight)
            .animation(.easeInOut(duration: 0.1), value: shouldShowChat)
            .background(.backgroundSecond)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

#Preview {
    @Namespace var namespace
    return Color.backgroundPrimary
        .overlay(
            ChatFooter(text: .constant("Is it really possible that all planets in our solar system can align? If so, explain why this happens."),
                       isPlusPresented: .constant(false),
                       namespace: namespace,
                       onTap: {})
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            , alignment: .bottom
        )
}
