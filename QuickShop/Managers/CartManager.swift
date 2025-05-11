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
    
    /// Adds, updates, or removes an item from the cart.
    ///
    /// If `quantity <= 0`, the product is removed from `items`.
    /// Otherwise, the product’s quantity is set to the provided value.
    /// After mutation, the new `items` dictionary is persisted.
    /// - Parameters:
    ///   - id: The `UUID` of the product to update.
    ///   - quantity: The new quantity for that product.
    func update(_ id: UUID, quantity: Int) {
        if quantity <= 0 {
            items.removeValue(forKey: id)
        } else {
            items[id] = quantity
        }
        
        save()
    }
    
    /// Encodes the current `items` dictionary as JSON and writes it to `cartData`
    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            cartData = data
        }
    }
}
