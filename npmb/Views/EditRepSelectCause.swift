//
//  EditRepSelectCause.swift
//  npmb
//
//  Created by Morris Albers on 4/5/23.
//

import SwiftUI

struct EditRepSelectCause: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var CVModel:CommonViewModel
    @Binding var selectedCause:CauseModel


    var body: some View {
        SelectCauseUtil(selectedCause: $selectedCause, startingFilter: selectedCause.causeNo)

        Button("Press to dismiss") {
            dismiss()
        }
        .font(.title)
        .padding()
        .background(.black)
    }
}

//struct EditRepSelectCause_Previews: PreviewProvider {
//    static var previews: some View {
//        EditRepSelectCause()
//    }
//}
