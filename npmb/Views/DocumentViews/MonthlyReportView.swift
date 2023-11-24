//
//  MonthlyReportView.swift
//  npmb
//
//  Created by Morris Albers on 11/23/23.
//

import SwiftUI

struct MonthlyReportView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var CVModel:CommonViewModel

    var docketDate:String

    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                TXTViewer(textData: createReport().npmLinearEquivalent)
                HStack {
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
    }
 
    func createReport() -> npmReport {
        CVModel.txtCreator.setNPMLines(reportLines: npmReport(npmTitle: "Monthly Report for " + Date.now.formatted(date: .long, time: .shortened),
                npmNrPages: 0,
                npmWaterMark: UIImage(named: "AlbersMorrisLOGO copy") ?? UIImage(),
                npmTitleHeight: 0.0,
                npmTitleBottom: 0.0,
                npmRawLines: self.createTextFile(),
                npmPrettyLines: [],
                npmPrettyBlocks: [],
                npmPages: []))
        let report = CVModel.txtCreator.createDocument()
        
        return report
    }

    func createTextFile() -> [String] {
        var report:[String] = []
        var expanded:[ExpandedRepresentation] = []
        
        for rep in CVModel.representations {
            let xpr:ExpandedRepresentation = ExpandedRepresentation()
            xpr.representation = rep
            let cau = CVModel.causes.first(where: { $0.internalID == xpr.representation.involvedCause })
            let cli = CVModel.findClient(internalID: cau?.involvedClient ?? 99999)
            let xpc:ExpandedCause = ExpandedCause(cause: cau ?? CauseModel(), client: cli)
            xpr.xpcause = xpc
            xpr.appearances = CVModel.assembleAppearances(repID: xpr.representation.internalID)
            xpr.notes = CVModel.assembleNotes(repID: xpr.representation.internalID)
            expanded.append(xpr)
        }

        let dateValues = getMonth(inDate: docketDate)
        let statValues = getStats(inMonth: dateValues.monthNumber, inYear: dateValues.yearString, inData: expanded)
        report.append("*Assigned this month:" + String(statValues.reportNrAssigned) + "; Closed this month:" + String(statValues.reportNrClosed) + "; Total active:" + String(statValues.reportNrOpen) + "\n\n")
        return report
    }
    
    func getMonth(inDate:String) -> (yearString:String, monthNumber:Int, monthName:String) {
        var rptYear:String = "XXXX"
        var rptMonth:Int = 99
        var rptName:String = "XXXX"
        let array = inDate.components(separatedBy: "-")
        if array.count > 0 { rptYear = array[0] }
        if array.count > 1 {
            rptMonth = Int(array[1]) ?? 99
            rptName = DateService.monthName(numMonth: Int(array[1]) ?? 99)
        }
        return(rptYear, rptMonth, rptName)
    }
    
    func getStats(inMonth:Int, inYear:String, inData:[ExpandedRepresentation]) -> ( assigned:[ExpandedRepresentation], opencase:[ExpandedRepresentation], closed:[ExpandedRepresentation], reportNrClosed:Int, reportNrAssigned:Int, reportNrOpen:Int) {
        let filterMonth:Int = inMonth
        let filterYear:Int = Int(inYear) ?? 9999
        var assigned:[ExpandedRepresentation] = []
        var opencase:[ExpandedRepresentation] = []
        var closed:[ExpandedRepresentation] = []
        var reportNrClosed:Int = 0
        var reportNrAssigned:Int = 0
        var reportNrOpen:Int = 0

        for xrin in inData {
            var targetMonth:Int = Int(xrin.representation.MonthAssigned) ?? 0
            var targetYear:Int = Int(xrin.representation.YearAssigned) ?? 0
            if targetYear == filterYear && targetMonth == filterMonth {
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
        
        return (assigned, opencase, closed, reportNrClosed, reportNrAssigned, reportNrOpen)
    }
}

//#Preview {
//    MonthlyReportView()
//}
