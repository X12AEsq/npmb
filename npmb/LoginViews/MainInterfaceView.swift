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

//struct SelectionOption: Identifiable, Hashable {
//    let id = UUID()
//    let name: String
//}
//
//extension SelectionOption {
//    static var data: [SelectionOption] {
//        return [
//            .init(name: "Bangla"),
//            .init(name: "English"),
//            .init(name: "Science")
//        ]
//    }
//}
//
//struct SelectionOptionView: View {
//    let option: SelectionOption
//
//    init(_ option: SelectionOption) {
//        self.option = option
//    }
//
//    var body: some View {
//        VStack {
//            Text("Your selected option is:")
//            Text(option.name)
//                .bold()
//                .shadow(radius: 2)
//            Button {
//                path.
////                Text("Pushing " + option.name)
//            } label: {
//                Text("Push Screen B")
//            }
//        }
//    }
//}
//
//struct MainInterfaceView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainInterfaceView()
//    }
//}
