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
    @State private var showingEditVehicleView = false
    
    @EnvironmentObject var CVModel:CommonViewModel
 
//    @FirestoreQuery(collectionPath: "vehicles", predicates: []) var vehicles: [Vehicle]
    
    var body: some View {
        // TODO: Replace with navigation stack
        NavigationStack {
            ScrollView {
                VStack (alignment: .leading) {
                    NavigationLink(destination: { EditClientView() }, label: { Text("Add New Client") })
                    ForEach(CVModel.clients.sorted {$0.formattedName < $1.formattedName }) { client in
                        NavigationLink(client.formattedName) {
                            EditClientView(client: client)
                        }
                    }
                    //                .onDelete(perform: delete)
                }
            }
 //           .listStyle(.plain)
            .navigationTitle("Which Client?")
        }
    }
    
//    func delete(at offsets: IndexSet) {
//        offsets.forEach { index in
//            let vehicle = vehicles[index]
//            Task {
//                await CVModel.deleteVehicle(vehicle:vehicle)
//            }
//        }
//    }
}

struct SelectClientView_Previews: PreviewProvider {
    static var previews: some View {
        SelectClientView()
    }
}
