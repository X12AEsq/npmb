//
//  EditCauseView.swift
//  npmb
//
//  Created by Morris Albers on 3/2/23.
//

// TODO: remove sort options from client selection - go on name only
// TODO: complete record update and save logic

import SwiftUI

struct EditCauseView: View {
    @EnvironmentObject var CVModel:CommonViewModel
    @Environment(\.dismiss) var dismiss

    @State var statusMessage:String = ""
    @State var causeID:String = ""
    @State var internalID:Int = 0
    @State var causeNo:String = ""
    @State var causeLevel:String = ""
    @State var causeType:String = ""
    @State var causeCourt:String = ""
    @State var causeOriginalCharge = ""
    @State var representations:[Int] = []
    @State var saveMessage:String = ""
    
    @State var sortOption:Int = 1
    @State var sortMessage:String = "By Name"
    @State var filterString:String = ""
    @State var sortedClients:[ClientModel] = []
    @State var selectedClient:ClientModel = ClientModel()
    @State var callResult:FunctionReturn = FunctionReturn()

    var oo:OffenseOptions = OffenseOptions()
    var ac:AvailableCourts = AvailableCourts()
    var cto:CauseTypeOptions = CauseTypeOptions()

    var cause:CauseModel?

    var body: some View {
        VStack {
            if statusMessage != "" {
                Text(statusMessage)
                    .font(.body)
                    .foregroundColor(Color.red)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom)
            }
            Form {
                Section(header: Text("Action").background(Color.blue).foregroundColor(.white)) {
                    
                    HStack {
                        Button {
                            if saveMessage == "Update" {
                                updateCause()
                            } else {
                                addCause()
                            }
                        } label: {
                            Text(saveMessage)
                        }
                        .buttonStyle(CustomButton())
                        if saveMessage == "Update" {
                            Button("Delete", role: .destructive) {
                                CVModel.logItem(viewModel: "EditClientView", item: "Select delete")
                            }
                            .font(.headline.bold())
                            .frame(maxWidth: .infinity, maxHeight: 55)
                            .background(.gray.opacity(0.3), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                            
                            //                        .buttonStyle(CustomButton())
                        }
                    }
                }

                Section(header: Text("Cause").background(Color.blue).foregroundColor(.white)) {
                    HStack {
                        Text("Cause No: ")
                        TextField("Number", text: $causeNo)
                    }
                    Picker("Level", selection: $causeLevel) {
                        ForEach(oo.offenseOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    Picker("Court", selection: $causeCourt) {
                        ForEach(ac.CourtOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    HStack {
                        Text("Charge: ")
                        TextField("Original Charge", text: $causeOriginalCharge)
                    }
                    HStack {
                        Text("Client: ")
                        Text(selectedClient.formattedName)
                    }
                }
                .padding(.leading)
                Section(header: Text("Select Client").background(Color.blue).foregroundColor(.white)) {
                    VStack {
                        HStack {
                            Button {
                                sortOption = 1
                                sortMessage = "By Name"
                            } label: {
                                Text("By Name")
                            }
                            .buttonStyle(CustomButton())
                            Button {
                                sortOption = 2
                                sortMessage = "By ID"
                            } label: {
                                Text("By ID")
                            }
                            .buttonStyle(CustomButton())
                        }
                        HStack {
                            Text("Filter " + sortMessage)
                            TextField("", text: $filterString)
                                .background(Color.gray.opacity(0.30))
                                .onChange(of: filterString) { newValue in
                                    sortedClients = filterThem(option: sortOption, filter: filterString)
                                }

                            Spacer()
                        }
                        ScrollView {
                            VStack (alignment: .leading) {
                                ForEach(sortedClients) { cl in
                                    HStack {
                                        Text(sortOption == 1 ? cl.formattedName : cl.sortFormat2).foregroundColor(.blue)
//                                        ActionSelect()
                                            .onTapGesture {
                                                CVModel.logItem(viewModel: "EditClientView", item: "Selected " + cl.formattedName)
                                                selectedClient = cl
                                            }
                                        Text(sortOption == 1 ? cl.formattedName : cl.sortFormat2)
                                        Spacer()
                                    }
                                }
                            }
                            .onAppear {
                                sortedClients = filterThem(option: sortOption, filter: filterString)
                            }
                        }
                        .listStyle(.plain)
                        .navigationTitle("Which Client?")
                    }
                }
                .padding(.leading)
            } // end of form
            .onAppear {
                sortedClients = CVModel.clients.sorted {
                    $0.formattedName < $1.formattedName
                }
                if let cause = cause {
                    causeID = cause.id!
                    internalID = cause.internalID
                    causeNo = cause.causeNo
                    causeType = cause.causeType
                    causeLevel = cause.level
                    causeCourt = cause.court
                    causeOriginalCharge = cause.originalCharge
                    saveMessage = "Update"
                    let involvedClient:ClientModel = CVModel.findClient(internalID: cause.involvedClient )
                    if involvedClient.internalID == 0 {
                        filterString = "error locating involved client"
                    } else {
                        filterString = (sortOption == 1) ? involvedClient.formattedName : involvedClient.sortFormat2
                        selectedClient = involvedClient
                    }
                } else {
                    internalID = 0
                    causeNo = ""
                    representations = []
                    causeType = CauseTypeOptions.defaultCauseTypeOption()
                    causeCourt = ""
                    causeOriginalCharge = ""
                    selectedClient = ClientModel()
                    saveMessage = "Add"
                }
            }
        }
    }

// func addCause(client:Int, causeno:String, representations:[Int], level:String, court: String, originalcharge: String, causeType: String, intid:Int) async {
    
    func filterThem(option:Int, filter:String) -> [ClientModel] {
        if option == 1 {
            return sortThem(option: option).filter { $0.formattedName.lowercased().hasPrefix(filter.lowercased()) }
        } else {
            return sortThem(option: option).filter { $0.sortFormat2.lowercased().hasPrefix(filter.lowercased()) }
        }
    }
    
    func sortThem(option:Int) -> [ClientModel] {
        if option == 1 {
            return CVModel.clients.sorted {$0.formattedName < $1.formattedName }
        } else {
            return CVModel.clients.sorted {$0.internalID < $1.internalID }
        }
    }
    
    func addCause() {
        Task {
            await callResult = CVModel.addCause(client:selectedClient.internalID, causeno:causeNo, representations:representations, level:causeLevel, court: causeCourt, originalcharge: causeOriginalCharge, causetype: causeType)
            if callResult.status == .successful {
                statusMessage = ""
                dismiss()
            } else {
                statusMessage = callResult.message
            }
        }
    }

    func updateCause() {
        Task {
            await callResult = CVModel.updateCause(causeID: cause?.id ?? "", client:selectedClient.internalID, causeno:causeNo, representations:representations, level:causeLevel, court: causeCourt, originalcharge: causeOriginalCharge, causetype: causeType, intid: internalID)
            if callResult.status == .successful {
                statusMessage = ""
                dismiss()
            } else {
                statusMessage = callResult.message
            }
        }
    }
    
//    var selClient: some View {
//        ScrollView {
//            VStack (alignment: .leading) {
//                ForEach(sortedClients) { cl in
//                    VStack {
//                        HStack {
//                            Text(cl.formattedName)
//                        }
//                    }
//                }
//            }
//        }
//    }
}

//struct EditCauseView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditCauseView(
//        )
//    }
//}
