import Foundation

struct HistorySection: Hashable {
    let id: String
    let title: String
    var items: [HistoryItem]
    
    struct HistoryItem: Hashable {
        let title: String
        let dialogeId: String
    }
}
