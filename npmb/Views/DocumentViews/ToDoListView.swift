//
//  ToDoListView.swift
//  npmb
//
//  Created by Morris Albers on 11/13/23.
//

import SwiftUI

struct ToDoListView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var CVModel:CommonViewModel

    struct workNote {
        var note:NotesModel = NotesModel()
        var cause:CauseModel = CauseModel()
        var client:ClientModel = ClientModel()
        
        var printLine:[String] {
            var line:String = ""
            var lines:[String] = []
            line = "-"
            line += FormattingService.rjf(base: String(self.note.internalID), len: 4, zeroFill: true)
            line += " "
            line += FormattingService.rjf(base: self.note.noteDate, len: 10, zeroFill: false)
            line += " "
            line += FormattingService.ljf(base: self.cause.causeNo, len: 9)
            line += " "
            line += FormattingService.ljf(base: self.cause.originalCharge, len: 12)
            line += " "
            line += self.client.formattedName
            lines.append(line)
            line = "+"
            line += FormattingService.spaces(len: 10)
            line += self.note.noteNote
            lines.append(line)
            return lines
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
        }.onAppear( perform: { initWorkArea() } )
    }
    
    func initWorkArea() {
    }

    func createReport() -> Data {
         CVModel.pdfCreator.setNPMLines(reportLines: npmReport(npmTitle: "To Do List for " + Date.now.formatted(date: .long, time: .shortened),
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
        let todaysDate:String = DateService.dateDate2String(inDate: Date())
        var ToDos:[workNote] = []
        var todoLines:[String] = []
        for noteRecord in CVModel.notes.filter({ $0.noteCategory == "TODO"} ) {
            if noteRecord.noteDate <= todaysDate {
                var xa = workNote()
                xa.note = noteRecord
                xa.cause = CVModel.findCause(internalID: noteRecord.involvedCause)
                xa.client = CVModel.findClient(internalID: noteRecord.involvedClient)
                ToDos.append(xa)
            }
        }
        ToDos = ToDos.sorted(by: { $0.note.noteDate < $1.note.noteDate} )

        for xa in ToDos {
            for ln in xa.printLine {
                todoLines.append(ln)
            }
        }
        return todoLines
    }

}

//#Preview {
//    ToDoListView()
//}
