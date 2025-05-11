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
    
    private let minColumnWidth: CGFloat = 350
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [ .init(.adaptive(minimum: minColumnWidth)) ]
            ) {
                    ForEach(products) { product in
                        ProductRowView(
                            product: product,
                            isFavorite: isFavorite(product.id),
                            remainingStock: remainingStock(product.id),
                            quantity: quantity(product.id),
                            onFavoriteToggle: { onFavoriteToggle(product.id) }
                        )
                        .padding(4)
                    }
                }
                .padding(.horizontal, 8)
                .transaction { transaction in transaction.disablesAnimations = true }
            }
    }
}
