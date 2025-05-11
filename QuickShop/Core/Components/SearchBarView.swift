//
//  SearchBarView.swift
//  QuickShop
//
//  Created by Marcin Wawer on 11-05-2025.
//

import SwiftUI

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    searchText.isEmpty ? .secondary : Color.theme.yellow
                )
            
            searchTextField
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.yellow.opacity(0.15),
                    radius: 10
                )
        )
        .padding()
        .frame(maxWidth: 600)
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}

// MARK: - VARS
extension SearchBarView {
    private var searchTextField: some View {
        TextField("Search by name...", text: $searchText)
            .foregroundStyle(Color.theme.yellow)
            .autocorrectionDisabled()
            .overlay(alignment: .trailing) {
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .offset(x: 10)
                    .foregroundStyle(Color.theme.yellow)
                    .opacity(searchText.isEmpty ? 0 : 1)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                        searchText = ""
                    }
            }
    }
}
