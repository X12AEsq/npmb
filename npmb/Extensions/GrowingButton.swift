//
//  GrowingButton.swift
//  npm9y
//
//  Created by Morris Albers on 7/14/21.
//

import Foundation
import SwiftUI

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(.all, 5.0)
            .background(
                RoundedRectangle(
                    cornerRadius: 10,
                    style: .continuous
                )
                .fill(Color.black)
            )
            .foregroundColor(.yellow)
//            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
//            .animation(.easeOut(duration: 0.2))
    }
}
