//
//  FavoritesManager.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import SwiftUI

@MainActor
final class FavoritesManager {
    @AppStorage("favoriteProductIDs") private var favoriteData: Data = Data()
    @Published private(set) var favorites: Set<UUID> = []
    
    init() {
        if let decodedArray = try? JSONDecoder().decode([UUID].self, from: favoriteData) {
            favorites = Set(decodedArray)
        }
    }
    
    /// Seeds the favorites set from an initial array of products.
    ///
    /// This runs only if `favorites` is currently empty, to avoid overriding
    /// any user-toggled favorites.
    /// - Parameter products: The full list of products.
    func seed(from products: [Product]) {
        guard favorites.isEmpty else { return }
        
        favorites = Set(products.filter(\.isFavorite).map(\.id))
        save()
    }
    
    /// Toggles the favorite status for a given product ID.
    /// - Parameter id: The `UUID` of the product to toggle.
    func toggle(_ id: UUID) {
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
        
        save()
    }
    
    /// Encodes the current `favorites` set as a `[UUID]` array and writes it to `favoriteData`.
    private func save() {
        if let data = try? JSONEncoder().encode(Array(favorites)) {
            favoriteData = data
        }
    }
}
