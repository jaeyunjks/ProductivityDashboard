//
//  GratitudeInputField.swift
//  ProductivityDashboard
//
//  Created by Yafie Farabi on 10/12/2025.
//

import SwiftUI

struct GratitudeInputField: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.white.opacity(0.5)))
            .font(.title3)
            .foregroundColor(.white)
            .padding(20)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
            )
    }
}
