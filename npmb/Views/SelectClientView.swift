//
//  SelectClientView.swift
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
    @State private var filterString = ""
//    @State private var sortedClients:[ClientModel] = []
    
    @EnvironmentObject var CVModel:CommonViewModel
 
//    @FirestoreQuery(collectionPath: "vehicles", predicates: []) var vehicles: [Vehicle]
    
    var body: some View {
        // TODO: Replace with navigation stack
        NavigationStack {
            HStack {
                Button {
                    sortOption = 1
                } label: {
                    Text("By Name")
                }
                .buttonStyle(CustomButton())
                 Button {
                    sortOption = 2
                } label: {
                    Text("By ID")
                }
                .buttonStyle(CustomButton())
             }

            ScrollView {
                VStack (alignment: .leading) {
                    HStack {
                        NavigationLink(destination: { EditClientView() }, label: { Text("Add New Client") })
                        Spacer()
                    }
                    ForEach(filterThem(option: sortOption, filter: filterString)) { client in
                        HStack {
                            NavigationLink(sortOption == 1 ? client.formattedName : client.sortFormat2) {
                                EditClientView(client: client)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Which Client?")
        }
    }
    
    func filterThem(option:Int, filter:String) -> [ClientModel] {
        return sortThem(option: option)
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
