//
//  DeveloperPreview.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import Foundation

@MainActor
final class DeveloperPreview {
    static let shared = DeveloperPreview()
    let shopVM: ShopViewModel
    var sampleProduct: Product
    
    private init() {
        shopVM = ShopViewModel()
        sampleProduct = Product(
            id: UUID(uuidString: "A1B2C3D4-E5F6-7890-1234-567890ABCDEF")!,
            productDescription: "Organic Fair Trade Coffeeasai",
            price: "15.99 £",
            promotions: [Promotion(type: .discount, value: "5.00 £")],
            rawImage: "bottle.png",
            isFavorite: true,
            inStock: 2
        )
    }
}
