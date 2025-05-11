//
//  ProductFetching.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import Foundation

protocol ProductFetching {
    /// Asynchronously retrieves an array of products.
    /// - Throws: An error if fetching or decoding fails.
    /// - Returns: Returns: A `[Product]` array upon successful fetch.
    func fetchProducts() async throws -> [Product]
}
