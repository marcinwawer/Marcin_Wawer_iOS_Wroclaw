//
//  UIApplication.swift
//  QuickShop
//
//  Created by Marcin Wawer on 11-05-2025.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
