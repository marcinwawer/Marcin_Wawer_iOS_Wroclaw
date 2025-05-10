//
//  FavoritesManager.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import Foundation
import SwiftUI

final class FavoritesManager: ObservableObject {
    @AppStorage("favoriteProductIDs") private var favoriteData: Data = Data()
    @Published private(set) var favorites: Set<UUID> = []
    
    init() {
        if let decodedArray = try? JSONDecoder().decode([UUID].self, from: favoriteData) {
            favorites = Set(decodedArray)
        }
    }
    
    func seed(from products: [Product]) {
        guard favorites.isEmpty else { return }
        
        favorites = Set(products.filter(\.isFavorite).map(\.id))
        save()
    }
    
    func toggle(_ id: UUID) {
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
        
        save()
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(Array(favorites)) {
            favoriteData = data
        }
    }
}
