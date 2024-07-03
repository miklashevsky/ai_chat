import SwiftUI

@MainActor
struct HistoryView: View {
    
    @StateObject private var model: HistoryViewModel
    
    @Binding var isPresented: Bool
    let onUpdateDialoges: () -> Void
    
    init(model: HistoryViewModel,
         isPresented: Binding<Bool>,
         onUpdateDialoges: @escaping () -> Void) {
        _model = StateObject(wrappedValue: model)
        _isPresented = isPresented
        self.onUpdateDialoges = onUpdateDialoges
    }
    
    var body: some View {
        NavigationView {
            List(model.sections, id: \.self) { section in
                Section(header: Text(section.title)) {
                    ForEach(section.items, id: \.self) { item in
                        Button(action: {
                            model.selectDialogeId(item.dialogeId)
                            onUpdateDialoges()
                            isPresented = false
                        }, label: {
                            Text(item.title)
                                .lineLimit(2)
                        })
                        .foregroundStyle(Color.labelsPrimary)
                    }
                    .onDelete(perform: { indexSet in
                        model.deleteItems(at: indexSet, in: section)
                        onUpdateDialoges()
                    })
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
        }
        .animation(.easeInOut, value: model.sections)
    }
}

#Preview {
    Color.backgroundPrimary
        .sheet(isPresented: .constant(true), content: {
            HistoryView(model: .init(container: .preview),
                        isPresented: .constant(true),
                        onUpdateDialoges: { })
            .presentationDetents([.medium, .large], selection: .constant(.medium))
        })
}
