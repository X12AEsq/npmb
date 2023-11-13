//
//  EditRepInpNote.swift
//  npmb
//
//  Created by Morris Albers on 4/9/23.
//

import SwiftUI

struct EditRepInputNote: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var CVModel:CommonViewModel
    @Binding var xr:ExpandedRepresentation
    @Binding var dateNote:Date
    @Binding var noteDocumentID:String
    @Binding var noteDate:String
    @Binding var noteTime:String
    @Binding var noteCategory:String
    @Binding var noteNote:String
    @Binding var noteChanged:Bool
    @Binding var noteInternal:Int
//    @Binding var noteClient:Int
//    @Binding var noteCause:Int
//    @Binding var noteRepresentation:Int
    @State var xdateNote:Date = Date()
    @State var xnoteDate:String = ""
    @State var xnoteTime:String = ""
    @State var xnoteCategory:String = ""
    @State var xnoteNote:String = ""
    @State var xnoteChanged:Bool = false
    @State var callResult:FunctionReturn = FunctionReturn()
    @State var statusMessage:String = ""
    
    var nc:NoteCats = NoteCats()

    
     var body: some View {
        VStack (alignment: .leading) {
            if statusMessage != "" {
                Text(statusMessage)
            }
            HStack {
                Text("Note Date")
                DatePicker("", selection: $dateNote).padding().onChange(of: dateNote, perform: { value in
                        noteDate = DateService.dateDate2String(inDate: value)
                        noteTime = DateService.dateTime2String(inDate: value)
                    }
                )
                Spacer()
            }
            HStack {
                Text("Note Category")
                Picker("Category", selection: $xnoteCategory) {
                    ForEach(nc.NoteCats, id: \.self) {
                        Text($0).onChange(of: xnoteCategory, perform: { value in
                            xnoteCategory = value
                            noteCategory = xnoteCategory
                        })
                    }
                }
                Spacer()
            }
            TextField(text: $noteNote, prompt: Text("note")) {
                Text(noteNote)
            }
            Spacer()
            HStack {
                if noteChange() {
                    Button {
                        Task {
                            if noteDocumentID == "" {
                                await callResult = CVModel.addNote(client: xr.xpcause.client.internalID, cause: xr.xpcause.cause.internalID, representation: xr.representation.internalID, notedate: noteDate, notetime: noteTime, notenote: noteNote, notecategory: noteCategory)
                                if callResult.status == .successful {
                                    statusMessage = ""
                                    resetNoteWorkArea()
                                    dismiss()
                                } else {
                                    statusMessage = callResult.message
                                    CVModel.logItem(viewModel: "EditRepInpNote-add", item: callResult.message)
                                }
                            } else {
                                await callResult = CVModel.updateNote(noteID:noteDocumentID, intID: noteInternal, client: xr.xpcause.client.internalID, cause: xr.xpcause.cause.internalID, representation: xr.representation.internalID, notedate: noteDate, notetime: noteTime, notenote: noteNote, notecategory: noteCategory)
                                if callResult.status == .successful {
                                    statusMessage = ""
                                    noteChanged = true
//                                    resetNoteWorkArea()
                                    dismiss()
                                } else {
                                    statusMessage = callResult.message
                                    CVModel.logItem(viewModel: "EditRepInpNote-update", item: callResult.message)
                                }

                            }
                        }
                    } label: {
                        Text("Save")
                    }
                    .buttonStyle(CustomButton())
                    Button {
                        dateNote = xdateNote
                        noteDate = xnoteDate
                        noteTime = xnoteTime
                        noteCategory = xnoteCategory
                        noteNote = xnoteNote
                        noteChanged = false
                    } label: {
                        Text("Quit (no save)")
                    }
                    .buttonStyle(CustomButton())
                }
                Button("Press to dismiss") {
                    dismiss()
                }
                .font(.title)
                .padding()
                .background(.black)
            }
        }
        .padding(.leading, 10.0)
        .onAppear {
            resetNoteWorkArea()
        }
    }
    
    func noteChange() -> Bool {
        if xnoteDate != noteDate { return true }
        if xnoteTime != noteTime { return true }
        if xnoteNote != noteNote { return true }
        if xnoteCategory != noteCategory { return true }
        return false
    }
    
    func resetNoteWorkArea() {
        xdateNote = dateNote
        xnoteDate = noteDate
        xnoteTime = noteTime
        xnoteNote = noteNote
        xnoteCategory = noteCategory
        xnoteChanged = false
    }
}

//struct EditRepInputNote_Previews: PreviewProvider {
//    static var previews: some View {
//        EditRepInputNote()
//    }
//}

