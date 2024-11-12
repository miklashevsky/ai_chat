import Foundation

extension DIContainer {
    struct Services {
        let networkService: Networkable
		let dataBase = DataBase()
        
        init(networkService: Networkable) {
            self.networkService = networkService
        }
        
        static var stub: Self {
            .init(networkService: NetworkStub())
        }
    }
}
