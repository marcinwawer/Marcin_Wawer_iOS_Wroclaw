//
//  MainTabView.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Image(systemName: "square.grid.3x3")
                .tabItem {
                    Label("Browse", systemImage: "square.grid.3x3")
                }
            
            Image(systemName: "clock")
                .tabItem {
                    Label("Checkout", systemImage: "clock")
                }
        }
    }
}

#Preview {
    MainTabView()
}
