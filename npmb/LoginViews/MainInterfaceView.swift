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
    
    enum Route: Hashable {
        case causes
        case clients
    }

    @State private var showingEditVehicleView = false
//    @State private var presentedViews:[String] = ["MainInterfaceView"]
    
    @EnvironmentObject var CVModel:CommonViewModel
    
//    @FirestoreQuery(collectionPath: "vehicles", predicates: []) var vehicles: [Vehicle]

    var body: some View {
//        ZStack {
//            Image("background")
//                .resizable()
//                .ignoresSafeArea()
//                .opacity(0.5)
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
                Text(CVModel.appStatus)
                NavigationStack {
                    VStack(alignment: .leading) {
                        NavigationLink("Clients") {
                            SelectClientView(selectOnly: false)
                        }
                        .font(.title)
                        .padding(.bottom, 10.0)
                        NavigationLink("Causes") {
                            SelectCauseView()
                        }
                        .font(.title)
                        .padding(.bottom, 10.0)
                        NavigationLink("Representations") {
                            SelectRepresentationView()
                        }
                        .font(.title)
                        .padding(.bottom, 10.0)
                        NavigationLink("Documents") {
                            DocumentMenuView()
                        }
                        .font(.title)
                        Spacer()
                    }
                    .padding(.bottom, 10.0)
                    
                    Spacer()
                    Text("SelectionOptions")
                        .font(.largeTitle)
                        .foregroundColor(.primary)

                        .navigationTitle("Albers Law Practice")
                }
                
                Spacer()
//            }
        }
    }
}

//
//struct MainInterfaceView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainInterfaceView()
//    }
//}
