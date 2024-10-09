//
//  DocumentListRepresentations.swift
//  npmb
//
//  Created by Morris Albers on 5/21/24.
//

import SwiftUI

struct DocumentListRepresentations: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var CVModel:CommonViewModel
    @State var representationList:[RepresentationModel] = []
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
                    Text("Representations on:")
                    Text(reportMonthName + ",")
                    Text(reportYear)
                    Spacer()
                }
                VStack {
                    ForEach(representationList, id: \.self) { rep in
                        Text(rep.printLine1).font(.system(.body, design: .monospaced))
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
        representationList = CVModel.representations.sorted(by: { $0.internalID < $1.internalID } )
        report = ""
        reportNrOpen = 0
        header1Printed = false
        lineNr = 0
        rcdNr = 0
    }
    
    func createTextFile() {
        for rep in CVModel.representations.sorted(by: { $0.internalID < $1.internalID } ) {
            if rcdNr == 0 {
                report = "Morris E. Albers II, PLLC Representation List for " + reportMonthName + ", " + reportYear + "\n\n"
                report += rep.printHeader1 + "\n"
                lineNr = 3
            } else {
                if lineNr > 86 {
                    report += "\u{0c}"
                    report += "Morris E. Albers II, PLLC Representation List for " + reportMonthName + ", " + reportYear + "\n\n"
                    report += rep.printHeader1 + "\n"
                    lineNr = 3
                }
            }
            lineNr += rep.printLine1Count
            rcdNr += 1
            report += rep.printLine1
            report += "\n"
        }
//        report += "\u{0c}"
//        rcdNr = 0
//        for ca in CVModel.causes.sorted(by: { $0.causeNo < $1.causeNo } ) {
//            if rcdNr == 0 {
//                report += "Morris E. Albers II, PLLC Cause List for " + reportMonthName + ", " + reportYear + "\n\n"
//                report += rep.printHeader1 + "\n"
//                lineNr = 3
//            } else {
//                if lineNr > 86 {
//                    report += "\u{0c}"
//                    report += "Morris E. Albers II, PLLC Cause List for " + reportMonthName + ", " + reportYear + "\n\n"
//                    report += rep.printHeader1 + "\n"
//                    lineNr = 3
//                }
//            }
//            lineNr += 1
//            rcdNr += 1
//            report += rep.printLine1
//            report += "\n"
//        }
    }
}

//#Preview {
//    DocumentListRepresentations()
//}
