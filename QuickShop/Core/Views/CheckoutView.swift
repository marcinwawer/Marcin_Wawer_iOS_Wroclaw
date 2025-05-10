//
//  CheckoutView.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject private var vm: ShopViewModel
    
    @State private var checkoutAlert = false
    
    var body: some View {
        VStack {
            if vm.cartEntries.isEmpty {
                emptyCart
            } else {
                productList
                
                checkoutButton
            }
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text("\(vm.totalPrice.twoDecimalPlaces) £")
            }
        }
        .alert("Order", isPresented: $checkoutAlert) {} message: { checkoutAlertMessage }
    }
}

#Preview {
    CheckoutView()
        .environmentObject(DeveloperPreview.shared.shopVM)
}

extension CheckoutView {
    private var emptyCart: some View {
        VStack {
            Image(systemName: "cart.circle")
                .resizable()
                .frame(width: 250, height: 250)
                .padding(.bottom)
            
            Text("Your cart is empty 😭")
                .font(.title2)
        }
        .foregroundColor(.secondary)
        .padding()
    }
    
    private var productList: some View {
        ProductListView(
            products: vm.cartEntries.map { $0.product },
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
    
    private var checkoutButton: some View {
        Button {
            checkoutAlert = true
        } label: {
            Text("Checkout")
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.theme.yellow)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
        }
    }
    
    private var checkoutAlertMessage: some View {
        Text(
            vm.cartItems
                .map { "\($0.key.uuidString): \($0.value)" }
                .joined(separator: ", ")
        )
    }
}
