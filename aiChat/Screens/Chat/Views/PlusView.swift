import SwiftUI

struct PlusView: View {
    private let bottomOffset: CGFloat = 50
    private let menuItemHeight: CGFloat = 50
    private let menuItemSpacing: CGFloat = 10
    
    @Binding var isPlusPresented: Bool
    let elements: [ChatViewModel.PlusMenuAction]
    let namespace: Namespace.ID
    let onMenuAction: (ChatViewModel.PlusMenuAction) -> Void
    @State var plusMenuListPresented: Bool = false
    
    var body: some View {
        Color.white.opacity(0.01)
            .ignoresSafeArea()
            .onTapGesture(perform: {
                plusMenuListPresented.toggle()
            })
            .overlay(alignment: .bottomLeading) {
                Circle()
                    .foregroundStyle(Color.backgroundSecond)
                    .frame(width: CGFloat(elements.count) * (menuItemHeight + menuItemSpacing))
                    .scaleEffect(CGSize(width: plusMenuListPresented ? 1 : 0.1, height: plusMenuListPresented ? 1 : 0.1), anchor: .bottomLeading)
                    .offset(x: plusMenuListPresented ? (-2 * menuItemHeight * 0.7) : 22,
                            y: plusMenuListPresented ? (-2 * menuItemHeight) : -22)
                    .blur(radius: 40)
                    .opacity(0.8)
            }
            .overlay(alignment: .bottomLeading) {
                ZStack(alignment: .leading) {
                    ForEach(Array(elements.enumerated()), id: \.element) { index, element in
                        PlusElement(text: element.title, iconName: element.icon, onTap: {
                            plusMenuListPresented.toggle()
                            onMenuAction(element)
                        })
                        .frame(height: menuItemHeight)
                        .offset(x: 40,
                                y: plusMenuListPresented ?
                                CGFloat(elements.count - index) * -(menuItemHeight + menuItemSpacing) - bottomOffset :
                                    -menuItemHeight)
                    }
                }
                .blur(radius: plusMenuListPresented ? 0 : 10)
                .opacity(plusMenuListPresented ? 1 : 0)
                .scaleEffect(CGSize(width: plusMenuListPresented ? 1 : 0.7, height: plusMenuListPresented ? 1 : 0.7), anchor: .bottomLeading)
            }
            .onAppear(perform: {
                plusMenuListPresented = true
            })
			.onChange(of: plusMenuListPresented, perform: { newValue in
                isPlusPresented = newValue
            })
            .overlay(alignment: .bottomLeading) {
                Button(action: {
                    plusMenuListPresented.toggle()
                }, label: {
                    ZStack {
                        Color.clear
                        Image(systemName: "plus")
                            .foregroundStyle(Color.labelsPrimary)
                            .rotationEffect(.degrees(isPlusPresented ? 45 : 0))
                    }
                })
                .frame(width: 44, height: 44)
                .background(Color.backgroundSecond)
                .clipShape(Circle())
                .matchedGeometryEffect(id: "isPlusPresented",
                                       in: namespace,
                                       properties: [.frame, .position, .size])
                .padding(30)
            }
            .animation(.bouncy, value: plusMenuListPresented)
    }
    
    struct PlusElement: View {
        let text: String
        let iconName: String
        let onTap: () -> Void
        
        var body: some View {
            Button(action: onTap,
                   label: {
                HStack {
                    Image("plus_menu/\(iconName)")
                    Text(text)
                        .font(.system(size: 22))
                        .foregroundStyle(Color.labelsPrimary)
                }
            })
        }
    }
}

#Preview {
    struct PlusView_Preview: View {
        
        @Namespace var namespace
        @State private var isPlusMenuPresented: Bool = true
        
        var body: some View {
            Color.backgroundPrimary
                .onTapGesture {
                    isPlusMenuPresented.toggle()
                }
                .overlay(alignment: .bottom) {
                    if isPlusMenuPresented {
                        PlusView(isPlusPresented: $isPlusMenuPresented,
                                 elements: [.generate, .addFromGallery, .addFromBookmarks, .camera, .photos],
                                 namespace: namespace,
                                 onMenuAction: { _ in })
                    }
                }
                .animation(.easeInOut, value: isPlusMenuPresented)
        }
    }
    
    return PlusView_Preview()
}
