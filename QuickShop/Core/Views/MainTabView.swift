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
                    .accessibilityIdentifier("BrowseView")
            }
            .tabItem {
                Label("Browse", systemImage: "square.grid.3x3")
                    .accessibilityLabel("Browse Products")
                    .accessibilityHint("Opens the product catalog")
            }
            
            NavigationStack {
                CheckoutView()
                    .accessibilityIdentifier("CheckoutView")
            }
            .tabItem {
                Label("Checkout", systemImage: "clock")
                    .accessibilityLabel("Order Products")
                    .accessibilityHint("Shows products in your cart and allows you to place an order")
            }
        }
        .accessibilityElement(children: .contain)
    }
}

#Preview {
    MainTabView()
        .environmentObject(DeveloperPreview.shared.shopVM)
}
