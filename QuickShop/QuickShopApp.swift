//
//  QuickShopApp.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import SwiftUI

@main
struct QuickShopApp: App {
    @StateObject private var shopVM = ShopViewModel()
    
    init() {
        let args = ProcessInfo.processInfo.arguments
        if args.contains("--reset-state") {
            UserDefaults.standard.removeObject(forKey: "cartItems")
            UserDefaults.standard.removeObject(forKey: "favoriteProductIDs")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(shopVM)
        }
    }
}
