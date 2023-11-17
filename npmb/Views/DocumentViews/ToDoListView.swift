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
    @State var ToDos:[workNote] = []
    @State var extras:[ClientModel] = []
//    @State var todoLines:String = ""
    @State var todaysDate:String = ""
    @State var presentingModal = false
    @State var pdfData = Data()


    struct workNote {
        var note:NotesModel = NotesModel()
        var cause:CauseModel = CauseModel()
        var client:ClientModel = ClientModel()
        
        var printLine:[String] {
            var line:String = ""
            var lines:[String] = []
            line = FormattingService.rjf(base: String(self.note.internalID), len: 4, zeroFill: true)
            line += " "
            line += FormattingService.rjf(base: self.note.noteDate, len: 10, zeroFill: false)
            line += " "
            line += FormattingService.ljf(base: self.cause.causeNo, len: 9)
            line += " "
            line += FormattingService.ljf(base: self.cause.originalCharge, len: 12)
            line += " "
            line += self.client.formattedName
            lines.append(line)
            line = FormattingService.spaces(len: 10)
            line += self.note.noteNote
            lines.append(line)
            return lines
        }

    }
    
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                ForEach(ToDos, id: \.note.id) { docketEntry in
                    Text(docketEntry.printLine[0]).font(.system(.body, design: .monospaced))
                }
                HStack {
                    Spacer()
                    Button("Print?") {
//                        let title:String = "To Do List for " + Date.now.formatted(date: .long, time: .shortened)
//                        let body:String = "body"
//                        let pdfCreator = PDFCreator(title: title, body: body)
//                        pdfData = pdfCreator.createDocument()
                        createReport()
                        print("what have I done?")
                        self.presentingModal = true
//                        createTextFile()
                    }
                    .sheet(isPresented: $presentingModal) { PDFViewer(presentedAsModal: self.$presentingModal, pdfData: pdfData) }
                    .buttonStyle(CustomNarrowButton())
                    .padding()
/*
                    if todoLines != "" {
                        Spacer()
                        ShareLink(item: todoLines)
                    }
                    Spacer()
*/
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
        ToDos = []
//        todoLines = ""
        todaysDate = DateService.dateDate2String(inDate: Date())
        for noteRecord in CVModel.notes.filter({ $0.noteCategory == "TODO"} ) {
            if noteRecord.noteDate <= todaysDate {
                var xa = workNote()
                xa.note = noteRecord
                xa.cause = CVModel.findCause(internalID: noteRecord.involvedCause)
                xa.client = CVModel.findClient(internalID: noteRecord.involvedClient)
//                xa.representation = CVModel.findRepresentation(internalID: appr.involvedRepresentation)
                ToDos.append(xa)
            }
        }
        ToDos = ToDos.sorted(by: { $0.note.noteDate < $1.note.noteDate} )
    }

    func createReport() {
        let title:String = "To Do List for " + Date.now.formatted(date: .long, time: .shortened)
        let body:[String] = createTextFile()
        let pdfCreator = PDFCreator(title: title, body: body)
        pdfData = pdfCreator.createDocument()
    }
    
    func createTextFile() -> [String] {
//        todoLines = "Morris E. Albers II, PLLC Docket for " + todaysDate + "\n\n"
        var todoLines:[String] = []
        for xa in ToDos {
            for ln in xa.printLine {
                if todoLines.count == 0 {
                    todoLines.append("-" + ln)
                } else {
                    todoLines.append("+" + ln)
                }
            }
        }
        return todoLines
    }

}

//#Preview {
//    ToDoListView()
//}
