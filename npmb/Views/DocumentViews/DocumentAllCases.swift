//
//  DocumentAllCases.swift
//  npmb
//
//  Created by Morris Albers on 5/1/23.
//

import SwiftUI

struct DocumentAllCases: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var CVModel:CommonViewModel
    @State var opencase:[ExpandedRepresentation] = []
    @State var reportNrOpen:Int = 0
    @State var report:String = ""
    @State var reportYear:String = ""
    @State var reportMonth:String = ""
    @State var reportMonthName:String = ""
    @State var header1Printed:Bool = false
    var docketDate:String
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                HStack {
                    Text("Case List on:")
                    Text(reportMonthName + ",")
                    Text(reportYear)
                    Text("- Total active:")
                    Text(String(reportNrOpen))
                    Spacer()
                }
                VStack {
                    Text("Cases")
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
            opencase.append(xrin)
            if xrin.representation.active {
                reportNrOpen += 1
            }
        }
 
        opencase = opencase.sorted(by: { $0.sortSequence1 < $1.sortSequence1} )
    }
    
    func createTextFile() {
        report = "Morris E. Albers II, PLLC All Cases Report for " + reportMonthName + ", " + reportYear + "\n"
        report += "Total active:" + String(reportNrOpen) + "\n\n"

        var xa:[ExpandedRepresentation] = []
        var xb:[ExpandedRepresentation] = []
        xa = opencase.filter( { $0.representation.active } ).sorted {
            $0.representation.assignedDate < $1.representation.assignedDate }
        xb = opencase.filter( { !$0.representation.active } ).sorted {
            $0.representation.dispositionDate < $1.representation.dispositionDate }
        let xc = xa + xb
        for xr in xc {
            if !header1Printed {
                report += "\n"
                report += "Open Items\n"
                report += xr.headerLine
                header1Printed = true
            }
            report += xr.printLine + " "
            if xr.representation.active {
                report += "Open\n"
            } else {
                report += xr.representation.dispositionDate + "\n"
            }
        }
    }
}

//struct DocumentAllCases_Previews: PreviewProvider {
//    static var previews: some View {
//        DocumentAllCases()
//    }
//}
