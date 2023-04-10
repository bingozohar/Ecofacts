//
//  AddButtonView.swift
//  Ecofacts
//
//  Created by Bingo Zohar on 07/04/2023.
//

import SwiftUI

struct AddButtonView: View {
    let accessibilityLabel: String
    @Binding var isPresentingNew: Bool
    
    var body: some View {
        Button(action: {
            isPresentingNew = true
        }) {
            Image(systemName: "plus")
        }
        .accessibilityLabel(accessibilityLabel)
    }
}
