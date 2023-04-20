//
//  CustomGreenButton.swift
//  npmb
//
//  Created by Morris Albers on 4/10/23.
//

import SwiftUI

struct CustomGreenButton: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.bold())
            .foregroundColor(.black)
            .frame(maxWidth: 150, maxHeight: 45)
            .background(.green.opacity(0.2), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
            .opacity(configuration.isPressed ? 0.5 : 1)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
