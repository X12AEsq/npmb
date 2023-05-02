//
//  EditRepInputMain.swift
//  npmb
//
//  Created by Morris Albers on 4/5/23.
//

import SwiftUI

struct EditRepInputMain: View {
    @EnvironmentObject var CVModel:CommonViewModel
    @Environment(\.dismiss) var dismiss

    @Binding var currDateAssigned:Date
    @Binding var currAssignedDate:String
    @Binding var currCategory:String
    @Binding var currActiveString:String
    @Binding var currActive:Bool
    @Binding var currDateDisp:Date
    @Binding var currDispDate:String
    @Binding var currDispType:String
    @Binding var currDispAction:String

    var pc:PrimaryCategory = PrimaryCategory()
    var activeOptions = ["Yes", "No"]
    var dto:DispositionTypeOptions = DispositionTypeOptions()
    var dao:DispositionActionOptions = DispositionActionOptions()

    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text("Assigned")
                DatePicker("", selection: $currDateAssigned, displayedComponents: [.date]).padding().onChange(of: currDateAssigned, perform: { value in
                    currAssignedDate = DateService.dateDate2String(inDate: value)
                })
            }
            HStack {
                Text("Category")
                Spacer()
                Picker("Category", selection: $currCategory) {
                    ForEach(pc.primaryCategories, id: \.self) {
                        Text($0).onChange(of: currCategory, perform: { value in
                            recordError(er: "select category " + currCategory + ", " + value)
                            currCategory = value
                        })
                    }
                }
            }
            HStack {
                Text("Active")
                Spacer()
                Picker("", selection: $currActiveString) {
                    ForEach(activeOptions, id: \.self) {
                        Text($0).onChange(of: currActiveString, perform: { value in
                            currActive = (value == "Yes")
                        })
                    }
                }
            }
            if !currActive {
                HStack {
                    Text("Disposed")
                    DatePicker("", selection: $currDateDisp, displayedComponents: [.date]).padding()
                        .onChange(of: currDateDisp, perform: { value in
                            currDispDate = DateService.dateDate2String(inDate: value)
                        })
                }
                
                HStack {
                    Text("Disposition Type")
                    Spacer()
                    Picker(selection: $currDispType) {
                        ForEach(dto.dispositionTypeOptions , id: \.self) {
                            Text($0).onChange(of: currDispType, perform: { value in
                            })
                        }
                    } label: {
                        Text("Type")
                    }
                }
                
                HStack {
                    Text("Disposition Action")
                    Spacer()
                    Picker(selection: $currDispAction) {
                        ForEach(dao.dispositionActionOptions , id: \.self) {
                            Text($0).onChange(of: currDispAction, perform: { value in
                            })
                        }
                    } label: {
                        Text("Action")
                    }
                }
            }
            // Bottom
        }
        Button("Press to dismiss") {
            dismiss()
        }
        .font(.title)
        .padding()
        .background(.black)

    }
 
    func recordError(er:String) {
//        if statusMessage != "" { statusMessage = statusMessage + "\n" + er }
//        else { statusMessage = er }
        CVModel.logItem(viewModel:"EditRepresentationMain", item:er)
    }

}

//struct EditRepInputMain_Previews: PreviewProvider {
//    static var previews: some View {
//        EditRepInputMain()
//    }
//}
