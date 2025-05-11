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
                .accessibilityLabel("Search products")
                .accessibilityHint("Type here to filter the product list")
            
            sortOptions
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .accessibilityElement(children: .contain)
            
            VStack {
                if vm.isLoading {
                    ProgressView()
                        .accessibilityLabel("Loading products")
                } else if let error = vm.errorLoading {
                    Text(error).foregroundColor(Color.theme.red)
                        .accessibilityLabel("Loading error")
                        .accessibilityValue(error)
                } else {
                    productList
                }
            }
            .navigationTitle("Browse")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Text("\(vm.totalPrice.twoDecimalPlaces) £")
                        .accessibilityLabel("Total price in cart")
                        .accessibilityValue("\(vm.totalPrice.twoDecimalPlaces) pounds")
                }
            }
        }
        .onDisappear {
            vm.sortOption = .none
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

// MARK: - VARS
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
                    .rotation3DEffect(.degrees(vm.sortOption == .stockDesc ? 0 : 180), axis: (x: 1, y: 0, z: 0))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .stockAsc ? .stockDesc : .stockAsc
                }
            }
            .accessibilityLabel("Sort by stock")
            .accessibilityValue(
                vm.sortOption == .stockAsc ? "ascending" :
                    vm.sortOption == .stockDesc ? "descending" : "not sorted"
            )
            .accessibilityHint("Double tap to change sort order")
            .accessibilityAddTraits(.isButton)
            
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .priceAsc || vm.sortOption == .priceDesc) ? 1 : 0)
                    .rotation3DEffect(.degrees(vm.sortOption == .priceDesc ? 0 : 180), axis: (x: 1, y: 0, z: 0))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .priceAsc ? .priceDesc : .priceAsc
                }
            }
            .accessibilityLabel("Sort by price")
            .accessibilityValue(
                vm.sortOption == .priceAsc ? "ascending" :
                    vm.sortOption == .priceDesc ? "descending" : "not sorted"
            )
            .accessibilityHint("Double tap to change sort order")
            .accessibilityAddTraits(.isButton)
            
            Spacer()
            
            Text("Reset Sorting")
                .onTapGesture {
                    vm.sortOption = .none
                }
                .accessibilityLabel("Reset sorting")
                .accessibilityHint("Restores default product order")
                .accessibilityAddTraits(.isButton)
        }
        .lineLimit(2)
    }
}
