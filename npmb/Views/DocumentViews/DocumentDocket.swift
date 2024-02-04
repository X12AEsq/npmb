//
//  DocumentDocket.swift
//  npmb
//
//  Created by Morris Albers on 4/12/23.
//
/*
import SwiftUI

struct DocumentDocket: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var CVModel:CommonViewModel
    @State var docketed:[ExpandedAppearance] = []
    @State var extras:[ClientModel] = []
    @State var docket:String = ""
    @State var todaysDate:String = ""
    var docketDate:String
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                ForEach(docketed, id: \.appearance.id) { docketEntry in
                    Text(docketEntry.printLine).font(.system(.body, design: .monospaced)).foregroundStyle
                }
                if extras.count > 0 {
                    VStack (alignment: .leading) {
                        Text("Extras:")
                        ForEach(extras, id:\.self) {cl in
                            Text(cl.formattedName)
                        }
                    }
                    .padding(.top, 10.0)
                }
                HStack {
                    Spacer()
                    Button("Print?") {
                        createTextFile()
                    }
                    .buttonStyle(CustomNarrowButton())
                    .padding()
                    if docket != "" {
                        Spacer()
                        ShareLink(item: docket)
                    }
                    Spacer()
                    Button("Press to dismiss") {
                        dismiss()
                    }
                    .buttonStyle(CustomDismissButton())
                    .padding()
                    Spacer()
                }
            }
            .padding(.leading, 10.0)
        }.onAppear( perform: { initWorkArea() } )
    }
    
    func initWorkArea() {
        docketed = []
        docket = ""
        todaysDate = DateService.dateDate2String(inDate: Date())
        for appr in CVModel.appearances {
            if appr.appearDate == docketDate {
                let xa = ExpandedAppearance()
                xa.appearance = appr
                xa.cause = CVModel.findCause(internalID: appr.involvedCause)
                xa.client = CVModel.findClient(internalID: appr.involvedClient)
                xa.representation = CVModel.findRepresentation(internalID: appr.involvedRepresentation)
                docketed.append(xa)
            }
        }
        docketed = docketed.sorted(by: { $0.sortSequence < $1.sortSequence} )
        
        for cl in CVModel.clients {
            if cl.miscDocketDate != "" {
                if cl.miscDocketDate < todaysDate {
                    updateClient(clientID: cl.id ?? "", miscDocketDate: "")
                }
                if cl.miscDocketDate == docketDate {
                    extras.append(cl)
                }
            }
        }
        extras = extras.sorted(by: { $0.formattedName < $1.formattedName} )
    }
    
    func createTextFile() {
        docket = "Morris E. Albers II, PLLC Docket for " + docketDate + "\n\n"
        for xa in docketed {
            docket += xa.printLine + "\n"
        }
        
        if extras.count > 0 {
            docket += "\n\nExtras:\n\n"
            for cl in extras {
                docket += cl.formattedName + "\n"
            }
        }
    }
    
    func updateClient(clientID:String, miscDocketDate:String) {
        Task {
            await CVModel.updateClientMiscDate(clientID: clientID, miscDocketDate: miscDocketDate )
        }
    }

}

//struct DocumentDocket_Previews: PreviewProvider {
//    static var previews: some View {
//        DocumentDocket()
//    }
//}
*/
