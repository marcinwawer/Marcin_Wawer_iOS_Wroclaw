//
//  ShopViewModel.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import SwiftUI

final class ShopViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var favorites: Set<UUID> = []
    @Published var cartItems: [UUID:Int] = [:]
    @Published var isLoading: Bool = false
    @Published var errorLoading: String? = nil
    
    private let favoritesManager: FavoritesManager
    private let cartManager: CartManager
    private let productService: ProductFetching
    
    init(favoritesManager: FavoritesManager, cartManager: CartManager, productService: ProductFetching = BundleProductService()) {
        self.favoritesManager = favoritesManager
        self.cartManager = cartManager
        self.productService = productService
    }
    
    var cartEntries: [(product: Product, quantity: Int)] {
        cartItems.compactMap { id, qty in
            guard let product = products.first(where: { $0.id == id }) else { return nil }
            return (product: product, quantity: qty)
        }
    }
    
    var totalPrice: Double {
        cartEntries.reduce(0) { sum, entry in
            sum + entry.product.discountedPrice * Double(entry.quantity)
        }
    }
    
    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let decoded = try await productService.fetchProducts()
            favoritesManager.seed(from: decoded)
            products = decoded
            
            favorites = favoritesManager.favorites
            cartItems = cartManager.items
        } catch {
            errorLoading = error.localizedDescription
        }
    }
    
    func isFavorite(_ id: UUID) -> Bool {
        favorites.contains(id)
    }
    
    func quantityInCart(_ id: UUID) -> Int {
        cartItems[id] ?? 0
    }
    
    func toggleFavorite(_ id: UUID) {
        favoritesManager.toggle(id)
        favorites = favoritesManager.favorites
    }
    
    func updateCart(_ id: UUID, quantity: Int) {
        let stock = products.first(where: { $0.id == id })?.inStock ?? 0
        let quantity = min(quantity, stock)
        cartManager.update(id, quantity: quantity)
        cartItems = cartManager.items
    }
}
