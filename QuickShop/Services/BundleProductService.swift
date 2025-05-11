//
//  BundleProductService.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import Foundation

struct BundleProductService: ProductFetching {
    let fileName: String = "items"
    let fileExtension: String = "json"
    
    /// Asynchronously fetches products by reading a JSON file from the app bundle.
    /// - Throws:
    ///     - An `NSError` if the file cannot be located in the bundle.
    ///     - Any decoding error thrown by `JSONDecoder`.
    /// - Returns: An array of `Product` objects parsed from the JSON’s `items` key.
    func fetchProducts() async throws -> [Product] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            throw NSError(domain: "BundleProductService", code: 1, userInfo: [NSLocalizedDescriptionKey: "File not found."])
        }
        
        let items = try await Task.detached(priority: .userInitiated) {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(ItemsResponse.self, from: data).items
        }.value
        return items
    }
}
