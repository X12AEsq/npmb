//
//  EditRepresentationView.swift
//  npmb
//
//  Created by Morris Albers on 3/9/23.
//

import SwiftUI

struct EditRepresentationView: View {
    @EnvironmentObject var CVModel:CommonViewModel
    @Environment(\.dismiss) var dismiss
    
    var rx:RepresentationExpansion?

    @State var statusMessage:String = ""
    @State var saveMessage:String = ""
    
    var pc:PrimaryCategory = PrimaryCategory()
    var dto:DispositionTypeOptions = DispositionTypeOptions()
    var dao:DispositionActionOptions = DispositionActionOptions()
    var activeOptions = ["Yes", "No"]

    @State var repInternalID:Int = 0
    @State var repAssigned:String = ""
    @State var repDateAssigned:Date = Date()
    @State var repCategory:String = ""
    @State var repActive:Bool = true
    @State var repActiveString:String = ""
    @State var repDispDate:String = ""
    @State var repDateDisp:Date = Date()
    @State var repDispType:String = ""
    @State var repDispAction:String = ""
    @State var cauInternalID = 0
    @State var cauCauseNo = ""
    @State var cauOrigCharge = ""
    @State var cliInternalID:Int = 0
    @State var cliName:String = ""

    var body: some View {
        GeometryReader { geo in
            VStack (alignment: .leading) {
                VStack (alignment: .leading) {
                    Text("Representation").font(.title)
                        .padding(.bottom)
                    if statusMessage != "" {
                        Text(statusMessage)
                            .font(.body)
                            .foregroundColor(Color.red)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom)
                    }
                    detail
                        .padding()
                        .border(.indigo, width: 4)
                }
                Form {
                    Section(header: Text("Representation Data").background(Color.blue).foregroundColor(.white)) {
                        DatePicker("Assigned", selection: $repDateAssigned, displayedComponents: [.date]).padding().onChange(of: repDateAssigned, perform: { value in
                            repAssigned = DateService.dateDate2String(inDate: repDateAssigned)
                        })
                        Picker("Category", selection: $repCategory) {
                            ForEach(pc.primaryCategories, id: \.self) {
                                Text($0)
                            }
                        }
                        Picker("Active", selection: $repActiveString) {
                            ForEach(activeOptions, id: \.self) {
                                Text($0).onChange(of: repActiveString, perform: { value in
                                    repActive = (value == "Yes")
                                 })
                            }
                        }
                        if !repActive {
                            DatePicker(selection: $repDateDisp, displayedComponents: [.date], label: {Text("Disposed")}).padding().onChange(of: repDateDisp, perform: { value in
                                repDispDate = DateService.dateDate2String(inDate: value)
                            })
                            Picker(selection: $repDispType) {
                                ForEach(dto.dispositionTypeOptions , id: \.self) {
                                    Text($0)
                                }
                            } label: {
                                Text("Action")
                            }
                            Picker(selection: $repDispAction) {
                                ForEach(dao.dispositionActionOptions , id: \.self) {
                                    Text($0)
                                }
                            } label: {
                                Text("Action")
                            }
                        }
                    }
                }
                .padding()
                .border(.indigo, width: 4)


                VStack {
                    HStack {
                        Button {
                            if saveMessage == "Update" {
                                print("Select Update")
                            } else {
                                print("Select Save")
                            }
                        } label: {
                            Text(saveMessage)
                        }
                        .buttonStyle(CustomButton())
                        if saveMessage == "Update" {
                            Button("Delete", role: .destructive) {
                                print("Select Delete")
                            }
                            .font(.headline.bold())
                            .frame(maxWidth: .infinity, maxHeight: 55)
                            .background(.gray.opacity(0.3), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                        }
                    }
                }
            }
            .onAppear {
                if let rx = rx {
                    saveMessage = "Update"
                    repInternalID = rx.representation.internalID
                    repAssigned = rx.representation.assignedDate
                    repDateAssigned = DateService.dateString2Date(inDate: repAssigned)
                    repActive = rx.representation.active
                    repActiveString = (repActive) ? "Yes" : "No"
                    repCategory = rx.representation.primaryCategory
                    repDispDate = rx.representation.dispositionDate
                    repDateDisp = DateService.dateString2Date(inDate: repDispDate)
                    repDispType = rx.representation.dispositionType
                    repDispAction = rx.representation.dispositionAction
                    cauInternalID = rx.cause.internalID
                    cauCauseNo = rx.cause.causeNo
                    cauOrigCharge = rx.cause.originalCharge
                    cliInternalID = rx.client.internalID
                    cliName = rx.client.formattedName
                } else {
                    saveMessage = "Add"
                    repInternalID = 0
                    repAssigned = ""
                    repDateAssigned = Date()
                    repActive = true
                    repActiveString = "Yes"
                    repCategory = ""
                    repDispDate = ""
                    repDispType = ""
                    repDateDisp = Date()
                    repDispAction = ""
                    cauInternalID = 0
                    cauCauseNo = ""
                    cauOrigCharge = ""
                    cliInternalID = 0
                    cliName = ""
                }
            }
        }
    }
    
    var detail: some View {
        VStack (alignment: .leading) {
            HStack {
                Text("Representation:")
                Text(String(repInternalID))
            }
            HStack {
                Text("Assigned: ")
                Text(repAssigned)
            }
            HStack {
                Text("Category: ")
                Text(repCategory)
            }
            HStack {
                Text("Active:")
                Text((repActive) ? "yes" : "no")
            }
            if !repActive {
                HStack {
                    Text("Competed:")
                    Text(repDispDate)
                    Text(" ")
                    Text(repDispType)
                    Text(" ")
                    Text(repDispAction)
                }
            }
            HStack {
                Text("Cause:")
                Text(String(cauInternalID))
                Text(" ")
                Text(cauCauseNo)
                Text(" ")
                Text(cauOrigCharge)
            }
            HStack {
                Text("Client:")
                Text(String(cliInternalID))
                Text(" ")
                Text(cliName)
            }
        }
    }
}

//struct EditRepresentationView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditRepresentationView()
//    }
//}
