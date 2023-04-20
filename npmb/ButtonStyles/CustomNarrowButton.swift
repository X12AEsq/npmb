//
//  CustomNarrowButton.swift
//  npmb
//
//  Created by Morris Albers on 4/12/23.
//

import SwiftUI

struct CustomNarrowButton: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.bold())
            .foregroundColor(.white)
            .frame(maxWidth: 150, maxHeight: 45)
            .background(.blue.opacity(0.3), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
            .opacity(configuration.isPressed ? 0.5 : 1)
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
