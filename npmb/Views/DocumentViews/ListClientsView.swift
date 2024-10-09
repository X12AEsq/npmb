//
//  ListClientsView.swift
//  npmb
//
//  Created by Morris Albers on 4/28/24.
//

import SwiftUI
//import SwiftData

@available(iOS 17, *)
struct ListClientsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var CVModel:CommonViewModel
//    @Environment(\.modelContext) var modelContext
//    @Query var sdclients: [SDClient]
//    @Query(filter: #Predicate<SDPractice> { prac in
//        !(prac.testing ?? true) }) var prodPractice: [SDPractice]

    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                TXTViewer(textData: createReport().npmLinearEquivalent)
                    .font(.system(.body, design: .monospaced))
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
        CVModel.txtCreator.setNPMLines(reportLines: npmReport(npmTitle: "Client List on " + Date.now.formatted(date: .long, time: .shortened),
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
//        
//        print(sdclients.count)
//        for cli in CVModel.clients.sorted(by: { $0.internalID < $1.internalID } ) {
//            var lineMsg:String = ""
//            let cliCount:Int = sdclients.filter({ $0.internalID == cli.internalID }).count
//            switch cliCount {
//            case 0:
//                lineMsg = "no match"
//                var newSDClient:SDClient = SDClient(internalID: cli.internalID, lastName: cli.lastName, firstName: cli.firstName, middleName: cli.middleName, suffix: cli.suffix, addr1: cli.street, addr2: "", city: cli.city, state: cli.state, zip: cli.zip, phone: cli.phone, note: cli.note, miscDocketDate: DateService.dateString2Date(inDate: cli.miscDocketDate), representations: [])
//                newSDClient.practice = prodPractice[0]
//                modelContext.insert(newSDClient)
//                do {
//                    try modelContext.save()
//                } catch {
//                    print("error: \(error.localizedDescription)")
//                }
//                break
//            case 1:
//                lineMsg = "match"
//                break
//            default:
//                lineMsg = "duplicates"
//            }
//            let printernalID:String = FormattingService.rjf(base: String(cli.internalID), len: 4, zeroFill: false)
//            let prName:String = FormattingService.ljf(base: cli.formattedName, len: 40)
//            let prAddr:String = FormattingService.ljf(base: cli.formattedAddr, len: 40)
//            var printLine:String = printernalID + " " + prName + prAddr + lineMsg
//            report.append(printLine)
//        }
//
        return report
    }
    
//    func getMonth(inDate:String) -> (yearString:String, monthNumber:Int, monthName:String) {
//        var rptYear:String = "XXXX"
//        var rptMonth:Int = 99
//        var rptName:String = "XXXX"
//        let array = inDate.components(separatedBy: "-")
//        if array.count > 0 { rptYear = array[0] }
//        if array.count > 1 {
//            rptMonth = Int(array[1]) ?? 99
//            rptName = DateService.monthName(numMonth: Int(array[1]) ?? 99)
//        }
//        return(rptYear, rptMonth, rptName)
//    }
    
//    func getStats(inMonth:Int, inYear:String, inData:[ExpandedRepresentation]) -> ( assigned:[ExpandedRepresentation], opencase:[ExpandedRepresentation], closed:[ExpandedRepresentation], reportNrClosed:Int, reportNrAssigned:Int, reportNrOpen:Int) {
//        let filterMonth:Int = inMonth
//        let filterYear:Int = Int(inYear) ?? 9999
//        var assigned:[ExpandedRepresentation] = []
//        var opencase:[ExpandedRepresentation] = []
//        var closed:[ExpandedRepresentation] = []
//        var reportNrClosed:Int = 0
//        var reportNrAssigned:Int = 0
//        var reportNrOpen:Int = 0
//
//        for xrin in inData {
//            var targetMonth:Int = Int(xrin.representation.MonthAssigned) ?? 0
//            var targetYear:Int = Int(xrin.representation.YearAssigned) ?? 0
//            if targetYear == filterYear && targetMonth == filterMonth {
//                assigned.append(xrin)
//                reportNrAssigned += 1
//            }
//            if xrin.xpcause.cause.level != "CPS"
//                && xrin.xpcause.cause.level != "GS"
//                && xrin.xpcause.cause.causeType != "Priv"{
//                if xrin.representation.active {
//                    opencase.append(xrin)
//                    reportNrOpen += 1
//                } else {
//                    targetYear = Int(xrin.representation.YearDisposed) ?? 0
//                    targetMonth = Int(xrin.representation.MonthDisposed) ?? 0
//                    if targetYear == filterYear && targetMonth == filterMonth {
//                        reportNrClosed += 1
//                        closed.append(xrin)
//                    }
//                }
//            }
//        }
//        print("assembled")
//        closed = closed.sorted(by: { $0.sortSequence1 < $1.sortSequence1} )
//        assigned = assigned.sorted(by: { $0.sortSequence1 < $1.sortSequence1} )
//        opencase = opencase.sorted(by: { $0.sortSequence1 < $1.sortSequence1} )
//        
//        return (assigned, opencase, closed, reportNrClosed, reportNrAssigned, reportNrOpen)
//    }

}

//#Preview {
//    ListClientsView()
//}
