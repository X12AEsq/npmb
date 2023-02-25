//
//  CustomTextField.swift
//  ah2404
//
//  Created by Morris Albers on 2/20/23.
//

import SwiftUI

struct CustomTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(13)
            .background(.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
}
