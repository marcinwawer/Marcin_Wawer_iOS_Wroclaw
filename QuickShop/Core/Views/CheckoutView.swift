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
        ZStack {
            VStack {
                if vm.cartEntries.isEmpty {
                    emptyCart
                        .transition(.opacity.combined(with: .scale))
                } else {
                    productList
                    checkoutButton
                }
            }
            .animation(.easeInOut, value: vm.cartEntries.isEmpty)
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Text("\(vm.totalPrice.twoDecimalPlaces) £")
                }
            }
            .alert("Order", isPresented: $checkoutAlert) {} message: { checkoutAlertMessage }
        }
        .accessibilityElement(children: .contain)
    }
}

#Preview {
    CheckoutView()
        .environmentObject(DeveloperPreview.shared.shopVM)
}

// MARK: - VARS
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
        .accessibilityElement(children: .combine)
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
            HapticManager.shared.notification(type: .success)
        } label: {
            Text("Checkout")
                .foregroundStyle(.black)
                .frame(maxWidth: 600)
                .frame(height: 50)
                .background(Color.theme.yellow)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
        }
        .accessibilityLabel("Checkout")
        .accessibilityHint("Double tap to complete your order")
        .accessibilityValue(
            "Your items in cart: " +
            vm.cartEntries
                .map { "\($0.product.productDescription): \($0.quantity)" }
                .joined(separator: ", ")
        )
        .accessibilityAddTraits(.isButton)
    }
    
    private var checkoutAlertMessage: some View {
        Text(
            vm.cartItems
                .map { "\($0.key.uuidString): \($0.value)" }
                .joined(separator: ", ")
        )
    }
}
