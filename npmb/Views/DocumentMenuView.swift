//
//  DocumentMenuView.swift
//  npmb
//
//  Created by Morris Albers on 4/12/23.
//

import SwiftUI
// ShareLink(item: "Check out this new feature on iOS 16")

struct DocumentMenuView: View {
    @EnvironmentObject var CVModel:CommonViewModel
    @State private var showingDocket = false
    @State private var showingReport = false
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
                { DocumentDocket(docketDate: actionExtDate) }

            Button {
                showingReport.toggle()
            } label: {
                Text("Report for " + actionExtDate).font(.system(.body, design: .monospaced))
            }
            .buttonStyle(CustomNarrowButton())
            .sheet(isPresented: $showingReport, onDismiss: {
                print("Dismissed")
            })
            { DocumentStatement(docketDate: actionExtDate) }
        
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
