//
//  Product.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import Foundation

struct Product: Codable, Identifiable {
    let id: UUID
    let productDescription: String
    let price: String
    let promotions: [Promotion]
    let image: String
    let isFavorite: Bool
    let inStock: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case productDescription = "description"
        case price, promotions, image, isFavorite, inStock
    }
}
