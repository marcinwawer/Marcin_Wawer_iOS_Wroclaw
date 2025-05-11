//
//  QuickShopTests.swift
//  QuickShopTests
//
//  Created by Marcin Wawer on 10-05-2025.
//

import Testing
@testable import QuickShop

import SwiftUI

private struct FakeProductService: ProductFetching {
    var productsToReturn: [Product]
    func fetchProducts() async throws -> [Product] {
        productsToReturn
    }
}

struct QuickShopTests {
    @Test func imageNameStripsExtension() {
        let uuid = UUID()
        let product = Product(
            id: uuid,
            productDescription: "Test",
            price: "9.99£",
            promotions: [],
            rawImage: "widget.png",
            isFavorite: false,
            inStock: 1
        )
        let product2 = Product(
            id: uuid,
            productDescription: "Test",
            price: "9.99£",
            promotions: [],
            rawImage: "widget.jpg",
            isFavorite: false,
            inStock: 1
        )
        let product3 = Product(
            id: uuid,
            productDescription: "Test",
            price: "9.99£",
            promotions: [],
            rawImage: "widget",
            isFavorite: false,
            inStock: 1
        )
        
        #expect(product.imageName == "widget")
        #expect(product2.imageName == "widget")
        #expect(product3.imageName == "widget")
    }
    
    @Test func priceValueParsesDigitsAndDecimal() {
        let p1 = Product(
            id: UUID(),
            productDescription: "",
            price: "12.34 £",
            promotions: [],
            rawImage: "",
            isFavorite: false,
            inStock: 1
        )
        let p2 = Product(
            id: UUID(),
            productDescription: "",
            price: "USD 56.78",
            promotions: [],
            rawImage: "",
            isFavorite: false,
            inStock: 1
        )
        
        #expect(p1.priceValue == 12.34)
        #expect(p2.priceValue == 56.78)
    }
    
    @Test func discountedPriceWithNoPromotionsEqualsPriceValue() {
        let p = Product(
            id: UUID(),
            productDescription: "",
            price: "20.00£",
            promotions: [],
            rawImage: "",
            isFavorite: false,
            inStock: 1
        )
        
        #expect(p.discountedPrice == p.priceValue)
    }
    
    @Test func discountedPriceAppliesFlatDiscount() {
        let promo = Promotion(type: .discount, value: "5.00")
        let p = Product(
            id: UUID(),
            productDescription: "",
            price: "30",
            promotions: [promo],
            rawImage: "",
            isFavorite: false,
            inStock: 1
        )

        #expect(p.discountedPrice == 25)
    }
    
    @Test func discountedPriceAppliesPercentageDiscount() {
        let promo = Promotion(type: .percentage, value: "10.00")
        let p = Product(
            id: UUID(),
            productDescription: "",
            price: "50.0",
            promotions: [promo],
            rawImage: "",
            isFavorite: false,
            inStock: 1
        )

        #expect(p.discountedPrice == 45)
    }
    
    @Test func discountedPriceChainsMultiplePromotions() {
        let promos = [
            Promotion(type: .discount,  value: "20.00"),
            Promotion(type: .percentage,  value: "50.00")
        ]
        let p = Product(
            id: UUID(),
            productDescription: "",
            price: "100",
            promotions: promos,
            rawImage: "",
            isFavorite: false,
            inStock: 1
        )
        
        #expect(p.discountedPrice == 40)
    }
    
    @Test func decodingFromJSON() throws {
        let json = """
        {
          "productId": "00000000-0000-0000-0000-000000000001",
          "description": "JSON Test",
          "price": "15.50£",
          "promotions": [
            { "type": "discount", "value": "5.00 £" }
          ],
          "image": "pic.jpg",
          "isFavorite": true,
          "inStock": 3
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        let product = try decoder.decode(Product.self, from: json)
        
        #expect(product.id.uuidString == "00000000-0000-0000-0000-000000000001")
        #expect(product.productDescription == "JSON Test")
        #expect(product.price == "15.50£")
        #expect(product.promotions.count == 1)
        #expect(product.promotions[0].type == .discount)
        #expect(product.promotions[0].numValue == 5)
        #expect(product.imageName == "pic")
        #expect(product.isFavorite)
        #expect(product.inStock == 3)
    }
}
