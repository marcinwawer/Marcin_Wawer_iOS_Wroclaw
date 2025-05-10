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
}

enum PromotionType: String, Codable {
    case discount
    case percentage
}
