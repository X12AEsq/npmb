//
//  EditRepresentationView.swift
//  npmb
//
//  Created by Morris Albers on 3/9/23.
//

import SwiftUI

struct EditRepresentationView: View {
    @EnvironmentObject var CVModel:CommonViewModel
    @Environment(\.dismiss) var dismiss
    
    var rxid:Int
    @State var workingid:Int = 0
//    @State var wrx:RepresentationExpansion = RepresentationExpansion()

    @State var statusMessage:String = ""
    @State var saveMessage:String = ""
    @State var rep:RepresentationModel = RepresentationModel()
    @State var cau:CauseModel = CauseModel()
    @State var cli:ClientModel = ClientModel()
    @State var selectedCause:CauseModel = CauseModel()
    
    var pc:PrimaryCategory = PrimaryCategory()
    var dto:DispositionTypeOptions = DispositionTypeOptions()
    var dao:DispositionActionOptions = DispositionActionOptions()
    var activeOptions = ["Yes", "No"]

    @State var repDocumentID:String = ""
    @State var repInternalID:Int = 0
    @State var repAssigned:String = ""
    @State var repDateAssigned:Date = Date()
    @State var repCategory:String = ""
    @State var repActive:Bool = true
    @State var repActiveString:String = ""
    @State var repDispDate:String = ""
    @State var repDateDisp:Date = Date()
    @State var repDispType:String = ""
    @State var repDispAction:String = ""
    @State var repApprs:[AppearanceModel] = []
    @State var repNotes:[NotesModel] = []
    @State var repCause:Int = 0
    @State var repClient:Int = 0
    @State var repAdding:Bool = false
//    @State var repChanged:Bool = false
    
    @State var cauInternalID = 0
    @State var cauCauseNo = ""
    @State var cauOrigCharge = ""
    
    @State var cliInternalID:Int = 0
    @State var cliName:String = ""
    
    @State var dateAppr:Date = Date()
    @State var apprDocumentID:String = ""
    @State var apprDate:String = ""
    @State var apprTime:String = ""
    @State var apprNote:String = ""
    @State var apprCategory:String = ""
    @State var apprInternal:Int = 0
//    @State var apprArray:[AppearanceModel] = []
    
    @State var dateNote:Date = Date()
    @State var noteDate:String = ""
    @State var noteTime:String = ""
    @State var noteNote:String = ""
    @State var noteCategory:String = "NOTE"
    @State var noteInternal:Int = 0

    @State var startingFilter:String = ""
    @State var activeScreen = NextAction.maininput
    @State private var orientation = UIDeviceOrientation.portrait
    @State var callResult:FunctionReturn = FunctionReturn()
    @State var adding:Bool = false
    
    enum NextAction {
        case maininput
        case editappearance
        case editnote
        case selectcause
    }
    
