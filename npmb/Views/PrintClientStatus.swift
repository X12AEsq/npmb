//
//  PrintClientStatus.swift
//  npmb
//
//  Created by Morris Albers on 5/7/23.
//

import SwiftUI

struct PrintClientStatus: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var CVModel:CommonViewModel
    
    @State var xcl:ClientModel

    @State var opencase:[ExpandedRepresentation] = []
    @State var reportNrOpen:Int = 0
    @State var report:String = ""
    @State var reportYear:String = ""
    @State var reportMonth:String = ""
    @State var reportMonthName:String = ""
    @State var reportDay:String = ""
    @State var header1Printed:Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack (alignment: .leading) {
                    HStack {
                        Text("Client:").font(.system(.body, design: .monospaced))
                        Text(String(xcl.internalID)).font(.system(.body, design: .monospaced))
                        Text(xcl.formattedName)
                        Spacer()
                    }
                    HStack {
                        Text("Address:").font(.system(.body, design: .monospaced))
                        Text(xcl.formattedAddr)
                        Spacer()
                    }
                }
                .padding(.bottom, 10.0)
                VStack (alignment: .leading) {
                    HStack {
                        Text("Representations:").font(.system(.body, design: .monospaced))
                        Spacer()
                    }
                }
                .padding(.bottom, 10.0)
                VStack (alignment: .leading) {
                    ForEach(opencase) { ocr in
                        HStack {
                            Text(ocr.representation.assignedDate).font(.system(.body, design: .monospaced))
                            Text(ocr.xpcause.cause.causeNo).font(.system(.body, design: .monospaced))
                            Text(ocr.xpcause.cause.originalCharge).font(.system(.body, design: .monospaced))
                            Text(ocr.xpcause.cause.level).font(.system(.body, design: .monospaced))
                            if ocr.representation.active {
                                Text("Active")
                            } else {
                                Text("Closed")
                                Text(ocr.representation.dispositionDate)
                                Text(ocr.representation.dispositionAction)
                                Text(ocr.representation.dispositionType)
                            }
                            Spacer()
                        }
                    }
                }
                .padding(.bottom, 10.0)
            } // End of scrollview
            
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
        .onAppear {
            initWorkArea()
        }
    }
    
    func initWorkArea() {
        report = ""
        reportNrOpen = 0
        header1Printed = false
        let array = DateService.dateDate2String(inDate:Date()).components(separatedBy: "-")
        if array.count > 0 { reportYear = array[0] } else { reportYear = "9999" }
        if array.count > 1 {
            reportMonth = array[1]
            reportMonthName = DateService.monthName(numMonth: Int(array[1]) ?? 99)
        } else {
            reportMonth = "99"
            reportMonthName = "XXXXX"
        }
        if array.count > 2 {
            reportDay = array[2]
        } else {
            reportDay = "99"
        }
        
        CVModel.assembleExpandedRepresentations()
        opencase = CVModel.expandedrepresentations.filter { $0.xpcause.client.internalID == xcl.internalID }
        opencase = opencase.sorted { $0.representation.assignedDate < $1.representation.assignedDate }
    }

    func createTextFile() {
        report = "Morris E. Albers II, PLLC\nClient Status for " + String(xcl.internalID) + ":" + xcl.formattedName
        report += "on " + reportDay + " " + reportMonthName + ", " + reportYear + "\n\n"
        report += "Address: " + xcl.formattedAddr + "\n\n"
        report += "Representations:\n\n"
        
        if opencase.count > 0 {
            for ocr in opencase {
                report += FormattingService.ljf(base: ocr.representation.assignedDate, len: 11)
                report += FormattingService.ljf(base: ocr.xpcause.cause.causeNo, len: 10)
                report += FormattingService.ljf(base: ocr.xpcause.cause.originalCharge, len: 16)
                report += FormattingService.ljf(base: ocr.xpcause.cause.level, len: 4)
                if ocr.representation.active {
                    report += FormattingService.ljf(base: "Active", len: 7)
                } else {
                    report += FormattingService.ljf(base: "Closed", len: 7)
                    report += FormattingService.ljf(base: ocr.representation.dispositionDate, len: 11)
                    report += FormattingService.ljf(base: ocr.representation.dispositionAction, len: 6)
                    report += FormattingService.ljf(base: ocr.representation.dispositionType, len: 6)
                }
                report += "\n"
            }
        }
    }
}

//struct PrintClientStatus_Previews: PreviewProvider {
//    static var previews: some View {
//        PrintClientStatus()
//    }
//}
