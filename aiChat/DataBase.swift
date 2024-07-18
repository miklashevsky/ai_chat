import Foundation
import CoreData

class DataBase {
	private let container: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "aiChatModel")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	
	func deleteDialoges(ids: [UUID]) {
		let fetchRequest = Dialoge.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "id IN %@", ids as CVarArg)
		if let dialoges = try? container.viewContext.fetch(fetchRequest) {
			dialoges.forEach { dialoge in
				container.viewContext.delete(dialoge)
			}
		}
		
		try? container.viewContext.save()
	}
	
	func fetchDialoges() -> [Dialoge] {
		let fetchRequest = Dialoge.fetchRequest()
		let dialoges = try? container.viewContext.fetch(fetchRequest)
		return dialoges ?? []
	}
	
	func fetchDialoge(id: UUID) -> Dialoge? {
		let fetchRequest = Dialoge.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
		if let dialogeObjects = try? container.viewContext.fetch(fetchRequest),
		   let dialoge = dialogeObjects.first {
			return dialoge
		}
		
		return nil
	}
	
	func makeDialoge(title: String) -> Dialoge {
		Dialoge(context: container.viewContext, title: title)
	}
	
	func addDialoge(_ dialoge: Dialoge) {
		container.viewContext.insert(dialoge)
		try? container.viewContext.save()
	}
	
	func addDialogeLine(_ dialogeLine: DialogeLine, inDialoge dialoge: Dialoge) {
		dialoge.addToDialogeLine(dialogeLine)
		dialogeLine.dialoge = dialoge
		
		try? container.viewContext.save()
	}
	
	func makeDialogeLine(text: String, author: DialogeLine.Author) -> DialogeLine {
		DialogeLine(context: container.viewContext, text: text, author: author)
	}
	
	func makeDialogeLine(chatLine: ChatLine) -> DialogeLine {
		let author: DialogeLine.Author
		switch chatLine.role {
		case .system:
			author = .system
		case .user:
			author = .user
		}
		return DialogeLine(context: container.viewContext,
						   text: chatLine.text ?? "",
						   author: author)
	}
}
