//
//  BackupNotes.swift
//  npmb
//
//  Created by Morris Albers on 5/18/24.
//

import SwiftUI

struct BackupNotes: View {
    @EnvironmentObject var CVModel:CommonViewModel
    @Environment(\.dismiss) var dismiss
    @State var backupDocument:String = ""

    var body: some View {
        VStack {
            VStack (alignment: .leading) {
                HStack {
                    Spacer()
                    ShareLink(item: backupDocument)
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
        backupDocument = "[\n"
        CVModel.convnotes = CVModel.notes
        for no in CVModel.convnotes {
            backupDocument = backupDocument + " {\n"
            backupDocument = backupDocument + "  \"internalID\": " + FormattingService.rjf(base: String(no.internalID), len: 4, zeroFill: false) + ",\n"
            backupDocument = backupDocument + "  \"noteDate\": " + "\"" + no.noteDate + "\",\n"
            backupDocument = backupDocument + "  \"noteTime\": " + "\"" + no.noteTime + "\",\n"
            backupDocument = backupDocument + "  \"noteNote\": " + "\"" + no.noteNote + "\",\n"
            backupDocument = backupDocument + "  \"noteCategory\": " + "\"" + no.noteCategory + "\",\n"
            backupDocument = backupDocument + "  \"practice\": " + FormattingService.rjf(base: "1", len: 4, zeroFill: false) + ",\n"
            backupDocument = backupDocument + "  \"cause\": " + FormattingService.rjf(base: String(no.involvedCause), len: 4, zeroFill: false) + ",\n"
            backupDocument = backupDocument + "  \"client\": " + FormattingService.rjf(base: String(no.involvedClient), len: 4, zeroFill: false) + ",\n"
            backupDocument = backupDocument + "  \"representation\": " + FormattingService.rjf(base: String(no.involvedRepresentation), len: 4, zeroFill: false) + ",\n"
            backupDocument = backupDocument + " },\n"
        }
        backupDocument = backupDocument + "]\n"
    }
}
/*
 var id: String?
- var internalID: Int
- var involvedClient: Int
- var involvedCause: Int
- var involvedRepresentation: Int
- var noteDate: String
- var noteTime: String
- var noteNote: String
 var noteCategory: String

 */
//#Preview {
//    BackupNotes()
//}
