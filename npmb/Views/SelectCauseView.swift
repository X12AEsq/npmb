//
//  SelectCauseView.swift
//  npmb
//
//  Created by Morris Albers on 3/2/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@available(iOS 15.0, *)
struct SelectCauseView: View {
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
                    Text("By Cause")
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
                    NavigationLink(destination: { EditCauseView() }, label: { Text("Add New Cause") })
                    switch sortOption {
                    case 1:
                        ForEach(CVModel.causes.sorted {$0.causeNo < $1.causeNo }) { cause in
                            NavigationLink(cause.sortFormat1) {
                                EditCauseView(cause: cause)
                            }
                        }
                    case 2:
                        ForEach(CVModel.causes.sorted {$0.internalID < $1.internalID }) { cause in
                            NavigationLink(cause.sortFormat2) {
                                EditCauseView(cause: cause)
                            }
                        }
                    default:
                        ForEach(CVModel.causes.sorted {$0.causeNo < $1.causeNo }) { cause in
                            NavigationLink(cause.sortFormat1) {
                                EditCauseView(cause: cause)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Which Cause?")
        }
    }
}

//struct SelectCauseView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectCauseView()
//    }
//}
