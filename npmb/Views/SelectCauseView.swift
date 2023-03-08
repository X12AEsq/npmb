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
    @State private var sortedCauses:[CauseModel] = []
    @State private var sortMessage:String = "By Cause"
    @State private var filterText:String = ""
    @State private var selectedCause:CauseModel = CauseModel()
    
    @EnvironmentObject var CVModel:CommonViewModel
        
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading) {
                Text("Causes").font(.title)
                HStack {
                    Button {
                        sortedCauses = sortThem(option: 1)
                        sortOption = 1
                        filterText = ""
                        sortMessage = "By Cause"
                    } label: {
                        Text("By Cause")
                    }
                    .buttonStyle(CustomButton())
                    Button {
                        sortedCauses = sortThem(option: 2)
                        sortOption = 2
                        filterText = ""
                        sortMessage = "By ID"
                    } label: {
                        Text("By ID")
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
                        NavigationLink(destination: { EditCauseView() }, label: { Text("Add New Cause") })
                        Spacer()
                    }
                    ForEach(sortedCauses) { cause in
                        HStack {
                            NavigationLink(destination: { EditCauseView(cause: cause) },
                                label: { Text(linkLabel(cause:cause, option:sortOption)) })
                            Spacer()
                        }
                    }
                }
                .onAppear {
                    sortedCauses = sortThem(option: 1)
                }
            }
            .listStyle(.plain)
//            .navigationTitle("Which Cause?")
        }
    }
    
    func filterThem(prefix:String, option:Int) -> Void {
        if option == 1 {
            sortedCauses = sortThem(option: option).filter { $0.sortFormat1.hasPrefix(prefix) }
        } else {
            sortedCauses = sortThem(option: option).filter { $0.sortFormat2.hasPrefix(prefix) }
        }
    }
    
    func sortThem(option:Int) -> [CauseModel] {
        if option == 1 {
            return CVModel.causes.sorted {$0.causeNo < $1.causeNo }
        } else {
            return CVModel.causes.sorted {$0.internalID < $1.internalID }
        }
    }
    
    func linkLabel(cause:CauseModel, option:Int) -> String {
        var returnString = ""
        if option == 1 {
            returnString = cause.sortFormat1
        } else {
            returnString = cause.sortFormat2
        }
        if returnString.hasPrefix(" ") {
        }
        return "." + returnString + "."
    }
                        
}


//struct SelectCauseView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectCauseView()
//    }
//}

/*
 var doList: some View {
     VStack {
         GeometryReader { geo in
             ScrollView {
                 VStack (alignment: .leading) {
                     ForEach(rxs) { rexm in
                         VStack {
                             HStack {
                                 ActionEdit()
                                     .onTapGesture {
                                         sortedClients = pcvm.clients.sorted {
                                             $0.formattedName < $1.formattedName
                                         }
                                         sortedCauses = pcvm.causes.sorted {
                                             $0.causeNo < $1.causeNo
                                         }
                                         clientSelectionIndex = 0
                                         causeSelectionIndex = 0
                                         selectedRepresentation = rexm.reinternalID
                                         _ = pcvm.assembleRCB(id: selectedRepresentation)
                                         if pcvm.rcb.rcbRep.internalID == 0 {
                                             statusMessage = "Could not locate selected representation"
                                         } else {
                                             statusMessage = ""
                                             extractRepresentation(rep: pcvm.rcb.rcbRep)
                                             pathOption = NextAction.gotoedit
                                         }
                                     }
                                     .frame(width: geo.size.width * 0.035)
                                     .background(Color.blue)
                                     .foregroundColor(.white)
                                     .cornerRadius(10)
                                 ActionDisplay()
                                     .onTapGesture {
                                         print("Selected")
                                         selectedRepresentation = rexm.reinternalID
                                         _ = pcvm.assembleRCB(id: selectedRepresentation)
                                         if pcvm.rcb.rcbRep.internalID == 0 {
                                             statusMessage = "Could not locate selected representation"
                                         } else {
                                             statusMessage = ""
                                             pathOption = NextAction.detail
                                         }
                                     }
                                     .frame(width: geo.size.width * 0.035)
                                     .background(Color.green)
                                     .foregroundColor(.white)
                                     .cornerRadius(10)
                                 ActionAddAppear()
                                     .onTapGesture {
                                         selectedRepresentation = rexm.reinternalID
                                         _ = pcvm.assembleRCB(id: selectedRepresentation)
                                         if pcvm.rcb.rcbRep.internalID == 0 {
                                             statusMessage = "Could not locate selected representation"
                                         } else {
                                             statusMessage = ""
                                             pathOption = NextAction.addappear
                                         }
                                     }
                                     .frame(width: geo.size.width * 0.035)
                                     .background(Color.yellow)
                                     .foregroundColor(.black)
                                     .cornerRadius(10)
                                 ActionAddNote()
                                     .onTapGesture {
                                         selectedRepresentation = rexm.reinternalID
                                         _ = pcvm.assembleRCB(id: selectedRepresentation)
                                         if pcvm.rcb.rcbRep.internalID == 0 {
                                             statusMessage = "Could not locate selected representation"
                                         } else {
                                             statusMessage = ""
                                             initNoteWorkArea()
                                             pathOption = NextAction.addnote
                                         }
                                     }
                                     .frame(width: geo.size.width * 0.035)
                                     .background(Color.black)
                                     .foregroundColor(.yellow)
                                     .cornerRadius(10)
                                 Text(String(rexm.reinternalID)).frame(width: geo.size.width * 0.045, alignment: .trailing).foregroundColor(.black)
                                 Text(String(rexm.reassignedDate)).frame(width: geo.size.width * 0.145, alignment: .trailing).foregroundColor(.black)
                                 Text(actinact(inp:rexm.reactive)).frame(width: geo.size.width * 0.09, alignment: .leading).foregroundColor(.black)
                                 Text(rexm.cacauseNo).frame(width: geo.size.width * 0.15, alignment: .leading).foregroundColor(.black)
                                 Text(rexm.clformattedName).frame(width: geo.size.width * 0.4, alignment: .leading).foregroundColor(.black)
                             }.frame(width: geo.size.width, height:geo.size.height * 0.02, alignment: .leading).foregroundColor(.black)
                         }
                     }
                 }
             }
         }
     }
 }

 */
