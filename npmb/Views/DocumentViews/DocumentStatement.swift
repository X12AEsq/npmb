//
//  DocumentStatement.swift
//  npmb
//
//  Created by Morris Albers on 4/13/23.
//

import SwiftUI

struct DocumentStatement: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var CVModel:CommonViewModel
    @State var docketed:[ExpandedRepresentation] = []
    @State var assigned:[ExpandedRepresentation] = []
    @State var opencase:[ExpandedRepresentation] = []
    @State var closed:[ExpandedRepresentation] = []
    @State var reportNrClosed:Int = 0
    @State var reportNrAssigned:Int = 0
    @State var reportNrOpen:Int = 0
    @State var report:String = ""
    @State var reportYear:String = ""
    @State var reportMonth:String = ""
    @State var reportMonthName:String = ""
    @State var header1Printed:Bool = false
    @State var header2Printed:Bool = false
    @State var header3Printed:Bool = false
    var docketDate:String
//    var monthName:[String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                HStack {
                    Text("Monthly report for:")
                    Text(reportMonthName + ",")
                    Text(reportYear)
                    Spacer()
                }
                HStack {
                    Text("Assigned this month:")
                    Text(String(reportNrAssigned))
                    Text("Closed this month:")
                    Text(String(reportNrClosed))
                    Text("Total active:")
                    Text(String(reportNrOpen))
                    Spacer()
                }
                VStack {
                    Text("Closed items")
                    ForEach(closed, id: \.representation.id) { docketEntry in
//                        if docketEntry.xpcause.cause.level != "CPS" {
                            Text(docketEntry.printLine).font(.system(.body, design: .monospaced))
//                        }
                    }
                }
                VStack {
                    Text("Assigned items")
                    ForEach(assigned, id: \.representation.id) { docketEntry in
//                        if docketEntry.xpcause.cause.level != "CPS" {
                            Text(docketEntry.printLine).font(.system(.body, design: .monospaced))
//                        }
                    }
                }
                VStack {
                    Text("Open items")
                    ForEach(opencase, id: \.representation.id) { docketEntry in
//                        if docketEntry.xpcause.cause.level != "CPS" {
                            Text(docketEntry.printLine).font(.system(.body, design: .monospaced))
//                        }
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
    
//    var headerLine:String {
//        var line:String = ""
//        line += FormattingService.ljf(base: "Cause No", len: 11)
//        line += FormattingService.ljf(base: "Client Name", len: 32)
//        line += FormattingService.ljf(base: "Lev", len: 4)
//        line += FormattingService.ljf(base: "Court", len: 6)
//        line += FormattingService.ljf(base: "Proc", len: 5)
//        line += FormattingService.ljf(base: "Disp", len: 5)
//        line += "\n\n"
//        return line
//    }
    
    func initWorkArea() {
        assigned = []
        opencase = []
        closed = []
        CVModel.assembleExpandedRepresentations()
        report = ""
        reportNrAssigned = 0
        reportNrClosed = 0
        reportNrAssigned = 0
        reportNrOpen = 0
        header1Printed = false
        header2Printed = false
        header3Printed = false
//        var xrwork:ExpandedRepresentation = ExpandedRepresentation()
        let array = docketDate.components(separatedBy: "-")
        if array.count > 0 { reportYear = array[0] } else { reportYear = "9999" }
        if array.count > 1 {
            reportMonth = array[1]
            reportMonthName = DateService.monthName(numMonth: Int(array[1]) ?? 99)
//            var myIdx = Int(array[1]) ?? 99
//            myIdx -= 1
//            if myIdx < 90 {
//                reportMonthName = monthName[myIdx]
//            } else {
//                reportMonthName = "XXXXX"
//            }
        } else {
            reportMonth = "99"
            reportMonthName = "XXXXX"
        }

        let filterMonth:Int = Int(reportMonth) ?? 99
        let filterYear:Int = Int(reportYear) ?? 9999

        for xrin in CVModel.expandedrepresentations {
            var targetMonth:Int = Int(xrin.representation.MonthAssigned) ?? 0
            var targetYear:Int = Int(xrin.representation.YearAssigned) ?? 0
            if targetYear == filterYear && targetMonth == filterMonth {
//                xrwork = xrin
//                if xrwork.
                assigned.append(xrin)
                reportNrAssigned += 1
            }
            if xrin.xpcause.cause.level != "CPS"
                && xrin.xpcause.cause.level != "GS"
                && xrin.xpcause.cause.causeType != "Priv"{
                if xrin.representation.active {
                    opencase.append(xrin)
                    reportNrOpen += 1
                } else {
                    targetYear = Int(xrin.representation.YearDisposed) ?? 0
                    targetMonth = Int(xrin.representation.MonthDisposed) ?? 0
                    if targetYear == filterYear && targetMonth == filterMonth {
                        reportNrClosed += 1
                        closed.append(xrin)
                    }
                }
            }
        }
        print("assembled")
        closed = closed.sorted(by: { $0.sortSequence1 < $1.sortSequence1} )
        assigned = assigned.sorted(by: { $0.sortSequence1 < $1.sortSequence1} )
        opencase = opencase.sorted(by: { $0.sortSequence1 < $1.sortSequence1} )
//        docketed = docketed.sorted(by: { $0.appearance.sortSequence < $1.appearance.sortSequence} )
    }
    
    func createTextFile() {
        report = "Morris E. Albers II, PLLC Report for " + reportMonthName + ", " + reportYear + "\n"
        report += "Assigned this month:" + String(reportNrAssigned) + "; Closed this month:" + String(reportNrClosed) + "; Total active:" + String(reportNrOpen) + "\n\n"

        for xr in assigned {
            if !header1Printed {
                report += "\n"
                report += "Assigned\n"
                report += xr.headerLine
                header1Printed = true
            }
//            report += xr.printLine.replacingOccurrences(of: " ", with: "%") + "\n"
            report += xr.printLine + "\n"
        }
        
        for xr in closed {
            if !header2Printed {
                report += "\n"
                report += "Closed\n"
                report += xr.headerLine
                header2Printed = true
            }
            report += xr.printLine + "\n"
        }
        
        for xr in opencase {
            if !header3Printed {
                report += "\n"
                report += "Open Items\n"
                report += xr.headerLine
                header3Printed = true
            }
            report += xr.printLine + "\n"
        }
    }
}

//struct DocumentStatement_Previews: PreviewProvider {
//    static var previews: some View {
//        DocumentStatement()
//    }
//}
