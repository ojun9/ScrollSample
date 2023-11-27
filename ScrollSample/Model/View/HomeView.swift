//
//  HomeView.swift
//  ScrollSample
//
//  Created by jun on 2023/11/27.
//

import SwiftUI

struct HomeView: View {
    @State private var items: [Item] = [.red, .blue, .green, .yellow].compactMap {
        return .init(color: $0)
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                LoopingScrollView(items: items, width: 150, spacing: 10) { item in
                    RoundedRectangle(cornerRadius: 16)
                        .fill(item.color.gradient)
                }
                .frame(height: 150)
                .contentMargins(.horizontal, 15, for: .scrollContent)
            }
            .padding(.vertical, 8)
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    ContentView()
}
