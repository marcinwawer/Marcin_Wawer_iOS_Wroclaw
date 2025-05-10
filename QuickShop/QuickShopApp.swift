//
//  QuickShopApp.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import SwiftUI

@main
struct QuickShopApp: App {
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var cartManager = CartManager()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(
                    ShopViewModel(
                        favoritesManager: favoritesManager,
                        cartManager: cartManager
                    )
                )
        }
    }
}
