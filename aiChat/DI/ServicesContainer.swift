import SwiftData

extension DIContainer {
    struct Services {
        let networkService: Networkable
        let dbModel: ModelContainer
        
        init(networkService: Networkable, dbModel: ModelContainer) {
            self.networkService = networkService
            self.dbModel = dbModel
        }
        
        static var stub: Self {
            .init(networkService: NetworkStub(),
                  dbModel: try! ModelContainer(for: DialogeLine.self, Dialoge.self))
        }
    }
}
