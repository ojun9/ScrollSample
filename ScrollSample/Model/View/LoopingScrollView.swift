//
//  LoopingScrollView.swift
//  ScrollSample
//
//  Created by jun on 2023/11/27.
//

import SwiftUI

struct LoopingScrollView<
    Content: View,
    Item: RandomAccessCollection
>: View where Item.Element: Identifiable {
    
    var items: Item
    var width: CGFloat
    var spacing: CGFloat
    @ViewBuilder var content: (Item.Element) -> Content
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let repeatingCount = width > 0 ? Int((size.width / width).rounded()) + 1 : 1
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: spacing) {
                    ForEach(items) { item in
                        content(item)
                            .frame(width: width)
                    }
                    
                    ForEach(0..<repeatingCount, id: \.self) { index in
                        let item = Array(items)[index % items.count]
                        content(item)
                            .frame(width: width)
                    }
                }
                .background {
                    ScrollViewHelper(
                        width: width,
                        spacing: spacing,
                        itemCount: items.count,
                        repeatingCount: repeatingCount
                    )
                }
            }
        }
    }
}

private struct ScrollViewHelper: UIViewRepresentable {
    var width: CGFloat
    var spacing: CGFloat
    var itemCount: Int
    var repeatingCount: Int
    
    func makeUIView(context: Context) -> UIView {
        .init()
    }
    
    func makeCoordinator() -> Coordinator {
        .init(
            width: width,
            spacing: spacing,
            itemCount: itemCount,
            repeatingCount: repeatingCount
        )
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        print("updateUIView")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView,
                !context.coordinator.isAddDelegate {
                scrollView.delegate = context.coordinator
                context.coordinator.isAddDelegate = true
            }
        }
        
        context.coordinator.width = width
        context.coordinator.spacing = spacing
        context.coordinator.itemCount = itemCount
        context.coordinator.repeatingCount = repeatingCount
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var width: CGFloat
        var spacing: CGFloat
        var itemCount: Int
        var repeatingCount: Int
        var isAddDelegate = false
        
        init(width: CGFloat, spacing: CGFloat, itemCount: Int, repeatingCount: Int) {
            self.width = width
            self.spacing = spacing
            self.itemCount = itemCount
            self.repeatingCount = repeatingCount
        }
        
        // MARK: - UIScrollViewDelegate
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            guard itemCount > 0 else { return }
            let minX = scrollView.contentOffset.x
            let mainContenSize = CGFloat(itemCount) * width
            let spacingSize = CGFloat(itemCount) * spacing
            let totalContenSize = mainContenSize + spacingSize
            
            // ここで書き換えを行なっている

            if minX > totalContenSize {
                scrollView.contentOffset.x -= totalContenSize
            }
            
            if minX < 0 {
                scrollView.contentOffset.x += totalContenSize
            }
        }
    }
}

#Preview {
    ContentView()
}
