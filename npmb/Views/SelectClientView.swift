//
//  SelectClient.swift
//  npmb
//
//  Created by Morris Albers on 2/25/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@available(iOS 15.0, *)
struct SelectClientView: View {
    var selectOnly:Bool
    @State var selectedClient = ClientModel()
    
    @State private var sortOption = 1
    @State private var sortMessage = ""
    @State private var filterString = ""
    @State private var sortedClients:[ClientModel] = []
    
    @EnvironmentObject var CVModel:CommonViewModel
 
//    @FirestoreQuery(collectionPath: "vehicles", predicates: []) var vehicles: [Vehicle]
    
    var body: some View {
        NavigationStack {
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
            }

            ScrollView {
                VStack (alignment: .leading) {
                    HStack {
                        NavigationLink(destination: { EditClientView() }, label: { Text("Add New Client") })
                        Spacer()
                    }
                    ForEach(sortedClients) { client in
                        HStack {
                            NavigationLink(sortOption == 1 ? client.formattedName : client.sortFormat2) {
                                EditClientView(client: client)
                            }
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
}

//struct SelectClientView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectClientView()
//    }
//}
