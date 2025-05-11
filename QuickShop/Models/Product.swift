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
    
    /// The image name without file extension.
    var imageName: String {
        (rawImage as NSString).deletingPathExtension
    }
    
    var priceValue: Double {
        let digits = price.filter { "0123456789.".contains($0) }
        return Double(digits) ?? 0
    }
    
    /// Converts the `price` string into a `Double` by stripping non-digit/`.` characters.
    var discountedPrice: Double {
        promotions.reduce(priceValue) { currentPrice, promo in
            switch promo.type {
            case .discount:
                return max(currentPrice - promo.numValue, 0)
            case .percentage:
                let factor = (100 - promo.numValue) / 100
                return max(currentPrice * factor, 0)
            }
        }
    }
    
    init(
        id: UUID,
        productDescription: String,
        price: String,
        promotions: [Promotion],
        rawImage: String,
        isFavorite: Bool,
        inStock: Int
    ) {
        self.id = id
        self.productDescription = productDescription
        self.price = price
        self.promotions = promotions
        self.rawImage = rawImage
        self.isFavorite = isFavorite
        self.inStock = inStock
    }
}
