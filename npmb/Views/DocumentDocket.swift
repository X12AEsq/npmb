//
//  DocumentDocket.swift
//  npmb
//
//  Created by Morris Albers on 4/12/23.
//

import SwiftUI

struct DocumentDocket: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var CVModel:CommonViewModel
    @State var docketed:[ExpandedAppearance] = []
    @State var docket:String = ""
    var docketDate:String
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                ForEach(docketed, id: \.appearance.id) { docketEntry in
                    Text(docketEntry.printLine).font(.system(.body, design: .monospaced))
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
    }
    
    func createTextFile() {
        docket = "Morris E. Albers II, PLLC Docket for " + docketDate + "\n\n"
        for xa in docketed {
            docket += xa.printLine + "\n"
        }
    }
}

//struct DocumentDocket_Previews: PreviewProvider {
//    static var previews: some View {
//        DocumentDocket()
//    }
//}
