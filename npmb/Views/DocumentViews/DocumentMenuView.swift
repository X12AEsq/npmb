//
//  DocumentMenuView.swift
//  npmb
//
//  Created by Morris Albers on 4/12/23.
//

import SwiftUI
// ShareLink(item: "Check out this new feature on iOS 16")

@available(iOS 17, *)
struct DocumentMenuView: View {
    @EnvironmentObject var CVModel:CommonViewModel
    @State private var showingDocket = false
    @State private var showingReport = false
    @State private var showingCaseList = false
    @State private var showingOpenList = false
    @State private var showingToDoList = false
    @State private var showingComingList = false
    @State private var showingListClients = false
    @State private var showingListCauses = false
    @State private var showingListRepresentations = false
    @State var actionIntDate:Date = Date()
    @State var actionExtDate:String = DateService.dateDate2String(inDate: Date())

    var body: some View {
        VStack (alignment: .center) {
            HStack {
                Spacer()
                DatePicker("Selection Date", selection: $actionIntDate, displayedComponents: [.date])
                    .padding()
                    .onChange(of: actionIntDate, perform: { value in
                        actionExtDate = DateService.dateDate2String(inDate: value)
                    })
                Spacer()
            }.frame(minWidth: 75, maxWidth: 300)

            Button {
                 showingDocket.toggle()
            } label: {
                Text("Docket for " + actionExtDate).font(.system(.body, design: .monospaced))
            }
            .buttonStyle(CustomNarrowButton())
            .sheet(isPresented: $showingDocket, onDismiss: {
                print("Dismissed")
            })
            { DocketView(docketDate: actionExtDate) }
            
            Button {
                showingReport.toggle()
            } label: {
                Text("Report for " + actionExtDate).font(.system(.body, design: .monospaced))
            }
            .buttonStyle(CustomNarrowButton())
            .sheet(isPresented: $showingReport, onDismiss: {
                print("Document Statement Dismissed")
            })
            { MonthlyReportView(docketDate: actionExtDate) }
            
            Button {
                showingOpenList.toggle()
            } label: {
                Text("Open Cases as of " + actionExtDate).font(.system(.body, design: .monospaced))
            }
            .buttonStyle(CustomNarrowButton())
            .sheet(isPresented: $showingOpenList, onDismiss: {
                print("Document Open Case List Dismissed")
            })
            { DocumentOpenCase(docketDate: actionExtDate) }
            
            Button {
                showingCaseList.toggle()
            } label: {
                Text("Cases as of " + actionExtDate).font(.system(.body, design: .monospaced))
            }
            .buttonStyle(CustomNarrowButton())
            .sheet(isPresented: $showingCaseList, onDismiss: {
                print("Document Case List Dismissed")
            })
            { DocumentAllCases(docketDate: actionExtDate) }
            
            Button {
                showingToDoList.toggle()
            } label: {
                Text("To Do List").font(.system(.body, design: .monospaced))
            }
            .buttonStyle(CustomNarrowButton())
            .sheet(isPresented: $showingToDoList, onDismiss: {
                print("ToDo List Dismissed")
            })
            { ToDoListView() }
            
            Button {
                showingComingList.toggle()
            } label: {
                Text("Coming Attractions").font(.system(.body, design: .monospaced))
            }
            .buttonStyle(CustomNarrowButton())
            .sheet(isPresented: $showingComingList, onDismiss: {
                print("Coming Attractions Dismissed")
            })
            { DocumentComingAttractions() }
            
            Button {
                showingListClients.toggle()
            } label: {
                Text("List Clients").font(.system(.body, design: .monospaced))
            }
            .buttonStyle(CustomNarrowButton())
            .sheet(isPresented: $showingListClients, onDismiss: {
                print("List Clients")
            })
            { DocumentListClients() }
            
            Button {
                showingListCauses.toggle()
            } label: {
                Text("List Causes").font(.system(.body, design: .monospaced))
            }
            .buttonStyle(CustomNarrowButton())
            .sheet(isPresented: $showingListCauses, onDismiss: {
                print("List Causes")
            })
            { DocumentListCauses() }
            
            Button {
                showingListRepresentations.toggle()
            } label: {
                Text("List Representations").font(.system(.body, design: .monospaced))
            }
            .buttonStyle(CustomNarrowButton())
            .sheet(isPresented: $showingListRepresentations, onDismiss: {
                print("List Representations")
            })
            { DocumentListRepresentations() }

            Spacer()
        }
    }
    
    var docketOptions: some View {
        VStack (alignment: .center) {
            Text("Options")
        }
    }
}

//struct DocumentMenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        DocumentMenuView()
//    }
//}
