//
//  QuantityStepper.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import SwiftUI

struct QuantityStepper: View {
    @EnvironmentObject private var vm: ShopViewModel
    let id: UUID
    
    var body: some View {
        HStack(spacing: 0) {
            minusButton
            
            Text("\(vm.quantityInCart(id))")
                .frame(maxWidth: .infinity)
                .background(.white)
            
            plusButton
        }
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

#Preview {
    QuantityStepper(id: DeveloperPreview.shared.sampleProduct.id)
        .environmentObject(DeveloperPreview.shared.shopVM)
        .frame(width: 150)
}

extension QuantityStepper {
    private var minusButton: some View {
        Button {
            vm.updateCart(id, quantity: vm.quantityInCart(id) - 1)
        } label: {
            Image(systemName: "minus")
                .frame(maxWidth: .infinity, maxHeight: 20)
        }
        .foregroundStyle(.black)
        .background(Color.theme.yellow.opacity(0.5))
    }
    
    private var plusButton: some View {
        Button {
            vm.updateCart(id, quantity: vm.quantityInCart(id) + 1)
        } label: {
            Image(systemName: "plus")
                .frame(maxWidth: .infinity, maxHeight: 20)
        }
        .foregroundStyle(.black)
        .background(Color.theme.yellow)
    }
}
