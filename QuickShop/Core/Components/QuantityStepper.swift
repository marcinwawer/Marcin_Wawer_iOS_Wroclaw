//
//  QuantityStepper.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import SwiftUI

struct QuantityStepper: View {
    @Binding var quantity: Int
    let inStockMax: Int
    
    private let height: CGFloat = 30
    
    var body: some View {
        HStack(spacing: 0) {
            minusButton
            
            Text("\(quantity)")
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(Color.theme.background)
            
            plusButton
        }
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .animation(.easeInOut(duration: 0.3), value: quantity)
        .minimumScaleFactor(0.7)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Quantity")
        .accessibilityValue("\(quantity)")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                quantity += 1
                HapticManager.shared.notification(type: .success)
            case .decrement:
                quantity -= 1
                HapticManager.shared.notification(type: .success)
            default:
                break
            }
        }
    }
}

#Preview {
    QuantityStepper(quantity: .constant(0), inStockMax: 10)
        .frame(width: 150)
}

extension QuantityStepper {
    private var minusButton: some View {
        Button {
            quantity -= 1
            HapticManager.shared.notification(type: .success)
        } label: {
            Image(systemName: "minus")
                .frame(maxWidth: .infinity, maxHeight: height)
        }
        .foregroundStyle(.black)
        .background(Color.theme.yellow.opacity(0.5))
        .disabled(quantity <= 0)
        .opacity(quantity <= 0 ? 0.5 : 1)
    }
    
    private var plusButton: some View {
        Button {
            quantity += 1
            HapticManager.shared.notification(type: .success)
        } label: {
            Image(systemName: "plus")
                .frame(maxWidth: .infinity, maxHeight: height)
        }
        .foregroundStyle(.black)
        .background(Color.theme.yellow)
        .disabled(quantity >= inStockMax)
        .opacity(quantity >= inStockMax ? 0.5 : 1)
    }
}
