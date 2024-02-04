//
//  DocketView.swift
//  npmb
//
//  Created by Morris Albers on 11/20/23.
//

import SwiftUI

struct DocketView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var CVModel:CommonViewModel
    var docketDate:String
    
    struct workAppr {
        var appr:AppearanceModel = AppearanceModel()
        var cause:CauseModel = CauseModel()
        var client:ClientModel = ClientModel()
        var representation:RepresentationModel = RepresentationModel()
        
        var sortSequence:String {
            var work:String = ""
            work += FormattingService.rjf(base: self.appr.appearDate, len: 10, zeroFill: false)
            work += FormattingService.rjf(base: self.appr.appearTime, len: 4, zeroFill: false)
            work += " "
            work += self.client.formattedName
            return work
        }
        
        var printLine:[String] {
//            var workRepr:RepresentationModel = CVModel.findRepresentation(internalID: 1)
            var lines:[String] = []
            var line:String = ""
            line = "-"
            line += FormattingService.rjf(base: String(self.appr.internalID), len: 4, zeroFill: true)
            line += " "
            line += FormattingService.rjf(base: self.appr.appearDate, len: 10, zeroFill: false)
            line += " "
            line += FormattingService.rjf(base: self.appr.appearTime, len: 4, zeroFill: false)
            line += " "
            line += FormattingService.ljf(base: self.cause.causeNo, len: 9)
            line += " "
            line += FormattingService.ljf(base: self.representation.primaryCategory, len: 6)
            line += " "
            line += FormattingService.ljf(base: self.cause.originalCharge, len: 12)
            line += " "
            line += self.client.jail == "Y" ? "*" : " "
            line += self.client.formattedName
            lines.append(line)
            return lines
        }
        
        init(appr: AppearanceModel, cause: CauseModel, client: ClientModel, representation: RepresentationModel) {
            self.appr = appr
            self.cause = cause
            self.client = client
            self.representation = representation
        }
    }
    
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                PDFViewer(pdfData: createReport())
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
        }
    }
        
    func createReport() -> Data {
        CVModel.pdfCreator.setNPMLines(reportLines: npmReport(npmTitle: "Docket for " + docketDate,
           npmNrPages: 0,
           npmWaterMark: UIImage(named: "AlbersMorrisLOGO copy") ?? UIImage(),
           npmTitleHeight: 0.0,
           npmTitleBottom: 0.0,
           npmRawLines: createTextFile(),
           npmPrettyLines: [],
           npmPrettyBlocks: [],
           npmPages: []))
       let report = CVModel.pdfCreator.createDocument()

       return report
    }
    
    func createTextFile() -> [String] {
//        let todaysDate:String = DateService.dateDate2String(inDate: Date())
        var docketEntries:[workAppr] = []
        var docketEntryLines:[String] = []
        for appearanceRecord in CVModel.appearances.filter({ $0.appearDate == docketDate } ) {
            var ar:workAppr = workAppr(appr: appearanceRecord, cause: CVModel.findCause(internalID: appearanceRecord.involvedCause), client: CVModel.findClient(internalID: appearanceRecord.involvedClient), representation: CVModel.findRepresentation(internalID: appearanceRecord.involvedRepresentation))
                docketEntries.append(ar)
        }
    
        docketEntries = docketEntries.sorted(by: { $0.sortSequence < $1.sortSequence } )
        
        var lastDate:String = ""
        var lastTime:String = ""

        for de in docketEntries {
            for ln in de.printLine {
                if de.appr.appearDate != lastDate || de.appr.appearTime != lastTime {
                    lastDate = de.appr.appearDate
                    lastTime = de.appr.appearTime
                    let subHeader:String = "*Appearances on " + lastDate + " " + lastTime
                    docketEntryLines.append(subHeader)
                }
                docketEntryLines.append(ln)
            }
        }

        let subHeader:String = "*Possible Appearances"
        docketEntryLines.append(subHeader)

        for cl in CVModel.clients
            .filter({$0.miscDocketDate == docketDate } )
            .sorted(by: { $0.formattedName < $1.formattedName} ) {
            var line:String = "-"
            line += cl.formattedName
            docketEntryLines.append(line)
        }

        return docketEntryLines
    }

}

//#Preview {
//    DocketView()
//}
