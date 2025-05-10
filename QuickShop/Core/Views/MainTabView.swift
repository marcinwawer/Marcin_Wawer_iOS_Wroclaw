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
            NavigationStack {
                BrowseView()
            }
            .tabItem {
                Label("Browse", systemImage: "square.grid.3x3")
            }
            
            NavigationStack {
                Image(systemName: "clock")
            }
            .tabItem {
                Label("Checkout", systemImage: "clock")
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(DeveloperPreview.shared.shopVM)
}
