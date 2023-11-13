//
//  DocumentOpenCase.swift
//  npmb
//
//  Created by Morris Albers on 4/21/23.
//

import SwiftUI

struct DocumentOpenCase: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var CVModel:CommonViewModel
    @State var opencase:[ExpandedRepresentation] = []
    @State var reportNrOpen:Int = 0
    @State var report:String = ""
    @State var reportYear:String = ""
    @State var reportMonth:String = ""
    @State var reportMonthName:String = ""
    @State var header1Printed:Bool = false
    @State var lineNr:Int = 0
    @State var rcdNr:Int = 0
    var docketDate:String
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                HStack {
                    Text("Open Cases on:")
                    Text(reportMonthName + ",")
                    Text(reportYear)
                    Text("- Total active:")
                    Text(String(reportNrOpen))
                    Spacer()
                }
                VStack {
                    Text("Open items")
                    ForEach(opencase, id: \.representation.id) { docketEntry in
                        Text(docketEntry.printLine).font(.system(.body, design: .monospaced))
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
        print("DocumentOpenCase initWorkArea")
        opencase = []
        CVModel.assembleExpandedRepresentations()
        report = ""
        reportNrOpen = 0
        header1Printed = false
        lineNr = 0
        rcdNr = 0
        let array = docketDate.components(separatedBy: "-")
        if array.count > 0 { reportYear = array[0] } else { reportYear = "9999" }
        if array.count > 1 {
            reportMonth = array[1]
            reportMonthName = DateService.monthName(numMonth: Int(array[1]) ?? 99)
        } else {
            reportMonth = "99"
            reportMonthName = "XXXXX"
        }

        for xrin in CVModel.expandedrepresentations {
            if xrin.representation.active {
                opencase.append(xrin)
                reportNrOpen += 1
            }
        }
 
        opencase = opencase.sorted(by: { $0.sortSequence1 < $1.sortSequence1} )
    }
    
    func createTextFile() {
        for xr in opencase {
            if rcdNr == 0 {
                report = "Morris E. Albers II, PLLC Open Items Report for " + reportMonthName + ", " + reportYear + "\n"
                report += "Total active:" + String(reportNrOpen) + "\n\n"

                report += FormattingService.spaces(len: 4) + "Open Items\n"
                report += xr.headerLine3
                lineNr = 2
            } else {
                if lineNr > 65 {
                    report += "\u{0c}"
                    report += "Morris E. Albers II, PLLC Open Items Report for " + reportMonthName + ", " + reportYear + "\n"
                    report += "Total active:" + String(reportNrOpen) + "\n\n"

                    report += FormattingService.spaces(len: 4) + "Open Items\n"
                    report += xr.headerLine3
                    lineNr = 2
                }
            }
            lineNr += 1
            rcdNr += 1
            report += FormattingService.rjf(base: String(rcdNr), len: 3, zeroFill: false)
            report += " "
            report += xr.printLine
            report += FormattingService.ljf(base: xr.nextDate, len: 11)
            report += "\n"
        }
    }
}

//struct DocumentOpenCase_Previews: PreviewProvider {
//    static var previews: some View {
//        DocumentOpenCase()
//    }
//}
