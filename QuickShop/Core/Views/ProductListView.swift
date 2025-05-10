//
//  ProductListView.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import SwiftUI

struct ProductListView: View {
    let products: [Product]
    let isFavorite: (UUID) -> Bool
    let remainingStock: (UUID) -> Int
    let quantity: (UUID) -> Binding<Int>
    let onFavoriteToggle: (UUID) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(products) { product in
                    ProductRowView(
                        product: product,
                        isFavorite: isFavorite(product.id),
                        remainingStock: remainingStock(product.id),
                        quantity: quantity(product.id),
                        onFavoriteToggle: { onFavoriteToggle(product.id) }
                    )
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
            }
        }
    }
}
