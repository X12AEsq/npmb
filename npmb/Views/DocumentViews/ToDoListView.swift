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
    @State var todoLines:String = ""
    @State var todaysDate:String = ""
    
    struct workNote {
        var note:NotesModel = NotesModel()
        var cause:CauseModel = CauseModel()
        var client:ClientModel = ClientModel()
        
        var printLine:String {
            var line:String = ""
            line = FormattingService.rjf(base: String(self.note.internalID), len: 4, zeroFill: true)
            line += " "
            line += FormattingService.rjf(base: self.note.noteDate, len: 10, zeroFill: false)
            line += " "
            line += FormattingService.ljf(base: self.cause.causeNo, len: 9)
            line += " "
            line += FormattingService.ljf(base: self.cause.originalCharge, len: 12)
            line += " "
            line += self.client.formattedName
            line += " "
            line += self.note.noteNote
           return line
        }

    }
    
    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                ForEach(ToDos, id: \.note.id) { docketEntry in
                    Text(docketEntry.printLine).font(.system(.body, design: .monospaced))
                }
                HStack {
                    Spacer()
                    Button("Print?") {
                        createTextFile()
                    }
                    .buttonStyle(CustomNarrowButton())
                    .padding()
                    if todoLines != "" {
                        Spacer()
                        ShareLink(item: todoLines)
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
        ToDos = []
        todoLines = ""
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

    
    func createTextFile() {
        todoLines = "Morris E. Albers II, PLLC Docket for " + todaysDate + "\n\n"
        for xa in ToDos {
            todoLines += xa.printLine + "\n"
        }
        
    }

}

//#Preview {
//    ToDoListView()
//}
