//
//  EditClientView.swift
//  npmb
//
//  Created by Morris Albers on 2/25/23.
//
import SwiftUI

struct EditClientView: View {
    @EnvironmentObject var CVModel:CommonViewModel
    @Environment(\.dismiss) var dismiss

    @State var statusMessage:String = ""
    @State var clientID:String = ""
    @State var internalID:Int = 0
    @State var lastName:String = ""
    @State var firstName:String = ""
    @State var middleName:String = ""
    @State var suffix:String = ""
    @State var street:String = ""
    @State var city:String = ""
    @State var state:String = StateOptions.defaultStateOption()
    @State var zip:String = ""
    @State var areacode:String = ""
    @State var exchange:String = ""
    @State var telnumber:String = ""
    @State var note:String = ""
    @State var jail:String = "N"
    @State var representation:[Int] = []
    @State var miscDocketDate:String = "2020-01-01"
    @State var dateMisc:Date? = Date()
    @State var dateMiscCertain:Date = Date()
    @State var saveMessage:String = ""
    @State var callResult:FunctionReturn = FunctionReturn()
    @State var clx:ClientModel = ClientModel()
    @State private var showingPrintStatus = false

    var so:StateOptions = StateOptions()
    var yno:YesNoOptions = YesNoOptions()
    
    var client:ClientModel?

    var body: some View {
        VStack(alignment: .leading) {
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
                        Spacer()
                        Button {
                            if saveMessage == "Update" {
                                updateClient()
                            } else {
                                addClient()
                            }
                        } label: {
                            Text(saveMessage)
                        }
                        .buttonStyle(CustomNarrowButton())
                        
                        if clx.internalID > 0 {
                            Button {
                                showingPrintStatus.toggle()
                            } label: {
                                Text("Print")
                            }
                            .buttonStyle(CustomGreenButton())
                            .sheet(isPresented: $showingPrintStatus, onDismiss: {
                                print("Print Status List Dismissed")
                            })
                            { PrintClientStatus(xcl: clx) }
                        }
                        
                        if saveMessage == "Update" {
                            Button {
                                CVModel.logItem(viewModel: "EditClientView", item: "Delete button)")
                            } label: {
                                Text("Delete Client")
                            }
                            .buttonStyle(CustomDeleteButton())
                        }
                        Spacer()
                    }
                }

                Section(header: Text("Client Name").background(Color.blue).foregroundColor(.white)) {
                    TextField("Last Name", text: $lastName).disableAutocorrection(true)
                    TextField("First Name", text: $firstName).disableAutocorrection(true)
                    TextField("Middle Name", text:$middleName).disableAutocorrection(true)
                    TextField("Suffix", text:$suffix).disableAutocorrection(true)
                }
                
