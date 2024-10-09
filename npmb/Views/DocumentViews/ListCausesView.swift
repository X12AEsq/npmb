//
//  ListCausesView.swift
//  npmb
//
//  Created by Morris Albers on 4/30/24.
//

import SwiftUI
//import SwiftData

@available(iOS 17, *)
struct ListCausesView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var CVModel:CommonViewModel
//    @Environment(\.modelContext) var modelContext
//    @Query var sdcauses: [SDCause]
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
        CVModel.txtCreator.setNPMLines(reportLines: npmReport(npmTitle: "Cause List on " + Date.now.formatted(date: .long, time: .shortened),
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
        
//        print(sdcauses.count)
//        for cau in CVModel.causes.sorted(by: { $0.internalID < $1.internalID } ) {
//            var lineMsg:String = ""
//            let cauCount:Int = sdcauses.filter({ $0.internalID == cau.internalID }).count
//            switch cauCount {
//            case 0:
//                lineMsg = "no match"
//                var newSDCause:SDCause = SDCause(internalID: cau.internalID, causeNo: cau.causeNo, causeType: cau.causeType, involvedClient: cau.involvedClient, involvedRepresentations: cau.involvedRepresentations, level: cau.level, court: cau.court, originalCharge: cau.originalCharge, practice: prodPractice[0])
//                modelContext.insert(newSDCause)
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
//            print(cau.internalID, lineMsg)
//            var printLine:String = FormattingService.rjf(base: String(cau.internalID), len: 4, zeroFill: false)
//            printLine = printLine + " " + FormattingService.ljf(base: cau.causeNo, len:9)
//            printLine = printLine + " " + FormattingService.ljf(base: cau.originalCharge, len:12)
//            printLine = printLine + " " + FormattingService.ljf(base: cau.causeType, len:8)
//            printLine = printLine + " " + FormattingService.ljf(base: cau.level, len:6)
//            printLine = printLine + " " + FormattingService.ljf(base: cau.court, len:6)
//            printLine = printLine + " " + FormattingService.rjf(base: String(cau.involvedClient), len: 4, zeroFill: false)
//            report.append(printLine)
//        }

        return report
    }

}

//#Preview {
//    ListCausesView()
//}
