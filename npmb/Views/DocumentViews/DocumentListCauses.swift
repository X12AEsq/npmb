//
//  DocumentListCauses.swift
//  npmb
//
//  Created by Morris Albers on 5/20/24.
//

import SwiftUI

struct DocumentListCauses: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var CVModel:CommonViewModel
    @State var causeList:[CauseModel] = []
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
                    Text("Causes on:")
                    Text(reportMonthName + ",")
                    Text(reportYear)
                    Spacer()
                }
                VStack {
                    ForEach(causeList, id: \.self) { ca in
                        Text(ca.printLine1).font(.system(.body, design: .monospaced))
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
        causeList = CVModel.causes.sorted(by: { $0.internalID < $1.internalID } )
        report = ""
        reportNrOpen = 0
        header1Printed = false
        lineNr = 0
        rcdNr = 0
    }
    
    func createTextFile() {
        for ca in CVModel.causes.sorted(by: { $0.internalID < $1.internalID } ) {
            if rcdNr == 0 {
                report = "Morris E. Albers II, PLLC Cause List for " + reportMonthName + ", " + reportYear + "\n\n"
                report += ca.printHeader1 + "\n"
                lineNr = 3
            } else {
                if lineNr > 86 {
                    report += "\u{0c}"
                    report += "Morris E. Albers II, PLLC Cause List for " + reportMonthName + ", " + reportYear + "\n\n"
                    report += ca.printHeader1 + "\n"
                    lineNr = 3
                }
            }
            lineNr += 1
            rcdNr += 1
            report += ca.printLine1
            report += "\n"
        }
        report += "\u{0c}"
        rcdNr = 0
        for ca in CVModel.causes.sorted(by: { $0.causeNo < $1.causeNo } ) {
            if rcdNr == 0 {
                report += "Morris E. Albers II, PLLC Cause List for " + reportMonthName + ", " + reportYear + "\n\n"
                report += ca.printHeader1 + "\n"
                lineNr = 3
            } else {
                if lineNr > 86 {
                    report += "\u{0c}"
                    report += "Morris E. Albers II, PLLC Cause List for " + reportMonthName + ", " + reportYear + "\n\n"
                    report += ca.printHeader1 + "\n"
                    lineNr = 3
                }
            }
            lineNr += 1
            rcdNr += 1
            report += ca.printLine1
            report += "\n"
        }
    }
}

//struct DocumentOpenCase_Previews: PreviewProvider {
//    static var previews: some View {
//        DocumentOpenCase()
//    }
//}