                Section(header: Text("Address").background(Color.blue).foregroundColor(.white)) {
                    TextField("Street", text: $street).disableAutocorrection(true)
                    TextField("City", text: $city).disableAutocorrection(true)
                    Picker("State", selection: $state) {
                        ForEach(so.stateOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Zip", text:$zip)
               }
                
               Section(header: Text("PHONE").background(Color.blue).foregroundColor(.white)) {
                   HStack {
                        TextField("Area", text: $areacode)
                        TextField("Exchange", text: $exchange)
                        TextField("Number", text: $telnumber)
                    }
                }
                
                Section(header: Text("Notes").background(Color.blue).foregroundColor(.white)) {
                    VStack {
                        TextField("Note", text: $note)
                        Picker("Jail", selection: $jail) {
                             ForEach(yno.YesNoOptions, id: \.self) {
                                Text($0)
                            }
                        }
                        HStack {
                            if miscDocketDate == "" {
                                Text("Enter Miscellaneous Docket Date?")
                            } else {
                                Text("Change Miscellaneous Docket Date?:")
                            }
                            DatePicker("", selection: $dateMiscCertain, displayedComponents: [.date]).padding()
                                .onChange(of: dateMiscCertain, perform: { value in
                                    miscDocketDate = DateService.dateDate2String(inDate: value)
                                }
                            )
                        }
                    }
                }
            }
            .padding(.leading)
         }
        .onAppear {
            if let client = client {
                clx = client
                clientID = client.id!
                internalID = client.internalID
                lastName = client.lastName
                firstName = client.firstName
                middleName = client.middleName
                suffix = client.suffix
                street = client.street
                city = client.city
                state = client.state
                zip = client.zip
                areacode = FormattingService.deComposePhone(inpphone: client.phone)[0]
                exchange = FormattingService.deComposePhone(inpphone: client.phone)[1]
                telnumber = FormattingService.deComposePhone(inpphone: client.phone)[2]
                note = client.note
                jail = client.jail
                representation = client.representation
                miscDocketDate = client.miscDocketDate
                if miscDocketDate != "" {
                    dateMisc = DateService.dateString2Date(inDate:miscDocketDate, inTime:"0000")
                    dateMiscCertain = dateMisc!
                } else {
                    dateMisc = nil
                    dateMiscCertain = Date()
                }
                saveMessage = "Update"
            } else {
                clx = ClientModel()
                internalID = 0
                lastName = ""
                firstName = ""
                middleName = ""
                suffix = ""
                street = ""
                city = ""
                state = StateOptions.defaultStateOption()
                zip = ""
                areacode = ""
                exchange = ""
                telnumber = ""
                note = ""
                jail = "N"
                representation = []
                miscDocketDate = "2020-01-01"
                dateMisc = DateService.dateString2Date(inDate:miscDocketDate, inTime:"0000")
                saveMessage = "Add"
            }
        }
    }
    
    func addClient() {
        Task {
            await callResult = CVModel.addClient(lastName: lastName, firstName: firstName, middleName: middleName, suffix: suffix, street: street, city: city, state: state, zip: zip, areacode: areacode, exchange: exchange, telnumber: telnumber, note: note, jail: jail)
            if callResult.status == .successful {
                statusMessage = ""
             } else {
                statusMessage = callResult.message
                CVModel.logItem(viewModel: "EditClientView", item: "add failed " + statusMessage)
            }
            if callResult.status == .successful {
                if miscDocketDate != "" {
                    await callResult = CVModel.updateClientMiscDate(clientID: clientID, miscDocketDate:miscDocketDate)
                    if callResult.status == .successful {
                        statusMessage = ""
                        dismiss()
                    } else {
                        statusMessage = callResult.message
                        CVModel.logItem(viewModel: "EditClientView", item: "update docket date failed " + statusMessage)
                    }
                } else {
                    dismiss()
                }
            }
        }
    }
    
    func updateClient() {
        Task {
            await callResult = CVModel.updateClient(clientID: clientID, internalID: internalID, lastName: lastName, firstName: firstName, middleName: middleName, suffix: suffix, street: street, city: city, state: state, zip: zip, areacode: areacode, exchange: exchange, telnumber: telnumber, note: note, jail: jail, representation: representation)
            if callResult.status == .successful {
                statusMessage = ""
            } else {
                statusMessage = callResult.message
                CVModel.logItem(viewModel: "EditClientView", item: "update failed " + statusMessage)
            }
            if callResult.status == .successful {
                if miscDocketDate != "" {
                    await callResult = CVModel.updateClientMiscDate(clientID: clientID, miscDocketDate:miscDocketDate)
                    if callResult.status == .successful {
                        statusMessage = ""
                        dismiss()
                    } else {
                        statusMessage = callResult.message
                        CVModel.logItem(viewModel: "EditClientView", item: "update docket date failed " + statusMessage)
                    }
                } else {
                    dismiss()
                }
            }
        }
    }
}

//struct EditClientView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditClientView(
//        )
//    }
//}
    
