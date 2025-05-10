//
//  ShopViewModel.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import Foundation
import Combine

@MainActor
final class ShopViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var favorites: Set<UUID> = []
    @Published private(set) var cartItems: [UUID: Int] = [:]
    
    @Published var isLoading: Bool = false
    @Published var errorLoading: String? = nil
    
    private let favoritesManager = FavoritesManager()
    private let cartManager = CartManager()
    private let productService: ProductFetching
    
    private var cancellables = Set<AnyCancellable>()
    
    init(productService: ProductFetching = BundleProductService()) {
        self.productService = productService
        addSubscribers()
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
    
    private func addSubscribers() {
        favoritesManager.$favorites
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.favorites = $0 }
            .store(in: &cancellables)
        
        cartManager.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.cartItems = $0 }
            .store(in: &cancellables)
    }
    
    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let decoded = try await productService.fetchProducts()
            favoritesManager.seed(from: decoded)
            products = decoded
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
    }
    
    func updateCart(_ id: UUID, quantity: Int) {
        let stock = products.first(where: { $0.id == id })?.inStock ?? 0
        let quantity = min(quantity, stock)
        cartManager.update(id, quantity: quantity)
    }
    
    func remainingStock(_ id: UUID) -> Int {
        guard let product = products.first(where: { $0.id == id }) else {
            return 0
        }
        
        let inCart = quantityInCart(id)
        return max(product.inStock - inCart, 0)
    }
}
