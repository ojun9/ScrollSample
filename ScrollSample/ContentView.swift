//
//  ContentView.swift
//  ScrollSample
//
//  Created by jun on 2023/11/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView()
                .navigationTitle("Looping ")
        }
    }
}

#Preview {
    ContentView()
}
