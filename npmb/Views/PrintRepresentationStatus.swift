//
//  PrintRepresentationStatus.swift
//  npmb
//
//  Created by Morris Albers on 5/2/23.
//

import SwiftUI

struct PrintRepresentationStatus: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var CVModel:CommonViewModel
    
    @State var xr:ExpandedRepresentation

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
                        Text("Representation:").font(.system(.body, design: .monospaced))
                        Text(String(xr.representation.internalID)).font(.system(.body, design: .monospaced))
                        Spacer()
                    }
                    HStack {
                        Text("Assigned: ").font(.system(.body, design: .monospaced))
                        Text(xr.representation.assignedDate).font(.system(.body, design: .monospaced))
                        Spacer()
                    }
                    HStack {
                        Text("Category: ").font(.system(.body, design: .monospaced))
                        Text(xr.representation.primaryCategory).font(.system(.body, design: .monospaced))
                        Spacer()
                    }
                    HStack {
                        Text("Active:").font(.system(.body, design: .monospaced))
                        Text((xr.representation.active) ? "yes" : "no").font(.system(.body, design: .monospaced))
                        Spacer()
                    }
                }
                VStack (alignment: .leading) {
                    if !xr.representation.active {
                        HStack {
                            Text("Competed:").font(.system(.body, design: .monospaced))
                            Text(xr.representation.dispositionDate).font(.system(.body, design: .monospaced))
                            Text(" ").font(.system(.body, design: .monospaced))
                            Text(xr.representation.dispositionType).font(.system(.body, design: .monospaced))
                            Text(" ").font(.system(.body, design: .monospaced))
                            Text(xr.representation.dispositionAction).font(.system(.body, design: .monospaced))
                            Spacer()
                        }
                    }
                    HStack {
                        Text("Cause:").font(.system(.body, design: .monospaced))
                        Text(String(xr.xpcause.cause.internalID)).font(.system(.body, design: .monospaced))
                        Text(" ").font(.system(.body, design: .monospaced))
                        Text(xr.xpcause.cause.causeNo).font(.system(.body, design: .monospaced))
                        Text(" ").font(.system(.body, design: .monospaced))
                        Text(xr.xpcause.cause.originalCharge).font(.system(.body, design: .monospaced))
                        Spacer()
                    }
                    HStack {
                        Text("Client:").font(.system(.body, design: .monospaced))
                        Text(String(xr.xpcause.client.internalID)).font(.system(.body, design: .monospaced))
                        Text(" ").font(.system(.body, design: .monospaced))
                        Text(xr.xpcause.client.formattedName).font(.system(.body, design: .monospaced))
                        Spacer()
                    }
                }
                .padding(.bottom, 20.0)
                VStack (alignment: .leading) {
                    ForEach(xr.appearances, id: \.id) { appearance in
                        HStack {
                            Text(appearance.stringLabel).font(.system(.body, design: .monospaced))
                            Spacer()
                        }
                    }
                }
                .padding(.bottom, 5.0)
                VStack (alignment: .leading) {
                    ForEach(xr.notes, id: \.id) { note in
                        HStack {
                            Text(note.stringLabel).font(.system(.body, design: .monospaced))
                            Spacer()
                        }
                    }
                }
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
        .padding(.leading, 10.0)
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
    }

    func createTextFile() {
        report = "Morris E. Albers II, PLLC\nClient Status for " + xr.xpcause.client.formattedName
        report += "on " + reportDay + " " + reportMonthName + ", " + reportYear + "\n\n"
        report += xr.printLine + "\n"
        report += "Assigned:" + xr.representation.assignedDate + "; "
        report += "Closed:" + xr.representation.dispositionDate
        report += "\n\nAppearances:\n"
        for appearance in xr.appearances {
            report += appearance.stringLabel + "\n"
        }
        report += "\nNotes:\n"
        for note in xr.notes {
            report += note.stringLabel + "\n"
        }
    }
}

//struct PrintRepresentationStatus_Previews: PreviewProvider {
//    static var previews: some View {
//        PrintRepresentationStatus()
//    }
//}
