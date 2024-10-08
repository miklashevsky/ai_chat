import SwiftUI

@MainActor
struct ChatView: View {
    @StateObject private var model: ChatViewModel
    
    @State private var text: String = ""
    @State private var isPlusMenuPresented: Bool = false
    @State private var isHistoryPresented: Bool = false
    
    @Namespace var namespace
    @FocusState var isFocused: Bool
    @State private var historyDetent = PresentationDetent.medium
    
    init(model: ChatViewModel) {
        _model = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ScrollViewReader { reader in
                LazyVStack(spacing: 8) {
                    ForEach(model.messages) { message in
                        ChatMessage(text: message.text,
                                    isUser: message.author == .user,
                                    elements: model.contextMenuElements,
                                    onMenuAction: { model.contextMenuAction($0) })
                    }
                    if model.isWaitingForResponce {
                        LoadingIndicator()
                            .id(-1)
                    }
                }
                .padding(.horizontal, 16)
                .task {
                    guard let lastMessage = model.messages.last else { return }
                    reader.scrollTo(lastMessage.id)
                }
                .onChange(of: model.messages, {
                    guard let lastMessage = model.messages.last else { return }
                    withAnimation {
                        reader.scrollTo(lastMessage.id)
                    }
                })
                .onChange(of: model.isWaitingForResponce, { oldValue, newValue in
                    if newValue {
                        withAnimation {
                            reader.scrollTo(-1)
                        }
                    }
                })
                .onChange(of: isFocused) { oldValue, newValue in
                    guard newValue,
                          let lastMessage = model.messages.last else { return }
                    withAnimation {
                        reader.scrollTo(lastMessage.id)
                    }
                }
            }
        }
        .overlay {
            if model.messages.isEmpty {
                HStack {
                    Image("chat/chat_logo")
                        .foregroundStyle(Color.labelsPrimary)
                    Text("AI Chat")
                        .font(.system(size: 22))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.labelsPrimary)
                }
            }
        }
        .background(Color.backgroundPrimary)
        .mask(
            VStack(spacing: 0) {
                LinearGradient(gradient: Gradient(stops: [.init(color: .clear,
                                                                location: 0.0),
                                                          .init(color: .black,
                                                                location: 1.0)]),
                               startPoint: .top,
                               endPoint: .bottom)
                .frame(height: 120)
                Color.black
                LinearGradient(gradient: Gradient(stops: [.init(color: .black,
                                                                location: 0.0),
                                                          .init(color: .clear,
                                                                location: 1.0)]),
                               startPoint: .top,
                               endPoint: .bottom)
                .frame(height: 100)
            }
                .ignoresSafeArea(.container)
        )
        .onTapGesture {
            isFocused = false
        }
        .safeAreaInset(edge: .bottom, content: {
            ChatFooter(text: $text,
                       isPlusPresented: $isPlusMenuPresented,
                       isFocused: _isFocused,
                       namespace: namespace,
                       onTap: {
                model.sendMessage(text: text)
                text = ""
            })
            .padding(8)
        })
        .safeAreaInset(edge: .top, content: {
            ChatHeader(popoverElements: model.popoverMenuElements,
                       onPopoverAction: { action in
                if action == .history {
                    isHistoryPresented.toggle()
                }
                model.popoverMenuAction(action)
            })
            .padding(.horizontal, 14)
        })
        .blur(radius: isPlusMenuPresented ? 10 : 0)
        .overlay {
            if isPlusMenuPresented {
                PlusView(isPlusPresented: $isPlusMenuPresented,
                         elements: model.plusMenuElements,
                         namespace: namespace) { action in
                    model.plusMenuAction(action)
                }
            }
        }
        .animation(.easeInOut, value: isPlusMenuPresented)
        .sheet(isPresented: $isHistoryPresented, content: {
            HistoryView(model: .init(container: model.container),
                        isPresented: $isHistoryPresented,
                        onUpdateDialoges: {
                withAnimation {
                    model.fetchData()
                }
            })
                .presentationDetents([.medium, .large], selection: $historyDetent)
        })
    }
}

#Preview {
    ChatView(model: .init(container: .preview))
}
