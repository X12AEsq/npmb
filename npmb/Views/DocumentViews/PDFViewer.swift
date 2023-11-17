//
//  PDFViewer.swift
//  npmb
//
//  Created by Morris Albers on 11/15/23.
//

import SwiftUI
import PDFKit

struct PDFViewer: View {
//    @Environment(\.dismiss) var dismiss
    @Binding var presentedAsModal: Bool
    var pdfData:Data
    var body: some View {
        VStack {
            PDFKitRepresentedView(pdfData)
            Spacer()
            HStack {
                Spacer()
//                Button("Press to dismiss") {
//                    self.presentedAsModal = false
//                }
//                .buttonStyle(CustomDismissButton())
//                .padding()
//                Spacer()
                PDFShareView(activityItems: [pdfData])
                Spacer()
            }
            Spacer()
        }
    }
}
//
//#Preview {
//    PDFViewer(presentedAsModal: $true)
//}
