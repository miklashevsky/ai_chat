import Foundation
import SwiftData

@MainActor
class HistoryViewModel: ObservableObject {
    let container: DIContainer
    
    @Published var sections: [HistorySection] = []
    
    @objc dynamic var selectedDialogeId: String? {
        get { return UserDefaults.standard.string(forKey: UserDefaultsKey.selectedDialogeId) }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.selectedDialogeId) }
    }
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter
    }()
    
    init(container: DIContainer) {
        self.container = container
        fetchData()
    }
    
    func selectDialogeId(_ dialogeId: String) {
        selectedDialogeId = dialogeId
    }
    
    func deleteItems(at offsets: IndexSet, in section: HistorySection) {
        offsets.forEach { offset in
            let dialogeId = section.items[offset].dialogeId
            if let sectionIndex = sections.firstIndex(of: section) {
                sections[sectionIndex].items.remove(at: offset)
                if sections[sectionIndex].items.isEmpty {
                    sections.remove(at: sectionIndex)
                }
            }
            
            try? container.services.dbModel.mainContext.delete(model: Dialoge.self,
                                                               where: #Predicate { $0.id == dialogeId })
        }
        try? container.services.dbModel.mainContext.save()
    }
    
    private func fetchData() {
        let descriptor = FetchDescriptor<Dialoge>(sortBy: [SortDescriptor(\.date)])
        if let dialoges = try? container.services.dbModel.mainContext.fetch(descriptor) {
            splitToSections(dialoges: dialoges)
        }
    }
    
    private func splitToSections(dialoges: [Dialoge]) {
        let groupedByDate: [Date: [Dialoge]] = Dictionary(grouping: dialoges,
                                                          by: { Calendar.current.startOfDay(for: $0.date) })
        
        sections = groupedByDate
            .sorted(by: { $0.key > $1.key })
            .map { key, value in
                    .init(id: UUID().uuidString,
                          title: dateFormatter.string(from: key),
                          items: value.map {
                        .init(title: $0.title, dialogeId: $0.id)
                    })
            }
    }
}
