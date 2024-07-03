import SwiftUI
import Combine

struct DIContainer: EnvironmentKey {
    
    let services: Services
    
    static var defaultValue: Self { Self.default }
    
    private static let `default` = DIContainer(services: .stub)
    
    init(services: DIContainer.Services) {
        self.services = services
    }
}

#if DEBUG
extension DIContainer {
    static var preview: Self {
        .init(services: .stub)
    }
}
#endif
