//
//  Double.swift
//  QuickShop
//
//  Created by Marcin Wawer on 10-05-2025.
//

import Foundation


extension Double {
    var twoDecimalPlaces: String {
        String(format: "%.2f", self)
    }
}
