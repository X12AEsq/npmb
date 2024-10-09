//
//  MainInterfaceView.swift
//  ah2404
//
//  Created by Morris Albers on 2/20/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
//import SwiftData

@available(iOS 17.0, *)
struct MainInterfaceView: View {
    
//    enum Route: Hashable {
//        case causes
//        case clients
//    }

    @State private var showingLogView = false
//    @State private var presentedViews:[String] = ["MainInterfaceView"]
    
    @EnvironmentObject var CVModel:CommonViewModel
//    @Environment(\.modelContext) var modelContext
//    @Query(filter: #Predicate<SDPractice> { prac in
//        prac.internalId == 1 }) var testPractice: [SDPractice]
//    @Query(filter: #Predicate<SDPractice> { prac in
//        prac.internalId == 2 }) var prodPractice: [SDPractice]

//    @FirestoreQuery(collectionPath: "vehicles", predicates: []) var vehicles: [Vehicle]

    var body: some View {
//        ZStack {
//            Image("background")
//                .resizable()
//                .ignoresSafeArea()
//                .opacity(0.5)
            VStack {
//                Button {
//                    do {
//                        try modelContext.delete(model: SDPractice.self, where: #Predicate { $0.internalId != 0 })
//                        print("practices deleted")
//                    } catch {
//                        print("Failed to delete practices.")
//                    }
//                    let practicet = SDPractice(addr1: "151 N. Washington St.", addr2: "PO Box 999", city: "Armpit", internalID: 1, name: "Test Practice", shortName: "Test Law Practice", state: "KY", testing: true, zip: "90909")
//                    practicet.clients = [SDClient]()
//                    practicet.causes = [SDCause]()
//                    modelContext.insert(practicet)
//                    do {
//                        try modelContext.save()
//                    } catch {
//                        print("error inserting test practice: \(error.localizedDescription)")
//                    }
//                    let practice = SDPractice(addr1: "159 W. Crockett St.", addr2: "PO Box 653", city: "La Grange", internalID: 2, name: "Morris E. Albers II, Attorney and Counsellor at Law, PLLC", shortName: "Albers Law Practice", state: "TX", testing: false, zip: "78945")
//                    practice.clients = [SDClient]()
//                    practice.causes = [SDCause]()
//                    modelContext.insert(practice)
//                    do {
//                        try modelContext.save()
//                    } catch {
//                        print("error inserting production practice: \(error.localizedDescription)")
//                    }
//                } label: {
//                    Text("Delete and reload practices")
//                }
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
                        .padding(.bottom, 10.0)
                        NavigationLink("Backup") {
                            BackupMenuView()
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
