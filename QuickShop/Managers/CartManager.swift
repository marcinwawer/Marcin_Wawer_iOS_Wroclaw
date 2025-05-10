//
//  CartManager.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import SwiftUI

@MainActor
final class CartManager {
    @AppStorage("cartItems") private var cartData: Data = Data()
    @Published private(set) var items: [UUID: Int] = [:]
    
    init() {
        if let decodedDict = try? JSONDecoder().decode([UUID: Int].self, from: cartData) {
            items = decodedDict
        }
    }
    
    func update(_ id: UUID, quantity: Int) {
        if quantity <= 0 {
            items.removeValue(forKey: id)
        } else {
            items[id] = quantity
        }
        
        save()
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            cartData = data
        }
    }
}
