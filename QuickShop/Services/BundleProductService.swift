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
