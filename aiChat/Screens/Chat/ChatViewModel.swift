import Foundation

@MainActor
class ChatViewModel: ObservableObject {
    let container: DIContainer
    
    let plusMenuElements: [PlusMenuAction] = [.generate, .addFromGallery, .addFromBookmarks, .camera, .photos]
    let popoverMenuElements: [PopoverMenuAction] = [.history, .newChat, .settings, .upgrade]
    let contextMenuElements: [ContextAction] = [.copy, .select, .read, .divider, .share, .divider, .resend, .addToBookmark]
    
    var messages: [DialogeLine] {
		guard let lines = dialoge?.dialogeLine?.array as? [DialogeLine] else { return [] }
		
		return lines.sorted(by: { lh, rh in
            lh.date < rh.date
        })
    }
    
    @Published var isWaitingForResponce: Bool = false
    @Published var shouldTriggerTyping: Bool = false
    
    private var pendingRequestTask: Task<Void, Never>?
	private var dialoge: Dialoge?
    
    @objc dynamic var selectedDialogeId: String? {
        get { return UserDefaults.standard.string(forKey: UserDefaultsKey.selectedDialogeId) }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.selectedDialogeId) }
    }
    
    init(container: DIContainer) {
        self.container = container
        fetchData()
    }
    
    func contextMenuAction(_ action: ContextAction) {
        print("action: \(action.title)")
    }
    
    func plusMenuAction(_ action: PlusMenuAction) {
        print("action: \(action.title)")
    }
    
    func popoverMenuAction(_ action: PopoverMenuAction) {
        print("action: \(action.title)")
        switch action {
        case .newChat:
            makeNewDialoge()
        default: break
        }
    }
    
    func sendMessage(text: String) {
        isWaitingForResponce = true
        
		let dialogeLine = container.services.dataBase.makeDialogeLine(text: text, author: .user)
        addDialogeLine(dialogeLine)
        let messagesForRequest = Array(messages.suffix(4)) // using only last 4 elements to decrease token load
        
        let expectedChats: [ChatLine] = messagesForRequest.map { $0.toChatLine() }

        let query = ChatQuery(messages: expectedChats)
        pendingRequestTask?.cancel()
        pendingRequestTask = requestTask(query: query)
    }
    
    func fetchData() {
        pendingRequestTask?.cancel()
        isWaitingForResponce = false
        guard let selectedDialogeId = selectedDialogeId,
              let dialoge = fetchDialogesForExisingId(dialogeId: selectedDialogeId) else {
            dialoge = nil
            return
        }
        self.dialoge = dialoge
    }
    
    private func makeNewDialoge() {
        selectedDialogeId = nil
        fetchData()
    }
    
	private func fetchDialogesForExisingId(dialogeId: String) -> Dialoge? {
		if let id = UUID(uuidString: dialogeId) {
			return container.services.dataBase.fetchDialoge(id: id)
		}
		return nil
	}
    
    private func makeEmptyDialoge() -> Dialoge {
		let dialoge = container.services.dataBase.makeDialoge(title: "")
		self.dialoge = dialoge
		container.services.dataBase.addDialoge(dialoge)
		selectedDialogeId = dialoge.id.uuidString
		return dialoge
    }
    
    private func addDialogeLine(_ message: DialogeLine) {
        let dialoge = self.dialoge ?? makeEmptyDialoge()
        dialoge.date = .now
        dialoge.title = message.text
		
		container.services.dataBase.addDialogeLine(message, inDialoge: dialoge)
    }
    
    private func requestTask(query: ChatQuery) -> Task<Void, Never> {
        Task {
            do {
                let chats = try await container.services.networkService.requestChat(query: query)
                guard !Task.isCancelled else { throw NSError() }
                
                if let lastMessange = chats.messages.last {
					let dialogeLine = self.container.services.dataBase
						.makeDialogeLine(chatLine: lastMessange)
                    addDialogeLine(dialogeLine)
                    shouldTriggerTyping = true
                }
                
                Haptic.impact(.light)
                isWaitingForResponce = false
            } catch {
                Haptic.impact(.heavy)
                
                if pendingRequestTask == nil {
                    isWaitingForResponce = false
                }
            }
        }
    }
}
