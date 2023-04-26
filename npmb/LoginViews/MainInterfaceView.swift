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
    
//    enum Route: Hashable {
//        case causes
//        case clients
//    }

    @State private var showingLogView = false
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
                if CVModel.inTesting { Text("Test in Progress") }
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
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            CVModel.inTesting.toggle()
                            if !CVModel.inTesting {
                                CVModel.testLog = ""
                            }
                        } label: {
                            Text("Toggle Testing")
                        }
                        .buttonStyle(CustomNarrowButton())
                        if CVModel.inTesting {
                            Button {
                                showingLogView.toggle()
                            } label: {
                                Text("Show log")
                            }
                            .buttonStyle(CustomNarrowButton())
                            .sheet(isPresented: $showingLogView) {
                                LogView
                            }
                            if CVModel.testLog != "" {
                                Spacer()
                                ShareLink(item: CVModel.testLog)
                            }
//                            Spacer()
                        }
                        Spacer()
                    }

                }
                
                Spacer()
//            }
        }
    }
    
    var LogView: some View {
        ScrollView {
            VStack (alignment: .leading) {
                Text(CVModel.testLog)
            }
        }
    }
}

//
//struct MainInterfaceView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainInterfaceView()
//    }
//}