    var NoteCatOptions = ["TODO", "NOTE", "DONE"]
    
// TODO: write appearance and note logic
    var body: some View {
        GeometryReader { geo in
            VStack (alignment: .leading) {
                VStack (alignment: .leading) {
// start of screen header
                    Text("Representation").font(.title)
                        .padding([.leading, .bottom, .trailing])
                    if statusMessage != "" {
                        Text(statusMessage)
                            .font(.body)
                            .foregroundColor(Color.red)
                            .multilineTextAlignment(.leading)
                            .padding([.leading, .bottom, .trailing])
                         }
                    mainsummary
                        .frame(width: geo.size.width * 0.99)
// bottom of screen header
                    HStack {            // left and right sides of the rest
// start of left hand side
                        VStack {
                            VStack {
                                detail
                                Spacer()
                                HStack {
                                    if activeScreen != .editappearance && activeScreen != .editnote {
                                        Button {
                                            activeScreen = .maininput
                                        } label: {
                                            Text("Main")
                                        }
                                        .buttonStyle(CustomButton())
                                        Button {
                                            activeScreen = .selectcause
                                        } label: {
                                            Text("Cause")
                                        }
                                        .buttonStyle(CustomButton())
                                        if !repChanged() {
                                            Button {
                                                activeScreen = .editappearance
                                            } label: {
                                                Text("Appear")
                                            }
                                            .buttonStyle(CustomButton())
                                            Button {
                                                activeScreen = .editnote
                                            } label: {
                                                Text("Note")
                                            }
                                            .buttonStyle(CustomButton())
                                        }
                                    }
                                }

                                HStack {
                                    if activeScreen != .editappearance && activeScreen != .editnote {
                                        Button {
                                            if auditRepresentation() {
                                                Task {
                                                    await callResult = CVModel.updateRepresentation(representationID: rep.id!, involvedClient: repClient, involvedCause: repCause, active: repActive, assignedDate: repAssigned, dispositionDate: repDispDate, dispositionType: repDispType, dispositionAction: repDispAction, primaryCategory: repCategory, intid: repInternalID)
                                                    if callResult.status == .successful {
                                                        statusMessage = ""
                                                        prepWorkArea(repid: workingid)
                                                    } else {
                                                        statusMessage = callResult.message
                                                    }
                                                }
                                            }
                                        } label: {
                                            Text(saveMessage)
                                        }
                                        .buttonStyle(CustomButton())
                                        if repChanged() {
                                            Button {
                                                prepWorkArea(repid: workingid)
                                            } label: {
                                                Text("Quit")
                                            }
                                            .buttonStyle(CustomButton())
                                        }
                                        if saveMessage == "Update" {
                                            Button("Delete", role: .destructive) {
                                                print("Select Delete")
                                            }
                                            .font(.headline.bold())
                                            .frame(maxWidth: .infinity, maxHeight: 45)
                                            .background(.gray.opacity(0.3), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                                        }
                                    }
                                }
                            }
                            .padding()
                            .border(.indigo, width: 4)
                        }
                        .padding()
                        .frame(width: geo.size.width * 0.495)
                        .border(.yellow, width: 4)
// End of left hand side, start of right hand side
                        ZStack {
                            VStack {
                                if activeScreen == .maininput {
                                    inputmain
                                        .padding()
                                        .border(.indigo, width: 4)
                                } else {
                                    if activeScreen == .editnote {
                                        VStack {
                                            inputNote
                                                .padding()
                                                .border(.indigo, width: 4)
                                        }
                                    } else {
                                        if activeScreen == .editappearance {
                                            VStack {
                                                inputAppr
                                                    .padding()
                                                    .border(.indigo, width: 4)
                                            }
                                        } else {
                                            if activeScreen == .selectcause {
                                                VStack {
                                                    if selectedCause.internalID != 0 {
                                                        Button { recordCauseSelection(cm:selectedCause) }
                                                        label: {
                                                        if adding { Text("add cause") }
                                                        else { Text("update cause") }
                                                    }
                                                    .buttonStyle(CustomButton())
                                                    } else {
                                                        SelectCauseUtil(selectedCause: $selectedCause, startingFilter: selectedCause.causeNo)
                                                    }
                                                }
                                                    .padding()
                                                    .border(.indigo, width: 4)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.all)
                        .frame(width: geo.size.width * 0.495)
                        .border(.yellow, width: 4)
// end of right hand side
                    }
                }
            }
        }
        .onAppear {
            workingid = rxid
            prepWorkArea(repid: workingid)
        }
        .onRotate { newOrientation in
            if newOrientation.isLandscape || newOrientation.isPortrait {
                if newOrientation != orientation {
                    orientation = newOrientation
                }
            }
//            if orientation.isPortrait {
//                print("Portrait")
//            } else if orientation.isLandscape {
//                print("Landscape")
//            } else if orientation.isFlat {
//                print("Flat")
//            } else {
//                print("Unknown")
//            }
        }
    }
/*
    mainsummary appears in the spash header across the top of the screen
*/
    var mainsummary: some View {
        HStack (alignment: .top){
            VStack (alignment: .leading) {
                HStack {
                    Text("Representation:")
                    Text(String(repInternalID))
                }
                HStack {
                    Text("Assigned: ")
                    Text(repAssigned)
                }
                HStack {
                    Text("Category: ")
                    Text(repCategory)
                }
            }
            Spacer()
            VStack (alignment: .leading) {
                HStack {
                    Text("Active:")
                    Text((repActive) ? "yes" : "no")
                }
            }
            Spacer()
            VStack (alignment: .leading) {
                if !repActive {
                    HStack {
                        Text("Competed:")
                        Text(repDispDate)
                        Text(" ")
                        Text(repDispType)
                        Text(" ")
                        Text(repDispAction)
                    }
                }
                HStack {
                    Text("Cause:")
                    Text(String(cauInternalID))
                    Text(" ")
                    Text(cauCauseNo)
                    Text(" ")
                    Text(cauOrigCharge)
                }
                HStack {
                    Text("Client:")
                    Text(String(cliInternalID))
                    Text(" ")
                    Text(cliName)
                }
            }
        }
        .padding(.all, 20.0)
        .border(.yellow, width: 4)
    }
/*
    detail is the left half of the bottom part of the screen; it can be a list of the appearances, a list of notes ... when it displays a list, if no member of the list has been selected, the right hand half of the screen will show a blank entry for for the list type; if a member has been selected, the right side will show an edit entry form pre-filled with the selected data
*/
    var detail: some View {
        ZStack {
            if activeScreen == .editappearance {
                VStack (alignment: .leading) {
                    Text("Appearances")
                    ScrollView {
                        Button {
                            apprInternal = 0
                            dateAppr = Date()
                            apprNote = ""
                            apprDocumentID = ""
                        } label: {
                            Text("Add Appearance")
                        }
                        .buttonStyle(CustomButton())
                        ForEach(repApprs) { appr in
                            HStack (alignment: .top) {
                                ActionEdit()
                                    .onTapGesture {
                                        dateAppr = DateService.dateString2Date(inDate: appr.appearDate, inTime: appr.appearTime)
                                        apprNote = appr.appearNote
                                        apprInternal = appr.internalID
                                        apprDocumentID = appr.id ?? ""
                                    }
                                Text(appr.appearDate)
                                Text(appr.appearTime)
                                Text(appr.appearNote)
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.all, 20.0)
                .border(.indigo, width: 4)
            } else {
                if activeScreen == .editnote {
                    VStack (alignment: .leading) {
                        Text("Notes")
                        ScrollView {
                            Button {
                                noteInternal = 0
                                dateNote = Date()
                                noteNote = ""
                                noteCategory = ""
                            } label: {
                                Text("Add Appearance")
                            }
                            .buttonStyle(CustomButton())
                            ForEach(repNotes) { note in
                                HStack (alignment: .top) {
                                    ActionEdit()
                                        .onTapGesture {
                                            dateNote = DateService.dateString2Date(inDate: note.noteDate, inTime: note.noteTime)
                                            noteNote = note.noteNote
                                            noteCategory = note.noteCategory
                                            noteInternal = note.internalID
                                        }
                                    Text(note.noteDate)
                                    Text(note.noteCategory)
                                    Text(note.noteNote)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(.all, 20.0)
                    .border(.indigo, width: 4)
                } else {
                    Text("No extended display selected")
                }
            }
        }
        .onAppear {
            prepWorkArea(repid: workingid)
        }
    }
/*
    inputmain is the data entry screen for the representation itself; it appears on the right hand side of the bottom when "main" has been selected for entry
 */
    var inputmain: some View {
        Form {
            Section(header: Text("Representation Data").background(Color.blue).foregroundColor(.white)) {
                DatePicker("Assigned", selection: $repDateAssigned, displayedComponents: [.date]).padding().onChange(of: repDateAssigned, perform: { value in
                    repAssigned = DateService.dateDate2String(inDate: repDateAssigned)
//                    repChanged = true
//                    wrx.representation.assignedDate = repAssigned
                })
                Picker("Category", selection: $repCategory) {
                    ForEach(pc.primaryCategories, id: \.self) {
                        Text($0).onChange(of: repCategory, perform: { value in
                            repCategory = value
//                            wrx.representation.primaryCategory = value
//                            repChanged = true
                        })
                    }
                }
                Picker("Active", selection: $repActiveString) {
                    ForEach(activeOptions, id: \.self) {
                        Text($0).onChange(of: repActiveString, perform: { value in
                            repActive = (value == "Yes")
//                            wrx.representation.active = repActive
//                            repChanged = true
                         })
                    }
                }
                if !repActive {
                    DatePicker(selection: $repDateDisp, displayedComponents: [.date], label: {Text("Disposed")}).padding()
                        .onChange(of: repDateDisp, perform: { value in
                            repDispDate = DateService.dateDate2String(inDate: value)
//                            wrx.representation.dispositionDate = repDispDate
//                            repChanged = true
                        })
                    
                    Picker(selection: $repDispType) {
                        ForEach(dto.dispositionTypeOptions , id: \.self) {
                            Text($0).onChange(of: repDispType, perform: { value in
//                                wrx.representation.dispositionType = value
//                                repChanged = true
                            })
                        }
                    } label: {
                        Text("Action")
                    }
                    Picker(selection: $repDispAction) {
                        ForEach(dao.dispositionActionOptions , id: \.self) {
                            Text($0).onChange(of: repDispAction, perform: { value in
//                                wrx.representation.dispositionAction = value
//                                repChanged = true
                            })
                        }
                    } label: {
                        Text("Action")
                    }
                }
            }
        }
    }
    
    var inputAppr: some View {
        VStack (alignment: .leading) {
            DatePicker("Appearance Date", selection: $dateAppr).padding().onChange(of: dateAppr, perform: { value in
                apprDate = DateService.dateDate2String(inDate: value)
                apprTime = DateService.dateTime2String(inDate: value)
            })
            TextField(text: $apprNote, prompt: Text("note")) {
                Text(apprNote)
            }.padding(.all, 20.0)
            Spacer()
            
            HStack {
                Button {
                    if auditAppearance() {
                        Task {
                            if apprInternal == 0 {
                                await callResult = CVModel.addAppearanceToRepresentation(representationID: repDocumentID, involvedClient: repClient, involvedCause: repCause, involvedRepresentation: repInternalID, appearDate: apprDate, appearTime: apprTime, appearNote: apprNote)
                            } else {
                                await callResult = CVModel.updateAppearance(appearanceID: apprDocumentID, intID: apprInternal, involvedClient: repClient, involvedCause: repCause, involvedRepresentation: repInternalID, appearDate: apprDate, appearTime: apprTime, appearNote: apprNote)
                            }
                            dateAppr = Date()
                            apprNote = ""
                            activeScreen = .maininput
                            if callResult.status == .successful {
                                statusMessage = ""
                                prepWorkArea(repid: workingid)
                                print("successful appearance add, prepWorkArea invoked")
                            } else {
                                statusMessage = callResult.message
                            }
                        }
                    }
                } label: {
                    Text("Save Appr")
                }
                .buttonStyle(CustomButton())
                Button {
                    dateAppr = Date()
                    apprNote = ""
                    activeScreen = .maininput
                } label: {
                    Text("Quit (no save)")
                }
                .buttonStyle(CustomButton())
            }
       }
    }
    
    var inputNote: some View {
        VStack (alignment: .leading) {
            DatePicker("Note Date", selection: $dateNote).padding().onChange(of: dateNote, perform: { value in
                noteDate = DateService.dateDate2String(inDate: value)
                noteTime = DateService.dateTime2String(inDate: value)
            })
            Picker("Category", selection: $noteCategory) {
                ForEach(NoteCatOptions, id: \.self) {
                    Text($0)
                }
            }

            TextField(text: $noteNote, prompt: Text("note")) {
                Text(noteNote)
            }.padding(.all, 20.0)
            Spacer()
            
            HStack {
                Button {
                    if auditNote() {
                        Task {
                            if noteInternal == 0 {
                                await callResult = CVModel.addNoteToRepresentation(representationID: repDocumentID, client: repClient, cause: repCause, representation: repInternalID, notedate: noteDate, notetime: noteTime, notenote: noteNote, notecategory: noteCategory)
                            } else {
                                // CVModel.updateNote ....
                            }
                            dateNote = Date()
                            noteNote = ""
                            noteCategory = "NOTE"
                            activeScreen = .maininput
                            if callResult.status == .successful {
                                statusMessage = ""
                                prepWorkArea(repid: workingid)
                            } else {
                                statusMessage = callResult.message
                            }
                        }
                    }
                } label: {
                    Text("Save Note")
                }
                .buttonStyle(CustomButton())
                Button {
                    dateNote = Date()
                    noteNote = ""
                    noteCategory = "NOTE"
                    activeScreen = .maininput
                } label: {
                    Text("Quit (no save)")
                }
                .buttonStyle(CustomButton())
            }
        }
        .onAppear {
            if noteDate == "" {
                noteDate = DateService.dateDate2String(inDate: dateNote)
                noteTime = DateService.dateTime2String(inDate: dateNote)
            }
        }
    }
    
    func auditRepresentation() -> Bool {
        statusMessage = ""
        if repCause == 0 { recordError(er:"invalid cause for representation") }
        if repClient == 0 { recordError(er:"invalid client for representation") }
        if statusMessage == "" { return true }
        return false
    }
    
    func auditAppearance() -> Bool {
        statusMessage = ""
        if repDocumentID == "" { recordError(er:"unknown document id for representation") }
        if repInternalID == 0 { recordError(er:"unknown internal id for representation") }
        if repCause == 0 { recordError(er:"invalid cause for representation") }
        if repClient == 0 { recordError(er:"invalid client for representation") }
        if apprDate == "" { recordError(er: "invalid appearance date")}
        if apprTime == "" { recordError(er: "invalid appearance time")}
        if statusMessage == "" { return true }
        return false
    }
    
    func auditNote() -> Bool {
        statusMessage = ""
        if repDocumentID == "" { recordError(er:"unknown document id for representation") }
        if repInternalID == 0 { recordError(er:"unknown internal id for representation") }
        if repCause == 0 { recordError(er:"invalid cause for representation") }
        if repClient == 0 { recordError(er:"invalid client for representation") }
        if noteDate == "" { recordError(er: "invalid note date")}
        if noteTime == "" { recordError(er: "invalid note time")}
        if statusMessage == "" { return true }
        return false
    }

    func recordError(er:String) {
        if statusMessage != "" { statusMessage = statusMessage + "\n" + er }
        else { statusMessage = er }
    }

    func recordCauseSelection(cm:CauseModel) -> Void {
        if rep.involvedCause != cm.internalID {
            
        }
//        wrx.cause = cm
//        wrx.client = CVModel.findClient(internalID:cm.involvedClient)
//        cauInternalID = cm.internalID
//        cauCauseNo = cm.causeNo
//        cauOrigCharge = cm.originalCharge
//        if wrx.client.internalID == cm.involvedClient {
//            cliInternalID = wrx.client.internalID
//            cliName = wrx.client.formattedName
//        }
    }
    
    func prepWorkArea(repid:Int) -> Void {
        if repid == 0 {
            rep = RepresentationModel()
            repApprs = []
            repNotes = []
        } else {
            rep = CVModel.findRepresentation(internalID:repid)
            repApprs = CVModel.assembleAppearances(repID: repid)
            repNotes = CVModel.assembleNotes(repID: repid)
            print("prepWorkArea counts", repApprs, repNotes)
        }
        
        if rep.involvedCause == 0 {
            cau = CauseModel()
        } else {
            cau = CVModel.findCause(internalID: rep.involvedCause)
        }
        
        if rep.involvedClient == 0 {
            cli = ClientModel()
        } else {
            cli = CVModel.findClient(internalID: rep.involvedClient)
        }
        repClient = rep.involvedClient
        repCause = rep.involvedCause
        repActive = rep.active
        repCategory = rep.primaryCategory
        repInternalID = rep.internalID
        repDocumentID = rep.id ?? ""
        repAssigned = rep.assignedDate
        repDateAssigned = DateService.dateString2Date(inDate: repAssigned)
        repActiveString = (rep.active) ? "Yes" : "No"
        repDispDate = rep.dispositionDate
        repDateDisp = DateService.dateString2Date(inDate: repDispDate)
        repDispType = rep.dispositionType
        repDispAction = rep.dispositionAction
        if rep.internalID != 0 {
            saveMessage = "Update"
            adding = false
//            repAppearances = rep.appearances
//            repNotes = rep.notes
            cauInternalID = cau.internalID
            cauCauseNo = cau.causeNo
            cauOrigCharge = cau.originalCharge
            cliInternalID = cli.internalID
            cliName = cli.formattedName
            startingFilter = cau.sortFormat1
            repAdding = false
//            repChanged = false
        } else {
            saveMessage = "Add"
            adding = true
//            wrx = RepresentationExpansion()
//            prepRepWorkArea(xrx: wrx)
//            repDateAssigned = Date()
//            repActive = true
//            repActiveString = "Yes"
//            repCategory = "ORIG"
//            repDateDisp = Date()
//            cauInternalID = 0
//            cauCauseNo = ""
//            cauOrigCharge = ""
//            cliInternalID = 0
//            cliName = ""
//            startingFilter = ""
            repAdding = true
//            repChanged = false
        }
    }
    
    func repChanged() -> Bool {
        if repClient != rep.involvedClient { return true }
        if repCause != rep.involvedCause { return true }
        if repActive != rep.active { return true }
        if repCategory != rep.primaryCategory { return true }
        if repInternalID != rep.internalID { return true }
        if repAssigned != rep.assignedDate { return true }
        if repDispDate != rep.dispositionDate { return true }
        if repDispType != rep.dispositionType { return true }
        if repDispAction != rep.dispositionAction { return true }
        return false
    }
    func recordAppearance(appr:AppearanceModel) async -> Void {
//        if wrx.representation.internalID == 0 {
//            wrx.representation = await CVModel.addRepresentation(involvedClient: wrx.representation.involvedClient, involvedCause: wrx.representation.involvedCause, active: wrx.representation.active, assignedDate: wrx.representation.assignedDate, dispositionDate: wrx.representation.dispositionDate, dispositionType: wrx.representation.dispositionType, dispositionAction: wrx.representation.dispositionAction, primaryCategory: wrx.representation.primaryCategory)
//        }
    }

}

//struct EditRepresentationView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditRepresentationView()
//    }
//}
