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
            SearchBarView(searchText: $vm.searchText)
            
            sortOptions
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
            
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
    
    private var sortOptions: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Stock")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .stockAsc || vm.sortOption == .stockDesc) ? 1 : 0)
                    .rotation3DEffect(.degrees(vm.sortOption == .stockAsc ? 0 : 180), axis: (x: 1, y: 0, z: 0))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .stockAsc ? .stockDesc : .stockAsc
                }
            }
            
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .priceAsc || vm.sortOption == .priceDesc) ? 1 : 0)
                    .rotation3DEffect(.degrees(vm.sortOption == .priceAsc ? 0 : 180), axis: (x: 1, y: 0, z: 0))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .priceAsc ? .priceDesc : .priceAsc
                }
            }
            
            Spacer()
        }
    }
}
