//
//  EditRepInputAppearance.swift
//  npmb
//
//  Created by Morris Albers on 4/6/23.
//

import SwiftUI

struct EditRepInputAppearance: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var CVModel:CommonViewModel
    @Binding var xr:ExpandedRepresentation
    @Binding var dateAppr:Date
    @Binding var apprDocumentID:String
    @Binding var apprDate:String
    @Binding var apprTime:String
    @Binding var apprNote:String
    @Binding var apprChanged:Bool
    @Binding var apprInternal:Int
//    @Binding var apprClient:Int
//    @Binding var apprCause:Int
//    @Binding var apprRepresentation:Int
    @State var xdateAppr:Date = Date()
    @State var xapprDate:String = ""
    @State var xapprTime:String = ""
    @State var xapprNote:String = ""
    @State var xapprChanged:Bool = false
    @State var callResult:FunctionReturn = FunctionReturn()
    @State var statusMessage:String = ""

    
     var body: some View {
        VStack (alignment: .leading) {
            if statusMessage != "" {
                Text(statusMessage)
            }
            HStack {
                Text("Appearance Date")
                DatePicker("", selection: $dateAppr).padding().onChange(of: dateAppr, perform: { value in
                        apprDate = DateService.dateDate2String(inDate: value)
                        apprTime = DateService.dateTime2String(inDate: value)
                    }
                )
                Spacer()
            }
            TextField(text: $apprNote, prompt: Text("note")) {
                Text(apprNote)
            }
            Spacer()
            HStack {
// TODO: Need to distinguish between add new and update old
                if apprChange() {
                    Button {
                        Task {
                            if apprDocumentID == "" {
                                await callResult = CVModel.addAppearance(involvedClient: xr.xpcause.client.internalID, involvedCause: xr.xpcause.cause.internalID, involvedRepresentation: xr.representation.internalID, appearDate: apprDate, appearTime: apprTime, appearNote: apprNote)
                                if callResult.status == .successful {
                                    statusMessage = ""
                                    apprChanged = true
                                    dismiss()
                                } else {
                                    statusMessage = callResult.message
                                    CVModel.logItem(viewModel: "EditRepInpAppearance-add", item: callResult.message)
                                }
                            } else {
                                await callResult = CVModel.updateAppearance(appearanceID:apprDocumentID, intID: apprInternal, involvedClient: xr.xpcause.client.internalID, involvedCause: xr.xpcause.cause.internalID, involvedRepresentation: xr.representation.internalID, appearDate: apprDate, appearTime: apprTime, appearNote: apprNote)
                                if callResult.status == .successful {
                                    statusMessage = ""
                                    apprChanged = true
                                    dismiss()
                                } else {
                                    statusMessage = callResult.message
                                    CVModel.logItem(viewModel: "EditRepInpAppearance-update", item: callResult.message)
                                }
                            }
                        }
                    } label: {
                        Text("Save")
                    }
                    .buttonStyle(CustomButton())
                    Button {
                        dateAppr = xdateAppr
                        apprDate = xapprDate
                        apprTime = xapprTime
                        apprNote = xapprNote
                        apprChanged = false
                    } label: {
                        Text("Quit (no save)")
                    }
                    .buttonStyle(CustomButton())
                }
                Button("Press to dismiss") {
                    dismiss()
                }
                .font(.title)
                .padding()
                .background(.black)
            }
        }
        .padding(.leading, 10.0)
        .onAppear {
            xdateAppr = dateAppr
            xapprDate = apprDate
            xapprTime = apprTime
            xapprNote = apprNote
            xapprChanged = false
        }
    }
    
    func apprChange() -> Bool {
        if xdateAppr != dateAppr { return true }
        if xapprNote != apprNote { return true }
        return false
    }
}

//struct EditRepInputAppearance_Previews: PreviewProvider {
//    static var previews: some View {
//        EditRepInputAppearance()
//    }
//}
