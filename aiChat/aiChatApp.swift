import SwiftUI

@main
struct aiChat: App {
    
    let container = DIContainer(services: .stub)
    
    var body: some Scene {
        WindowGroup {
            ChatView(model: .init(container: container))
        }
    }
}
