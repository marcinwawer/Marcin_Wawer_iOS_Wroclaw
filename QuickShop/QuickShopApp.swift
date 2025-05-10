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
    
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(shopVM)
        }
    }
}
