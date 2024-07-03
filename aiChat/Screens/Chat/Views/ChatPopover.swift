import SwiftUI

struct ChatPopover: View {
    
    let elements: [ChatViewModel.PopoverMenuAction]
    let onPopoverAction: (ChatViewModel.PopoverMenuAction) -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(elements, id: \.self) { element in
                    Button {
                        onPopoverAction(element)
                    } label: {
                        HStack {
                            Text(element.title)
                            Spacer()
                            Image(systemName: element.icon)
                        }
                            .foregroundColor(.labelsPrimary)
                    }
                    .frame(minHeight: 30)
                    if elements.last.self != element.self {
                        Divider()
                            .padding(.horizontal, -20)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
        .background(Color.backgroundSecond)
        .presentationCompactAdaptation(.popover)
    }
}

#Preview {
    Color.backgroundPrimary
        .overlay(alignment: .top) {
            Button(action: {}, label: {
                Text("Parent")
            })
            .popover(isPresented: .constant(true),
                     attachmentAnchor: .point(.bottom),
                     content: {
                ChatPopover(elements: [.history, .newChat, .settings, .upgrade],
                            onPopoverAction: { _ in })
                    .presentationCompactAdaptation(.popover)
            })
        }
}
