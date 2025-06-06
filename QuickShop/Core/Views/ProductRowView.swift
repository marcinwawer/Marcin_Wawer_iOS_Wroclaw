//
//  ProductRowView.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import SwiftUI

struct ProductRowView: View {
    let product: Product
    let isFavorite: Bool
    let remainingStock: Int
    @Binding var quantity: Int
    let onFavoriteToggle: () -> Void
    
    private let height: CGFloat = 150
    private let width: CGFloat = 150
    
    var body: some View {
        HStack {
            productImage
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    productDescription
                    productPrice
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(
                    "\(product.productDescription), " +
                    "\(product.discountedPrice.twoDecimalPlaces) pounds"
                )
                .accessibilityValue(
                    "\(remainingStock) in stock, " +
                    "\(quantity) in cart"
                )
                .accessibilityHint("Contains product details, favorite button, and quantity")
                
                Spacer(minLength: 0)
                
                QuantityStepper(quantity: $quantity, inStockMax: product.inStock)
            }
            .padding(.vertical, 8)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: height)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.theme.yellow.opacity(0.3))
        )
        .overlay(alignment: .topTrailing, content: {
            heartButton
        })
    }
}

#Preview {
    ProductRowView(
        product: DeveloperPreview.shared.sampleProduct,
        isFavorite: false,
        remainingStock: 10,
        quantity: .constant(0)) {
            DeveloperPreview.shared.shopVM.toggleFavorite(DeveloperPreview.shared.sampleProduct.id)
        }
}

// MARK: - VARS
extension ProductRowView {
    private var productImage: some View {
        Image(product.imageName)
            .resizable()
            .frame(width: width-20, height: height-20)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.leading, 8)
            .accessibilityHidden(true)
    }
    
    private var productDescription: some View {
        Group {
            Text(product.productDescription)
                .lineLimit(3)
                .font(.headline)
                .padding(.trailing, 50)
            
            Text("\(remainingStock) items in stock")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .animation(.easeIn(duration: 0.3), value: remainingStock)
    }
    
    private var productPrice: some View {
        HStack {
            Text(product.priceValue.twoDecimalPlaces + " £")
                .strikethrough(product.discountedPrice != product.priceValue)
            
            if product.discountedPrice != product.priceValue {
                Text(product.discountedPrice.twoDecimalPlaces + " £")
            }
        }
        .font(.subheadline)
        .foregroundStyle(Color.theme.red)
        .minimumScaleFactor(0.7)
        .lineLimit(1)
    }
    
    private var heartButton: some View {
        Image(systemName: isFavorite ? "heart.fill" : "heart")
            .padding(8)
            .frame(maxHeight: height, alignment: .top)
            .onTapGesture {
                onFavoriteToggle()
            }
            .animation(.default, value: isFavorite)
            .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
            .accessibilityHint("Double tap to toggle favorite status")
            .accessibilityAddTraits(.isButton)
    }
}
