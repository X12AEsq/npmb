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
    
    @State private var sortOption = 1
    
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
                    NavigationLink(destination: { EditClientView() }, label: { Text("Add New Client") })
                    switch sortOption {
                    case 1:
                        ForEach(CVModel.clients.sorted {$0.formattedName < $1.formattedName }) { client in
                            NavigationLink(client.formattedName) {
                                if !selectOnly {
                                    EditClientView(client: client)
                                }
                            }
                        }
                    case 2:
                        ForEach(CVModel.clients.sorted {$0.internalID < $1.internalID }) { client in
                            NavigationLink(client.sortFormat2) {
                                if !selectOnly {
                                    EditClientView(client: client)
                                }
                            }
                        }
                    default:
                        ForEach(CVModel.clients.sorted {$0.formattedName < $1.formattedName }) { client in
                            NavigationLink(client.formattedName) {
                                if !selectOnly {
                                    EditClientView(client: client)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Which Client?")
        }
    }    
}

//struct SelectClientView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectClientView()
//    }
//}
