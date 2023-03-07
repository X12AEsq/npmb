//
//  EditCauseView.swift
//  npmb
//
//  Created by Morris Albers on 3/2/23.
//

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
    @State var representations:[Int] = []
    @State var saveMessage:String = ""
    
    @State var sortedClients:[ClientModel] = []

    var oo:OffenseOptions = OffenseOptions()

//    @State private var clientSelection: String = ""
//    @State private var clientSearchTerm: String = ""
//    
//    var lastNames:[String] {
//        var result:[String] = []
//        CVModel.clients.forEach {
//            result.append($0.sortFormat3)
//        }
//        return result.sorted()
//    }
//
//    var filteredClients: [String] {
//        lastNames.filter {
//            clientSearchTerm.isEmpty ? true : $0.lowercased().hasPrefix(clientSearchTerm.lowercased())
//        }
//    }

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
                Section(header: Text("Cause").background(Color.blue).foregroundColor(.white)) {
                    TextField("Number", text: $causeNo)
                    Picker("Level", selection: $causeLevel) {
                        ForEach(oo.offenseOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    NavigationLink("Clients") {
                        SelectClientView(selectOnly: true)
                    }

//                    selClient
                    
//                    Picker(selection: $clientSelection, label: Text("")) {
//                        SearchBar(text: $clientSearchTerm, placeholder: "Search Clients")
//                        ForEach(filteredClients, id: \.self) { clientLastName in
//                            Text(clientLastName).tag(clientLastName)
//                        }
//                    }
//                    .onSubmit {
//                        print("Submitted")
//                    }
                    
//                    .onChange(of: clientSelection) {
//                        print"Stop")
//                    }
/*

 struct ContentView: View {
     
     @State private var searchString = ""
     @State private var listSelection: String? = ""
     
     var body: some View {
         VStack {
             TextField("Search", text: $searchString)
             
             List(animals.filter({searchString == "" ? true : $0.contains(searchString)}), id: \.self, selection: $listSelection) { animal in
                 
                 Text(animal)
                 
             }
         }.padding()
         .onChange(of: searchString, perform: { value in
             listSelection = animals.filter({searchString == "" ? true : $0.contains(searchString)}).first
         })
     }
 }
 
 OR
 
 https://roddy.io/2020/09/07/add-search-bar-to-swiftui-picker/
 
*/

                    TextField("Type", text: $causeType)
                }
                
//                    TextField("Street", text: $street)
//                    TextField("City", text: $city)
//                    Picker("State", selection: $state) {
//                        ForEach(so.stateOptions, id: \.self) {
//                            Text($0)
//                        }
//                    }
//                    TextField("Zip", text:$zip)
                
                
            }
            .padding(.leading)
            HStack {
                Button {
                    if saveMessage == "Update" {
                        updateCause()
                    } else {
                        print("Select save")
                    }
                } label: {
                    Text(saveMessage)
                }
                .buttonStyle(CustomButton())
                if saveMessage == "Update" {
                    Button {
                        print("Select delete")
                    } label: {
                        Text("Delete Cause")
                    }
                    .buttonStyle(CustomButton())
                }
            }
         }
        .onAppear {
            sortedClients = CVModel.clients.sorted {
                $0.formattedName < $1.formattedName
            }
            if let cause = cause {
                causeID = cause.id!
                internalID = cause.internalID
                causeNo = cause.causeNo
                causeType = cause.causeType
                saveMessage = "Update"
            } else {
                internalID = 0
                causeNo = ""
                representations = []
                saveMessage = "Add"
            }
        }
    }

// func addCause(client:Int, causeno:String, representations:[Int], level:String, court: String, originalcharge: String, causeType: String, intid:Int) async {
    
    func addCause() {
//        Task {
//            await CVModel.addCause(client:Int, causeno:causeNo, representations:[Int], level:String, court: String, originalcharge: String, causeType: String, intid:internalID)
//            if CVModel.taskCompleted {
//                dismiss()
//            }
//        }
    }
    
    func updateCause() {
//        Task {
//            await CVModel.updateCause(causeID: causeID, internalID: internalID, causeNo: causeNo, firstName: firstName, middleName: middleName, suffix: suffix, street: street, city: city, state: state, zip: zip, areacode: areacode, exchange: exchange, telnumber: telnumber, note: note, jail: jail, representation: representation)
//            if CVModel.taskCompleted {
//                dismiss()
//            }
//        }
    }
    
    var selClient: some View {
        ScrollView {
            VStack (alignment: .leading) {
                ForEach(sortedClients) { cl in
                    VStack {
                        HStack {
                            Text(cl.formattedName)
                        }
                    }
                }
            }
        }
    }
}

//struct EditCauseView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditCauseView(
//        )
//    }
//}
