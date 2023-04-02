//
//  SelectRepresentationView.swift
//  npmb
//
//  Created by Morris Albers on 3/9/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

@available(iOS 15.0, *)
struct SelectRepresentationView: View {
    @State private var sortOption = 1
    @State private var sortedRepresentations:[RepresentationModel] = []
//    @State private var sortedRX:[RepresentationExpansion] = []

    @State private var sortMessage:String = "By Client"
    @State private var filterText:String = ""
    @State private var selectedRepresentation:RepresentationModel = RepresentationModel()
    @State private var selectedRX:RepresentationExpansion = RepresentationExpansion()
    
    @EnvironmentObject var CVModel:CommonViewModel

    var body: some View {
        NavigationStack {
            VStack (alignment: .leading) {
                Text("Representations").font(.title)
                HStack {
                    Button {
                        sortedRepresentations = sortThem(option: 1)
                        sortOption = 1
                        filterText = ""
                        sortMessage = "By Client"
                    } label: {
                        Text("By Client")
                    }
                    .buttonStyle(CustomButton())
                    Button {
                        sortedRepresentations = sortThem(option: 2)
                        sortOption = 2
                        filterText = ""
                        sortMessage = "By Cause"
                    } label: {
                        Text("By Cause")
                    }
                    .buttonStyle(CustomButton())
                }
                HStack {
                    Text("Filter " + sortMessage)
                    TextField("", text: $filterText)
                        .background(Color.gray.opacity(0.3))
                        .onChange(of: filterText, perform: { newvalue in
                            filterThem(prefix: filterText, option: sortOption)
                        })
                    Spacer()
                }
            }
                
            ScrollView {
                VStack (alignment: .leading) {
                    HStack {
                        NavigationLink(destination: { EditRepresentationView(rxid: 0) }, label: { Text("Add New Representation") })
                            .padding(.bottom, 20)
                         Spacer()
                    }
                    ForEach(sortedRepresentations) { rx in
                        HStack {
                            NavigationLink(destination: { EditRepresentationView(rxid: rx.internalID) },
                                           label: { LineLabel(option: sortOption, rm: rx) })
                            Spacer()
                        }
                    }
                }
                .onAppear {
                    filterThem(prefix: filterText, option: sortOption)
                }
            }
            .listStyle(.plain)
//            .navigationTitle("Which Representation?")
        }
    }

    func filterThem(prefix:String, option:Int) -> Void {
        if option == 1 {
            sortedRepresentations = sortThem(option: option).filter { $0.cause.client.formattedName.hasPrefix(prefix) }
        } else {
            sortedRepresentations = sortThem(option: option).filter { $0.cause.causeNo.hasPrefix(prefix) }
        }
    }

    func sortThem(option:Int) -> [RepresentationModel] {
//        var rm:[RepresentationModel] = []
//        for item in CVModel.representations {
//            let newrx = RepresentationExpansion(rm: item)
//            newrx.client = CVModel.findClient(internalID: item.involvedClient)
//            newrx.cause = CVModel.findCause(internalID: item.involvedCause)
//            newrx.appearances = CVModel.assembleAppearances(repID: item.internalID)
//            newrx.notes = CVModel.assembleNotes(repID: item.internalID)
//            rx.append(newrx)
//        }
        if option == 1 {
            return CVModel.representations.sorted { $0.cause.client.formattedName < $1.cause.client.formattedName }
        } else {
            return CVModel.representations.sorted { $0.cause.causeNo < $1.cause.causeNo }
        }
    }
    
//    func linkLabel(rx:RepresentationExpansion, option:Int) -> String {
//        var returnString = ""
//        if option == 1 {
//            returnString = rx.client.formattedName
//        } else {
//            returnString = rx.cause.causeNo
//        }
//        return "." + returnString
//    }
}

struct LineLabel: View {
    var option:Int
    var rm:RepresentationModel
    var body: some View {
        HStack {
            Image(systemName: "rectangle.portrait.and.arrow.forward")
            Text((option == 1) ? rm.cause.client.formattedName : rm.cause.causeNo)
        }
    }

}

//struct SelectRepresentationView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectRepresentationView()
//    }
//}
