//
//  Promotion.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import Foundation

struct Promotion: Codable {
    let type: PromotionType
    let value: String
    
    /// Numeric representation of `value`, extracted by stripping non-digit/`.` characters.
    var numValue: Double {
        let digits = value.filter { "0123456789.".contains($0) }
        return Double(digits) ?? 0
    }
}

enum PromotionType: String, Codable {
    case discount
    case percentage
}
