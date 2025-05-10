//
//  QuantityStepper.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import SwiftUI

struct QuantityStepper: View {
    @Binding var quantity: Int
    
    private let height: CGFloat = 30
    
    var body: some View {
        HStack(spacing: 0) {
            minusButton
            
            Text("\(quantity)")
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(.white)
            
            plusButton
        }
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .animation(.easeInOut(duration: 0.3), value: quantity)
    }
}

#Preview {
    QuantityStepper(quantity: .constant(0))
        .frame(width: 150)
}

extension QuantityStepper {
    private var minusButton: some View {
        Button {
            quantity -= 1
        } label: {
            Image(systemName: "minus")
                .frame(maxWidth: .infinity, maxHeight: height)
        }
        .foregroundStyle(.black)
        .background(Color.theme.yellow.opacity(0.5))
    }
    
    private var plusButton: some View {
        Button {
            quantity += 1
        } label: {
            Image(systemName: "plus")
                .frame(maxWidth: .infinity, maxHeight: height)
        }
        .foregroundStyle(.black)
        .background(Color.theme.yellow)
    }
}
