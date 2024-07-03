import SwiftUI

struct ChatHeader: View {
    
    let popoverElements: [ChatViewModel.PopoverMenuAction]
    let onPopoverAction: (ChatViewModel.PopoverMenuAction) -> Void
    
    @State private var isPopoverMenuPresented: Bool = false
    
    var body: some View {
        HStack {
            Button(action: {}, label: {
                Image("chat/progress_logo")
            })
            .frame(width: 36, height: 36)
            Spacer()
            Button(action: {
                isPopoverMenuPresented.toggle()
            }, label: {
                HStack(spacing: 0) {
                    Text("ChatGPT")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.labelsPrimary)
                        .padding(.trailing, 3)
                    Text("3.5")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.labelsSecond)
                    Circle()
                        .foregroundStyle(Color.backgroundSecond)
                        .overlay {
                            Image("chat/menu_dots")
                        }
                        .padding(.leading, 10)
                }
                
            })
            .frame(height: 36)
            .popover(isPresented: $isPopoverMenuPresented,
                     attachmentAnchor: .point(.bottom),
                     content: {
                ChatPopover(elements: popoverElements,
                            onPopoverAction: { action in
                    isPopoverMenuPresented = false
                    onPopoverAction(action)
                })
            })
        }
        .frame(height: 56)
    }
}

#Preview {
    Color.backgroundPrimary
        .safeAreaInset(edge: .top) {
            ChatHeader(popoverElements: [.history, .newChat, .settings, .upgrade],
                       onPopoverAction: { _ in })
            .padding(.horizontal, 16)
        }
}
