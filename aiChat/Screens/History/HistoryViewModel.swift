import Foundation

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
        dateFormatter.locale = Locale(identifier: "en_GB")
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
		var ids: [UUID] = []
        offsets.forEach { offset in
            let dialogeId = section.items[offset].dialogeId
			if let dialogeUUID = UUID(uuidString: dialogeId) {
				ids.append(dialogeUUID)
			}
			
            if let sectionIndex = sections.firstIndex(of: section) {
                sections[sectionIndex].items.remove(at: offset)
                if sections[sectionIndex].items.isEmpty {
                    sections.remove(at: sectionIndex)
                }
            }
        }
		
		container.services.dataBase.deleteDialoges(ids: ids)
    }
    
	private func fetchData() {
		let dialoges = container.services.dataBase.fetchDialoges()
		splitToSections(dialoges: dialoges)
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
						.init(title: $0.title, dialogeId: $0.id.uuidString)
                    })
            }
    }
}
