//
//  DocumentListClients.swift
//  npmb
//
//  Created by Morris Albers on 5/19/24.
//

import SwiftUI

struct DocumentListClients: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var CVModel:CommonViewModel
    @State var clientList:[ClientModel] = []
    @State var reportNrOpen:Int = 0
    @State var report:String = ""
    @State var reportYear:String = ""
    @State var reportMonth:String = ""
    @State var reportMonthName:String = ""
    @State var header1Printed:Bool = false
    @State var lineNr:Int = 0
    @State var rcdNr:Int = 0
//    var docketDate:String
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                HStack {
                    Text("Clients on:")
                    Text(reportMonthName + ",")
                    Text(reportYear)
                    Spacer()
                }
                VStack {
                    ForEach(clientList, id: \.self) { cl in
                        Text(cl.printLine1).font(.system(.body, design: .monospaced))
                    }
                }
                HStack {
                    Spacer()
                    Button("Print?") {
                        createTextFile()
                    }
                    .buttonStyle(CustomNarrowButton())
                    .padding()
                    if report != "" {
                        Spacer()
                        ShareLink(item: report)
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
//      print("DocumentOpenCase initWorkArea")
//      opencase = []
//      CVModel.assembleExpandedRepresentations()
        clientList = CVModel.clients.sorted(by: { $0.internalID < $1.internalID } )
        report = ""
        reportNrOpen = 0
        header1Printed = false
        lineNr = 0
        rcdNr = 0
//        let array = docketDate.components(separatedBy: "-")
//        if array.count > 0 { reportYear = array[0] } else { reportYear = "9999" }
//        if array.count > 1 {
//            reportMonth = array[1]
//            reportMonthName = DateService.monthName(numMonth: Int(array[1]) ?? 99)
//        } else {
//            reportMonth = "99"
//            reportMonthName = "XXXXX"
//        }

//      for xrin in CVModel.expandedrepresentations {
//          if xrin.representation.active {
//              opencase.append(xrin)
//              reportNrOpen += 1
//          }
//      }
//
//      opencase = opencase.sorted(by: { $0.sortSequence1 < $1.sortSequence1} )
    }
    
    func createTextFile() {
        for cl in CVModel.clients.sorted(by: { $0.internalID < $1.internalID } ) {
            if rcdNr == 0 {
                report = "Morris E. Albers II, PLLC Client List for " + reportMonthName + ", " + reportYear + "\n\n"
                report += cl.printHeader1 + "\n"
                lineNr = 3
            } else {
                if lineNr > 86 {
                    report += "\u{0c}"
                    report += "Morris E. Albers II, PLLC Client List for " + reportMonthName + ", " + reportYear + "\n\n"
                    report += cl.printHeader1 + "\n"
                    lineNr = 3
                }
            }
            lineNr += 1
            rcdNr += 1
            report += cl.printLine1
            report += "\n"
        }
        rcdNr = 0
        for cl in CVModel.clients.sorted(by: { $0.formattedName < $1.formattedName } ) {
            if rcdNr == 0 {
                report += "Morris E. Albers II, PLLC Client List for " + reportMonthName + ", " + reportYear + "\n\n"
                report += cl.printHeader1 + "\n"
                lineNr = 3
            } else {
                if lineNr > 86 {
                    report += "\u{0c}"
                    report += "Morris E. Albers II, PLLC Client List for " + reportMonthName + ", " + reportYear + "\n\n"
                    report += cl.printHeader1 + "\n"
                    lineNr = 3
                }
            }
            lineNr += 1
            rcdNr += 1
            report += cl.printLine1
            report += "\n"
        }
    }
}

//struct DocumentOpenCase_Previews: PreviewProvider {
//    static var previews: some View {
//        DocumentOpenCase()
//    }
//}
