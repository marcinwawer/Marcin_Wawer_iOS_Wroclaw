//
//  BrowseView.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import SwiftUI

struct BrowseView: View {
    @EnvironmentObject private var vm: ShopViewModel
    
    var body: some View {
        VStack {
            if vm.isLoading {
                ProgressView()
            } else if let error = vm.errorLoading {
                Text(error).foregroundColor(.red)
            } else {
                productList
            }
        }
        .navigationTitle("Browse")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text("\(vm.totalPrice.twoDecimalPlaces) £")
            }
        }
        .task { await vm.loadProducts() }
    }
}

#Preview {
    NavigationStack {
        BrowseView()
            .environmentObject(DeveloperPreview.shared.shopVM)
    }
}

// MARK: VARS
extension BrowseView {
    private var productList: some View {
        ProductListView(
            products: vm.products,
            isFavorite: vm.isFavorite,
            remainingStock: vm.remainingStock,
            quantity: { id in
                Binding(
                    get: { vm.quantityInCart(id) },
                    set: { vm.updateCart(id, quantity: $0) }
                )
            },
            onFavoriteToggle: vm.toggleFavorite
        )
    }
}
