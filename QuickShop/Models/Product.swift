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
    private let rawImage: String
    let isFavorite: Bool
    let inStock: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case productDescription = "description"
        case rawImage = "image"
        case price, promotions, isFavorite, inStock
    }
    
    var imageName: String {
        (rawImage as NSString).deletingPathExtension
    }
}
