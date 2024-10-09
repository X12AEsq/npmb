//
//  DocumentComingAttractions.swift
//  npmb
//
//  Created by Morris Albers on 4/18/24.
//

import SwiftUI

struct DocumentComingAttractions: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var CVModel:CommonViewModel
//    @State var opencase:[ExpandedAppearance] = []
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
        }.onAppear( perform: { initWorkArea() } )
    }
    
    func initWorkArea() {
    }

    func createReport() -> Data {
         CVModel.pdfCreator.setNPMLines(reportLines: npmReport(npmTitle: "Coming Attractions on " + Date.now.formatted(date: .long, time: .shortened),
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
        var ToDos:[ExpandedAppearance] = []
        var todoLines:[String] = []
        var prevDate:String = ""
        for apprRecord in CVModel.appearances {
            if apprRecord.internalDate > Date() {
                ToDos.append(CVModel.expandAppearance(am: apprRecord))
            }
        }
//        ToDos = ToDos.sorted(by: { $0.appearance.internalDate < $1.appearance.internalDate } )
        ToDos = ToDos.sorted(by: { ($0.appearance.internalDate, $0.client.formattedName) < ($1.appearance.internalDate, $1.client.formattedName) } )
        
        for xa in ToDos {
            if prevDate != "" && prevDate != xa.appearance.appearDate {
                todoLines.append(" ")
            }
            todoLines.append(xa.printLine)
            prevDate = xa.appearance.appearDate
        }
        return todoLines
    }

}

//#Preview {
//    DocumentComingAttractions()
//}
