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
    @Published private(set) var allProducts: [Product] = []
    @Published private(set) var favorites: Set<UUID> = []
    @Published private(set) var cartItems: [UUID: Int] = [:]
    
    @Published var isLoading: Bool = false
    @Published var errorLoading: String? = nil
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .none
    @Published var showFavoritesOnly: Bool = false
    
    private let favoritesManager = FavoritesManager()
    private let cartManager = CartManager()
    private let productService: ProductFetching
    
    private var cancellables = Set<AnyCancellable>()
    
    init(productService: ProductFetching = BundleProductService()) {
        self.productService = productService
        addSubscribers()
    }
    
// MARK: - Computed Properties
    
    ///  Returns an array of tuples `(product, quantity)` for each item in the cart.
    var cartEntries: [(product: Product, quantity: Int)] {
        cartItems.compactMap { id, qty in
            guard let product = allProducts.first(where: { $0.id == id }) else { return nil }
            return (product: product, quantity: qty)
        }
    }
    
    /// Calculates the total price by summing `discountedPrice * quantity` for all `cartEntries`.
    var totalPrice: Double {
        cartEntries.reduce(0) { sum, entry in
            sum + entry.product.discountedPrice * Double(entry.quantity)
        }
    }
    
// MARK: - Funcs
    
    /// Sets up subscribers to sync favorites and cartItems, and to filter/sort products when searchText or sortOption changes.
    private func addSubscribers() {
        favoritesManager.$favorites
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.favorites = $0 }
            .store(in: &cancellables)
        
        cartManager.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.cartItems = $0 }
            .store(in: &cancellables)
        
        let filterInputs = $searchText.combineLatest($allProducts, $sortOption, $showFavoritesOnly)
        
        filterInputs
            .combineLatest($favorites)
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .map { [weak self] four, _ in
                let (text, all, sort, favOnly) = four
                return self?.filterSortAndFavorite(
                    text: text,
                    products: all,
                    sort: sort,
                    favoritesOnly: favOnly
                ) ?? []
            }
            .sink { [weak self] in self?.products = $0 }
            .store(in: &cancellables)
    }
    
    /// Loads products from the configured `productService`.
    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let decoded = try await productService.fetchProducts()
            favoritesManager.seed(from: decoded)
            products = decoded
            allProducts = decoded
        } catch {
            errorLoading = error.localizedDescription
        }
    }
    
    /// Checks whether the product with the given ID is marked as favorite.
    /// - Parameter id: The `UUID` of the product.
    /// - Returns: `true` if the product is in `favorites`, else `false`.
    func isFavorite(_ id: UUID) -> Bool {
        favorites.contains(id)
    }
    
    /// Retrieves the current quantity in cart for a given product ID.
    /// - Parameter id: The `UUID` of the product.
    /// - Returns: The quantity in the cart, or `0` if not present.
    func quantityInCart(_ id: UUID) -> Int {
        cartItems[id] ?? 0
    }
    
    
    /// Toggles the favorite status for a given product ID.
    /// - Parameter id: The `UUID` of the product to toggle.
    func toggleFavorite(_ id: UUID) {
        favoritesManager.toggle(id)
    }
    
    /// Updates the cart with a new quantity for a given product ID.
    /// Ensures the quantity does not exceed the product’s `inStock`.
    /// - Parameters:
    ///   - id: The `UUID` of the product.
    ///   - quantity: The desired quantity.
    func updateCart(_ id: UUID, quantity: Int) {
        let stock = products.first(where: { $0.id == id })?.inStock ?? 0
        let quantity = min(quantity, stock)
        cartManager.update(id, quantity: quantity)
    }
    
    /// Computes how many items remain available in stock, considering the quantity already in the cart.
    /// - Parameter id: The `UUID` of the product.
    /// - Returns: `max(inStock - quantityInCart(id), 0)`.
    func remainingStock(_ id: UUID) -> Int {
        guard let product = products.first(where: { $0.id == id }) else {
            return 0
        }
        
        let inCart = quantityInCart(id)
        return max(product.inStock - inCart, 0)
    }
}

// MARK: - SORTING & FILTERING
extension ShopViewModel {
    enum SortOption {
        case priceAsc, priceDesc, stockAsc, stockDesc, none
    }
    
    /// Filters products by checking if their `productDescription` contains the lowercase search text.
    /// - Parameters:
    ///   - text: The lowercase search string.
    ///   - products: Products to filter.
    /// - Returns: Products whose `productDescription` includes `text`.
    private func filterProducts(text: String, products: [Product]) -> [Product] {
        guard !text.isEmpty else { return products }
        
        let lowercasedText = text.lowercased()
        return products.filter { product in
            return product.productDescription.lowercased().contains(lowercasedText)
        }
    }
    
    /// Sorts the given product array in place according to the specified `SortOption`.
    /// - Parameters:
    ///   - sort: The sort option to apply.
    ///   - products: The array of products to sort.
    private func sortProducts(sort: SortOption, products: inout [Product]) {
        switch sort {
        case .none:
            break
        case .priceAsc:
            products.sort(by: { $0.discountedPrice < $1.discountedPrice })
        case .priceDesc:
            products.sort(by: { $0.discountedPrice > $1.discountedPrice })
        case .stockAsc:
            products.sort(by: { $0.inStock < $1.inStock })
        case .stockDesc:
            products.sort(by: { $0.inStock > $1.inStock })
        }
    }
    
    /// Filters an array of products by search text, optionally limits the results to favorites, and then sorts them.
    /// - Parameters:
    ///   - text: The search string used to filter products. If empty, no filtering by text is applied.
    ///   - products: The base array of `Product` instances to be filtered and sorted.
    ///   - sort: A `SortOption` value that determines how the final array is ordered.
    ///   - favoritesOnly: A flag indicating whether to restrict the final results to the user’s favorite products.
    /// - Returns: An array that has been filtered by `text`, optionally restricted to favorites, and sorted according to `sort`.
    private func filterSortAndFavorite(text: String, products: [Product], sort: SortOption, favoritesOnly: Bool) -> [Product] {
        var updated = filterProducts(text: text, products: products)
        
        if favoritesOnly {
            updated = updated.filter { favorites.contains($0.id) }
        }
        
        sortProducts(sort: sort, products: &updated)
        
        return updated
    }
}
