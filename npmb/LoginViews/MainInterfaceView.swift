//
//  MainInterfaceView.swift
//  ah2404
//
//  Created by Morris Albers on 2/20/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct MainInterfaceView: View {
    @State private var showingEditVehicleView = false
    
    @EnvironmentObject var CVModel:CommonViewModel
 
//    @FirestoreQuery(collectionPath: "vehicles", predicates: []) var vehicles: [Vehicle]

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
                .opacity(0.5)
            VStack {
                Button {
                    _ = CVModel.signout()
                } label: {
                    Text("sign out")
                        .padding(10)
                        .foregroundColor(.white)
                        .background(.white.opacity(0.3))
                        .clipShape(Capsule())
                }
                NavigationStack {
                    List {
                        NavigationLink("Clients") {
                            SelectClientView()
                        }
//                        NavigationLink("Vehicles") {
//                            VehicleContentView()
//                        }
//                        NavigationLink("Expenses") {
//                            SelectVehicleView()
//                        }
                    }
                    .navigationTitle("Albers Law Practice")
                }
                .padding()
                
                Spacer()
            }
        }
    }
}

struct MainInterfaceView_Previews: PreviewProvider {
    static var previews: some View {
        MainInterfaceView()
    }
}
