//
//  ProductRowView.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import SwiftUI

struct ProductRowView: View {
    @EnvironmentObject private var vm: ShopViewModel
    let product: Product
    
    private let width: CGFloat = 140
    private let height: CGFloat = 140
    
    var body: some View {
        HStack {
            productImage
            
            VStack(alignment: .leading) {
                productDescription
                
                Spacer()
                
                productPrice
                
                QuantityStepper(id: product.id)
            }
            .padding(.vertical, 8)
            .frame(maxHeight: height)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
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
    ProductRowView(product: DeveloperPreview.shared.sampleProduct)
        .environmentObject(DeveloperPreview.shared.shopVM)
}

// MARK: VARS
extension ProductRowView {
    private var productImage: some View {
        Image(product.imageName)
            .resizable()
            .frame(width: width-20, height: height-20)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.leading, 8)
    }
    
    private var productDescription: some View {
        Group {
            Text(product.productDescription)
                .lineLimit(2)
                .font(.headline)
                .padding(.trailing, 25)
            
            Text("\(vm.remainingStock(product.id)) items in stock")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
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
    }
    
    private var heartButton: some View {
        Image(systemName: vm.isFavorite(product.id) ? "heart.fill" : "heart")
            .padding(8)
            .frame(maxHeight: height, alignment: .top)
            .onTapGesture {
                withAnimation {
                    vm.toggleFavorite(product.id)
                }
            }
    }
}
