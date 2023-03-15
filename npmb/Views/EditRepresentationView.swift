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
    
    var rx:RepresentationExpansion?
    @State var wrx:RepresentationExpansion = RepresentationExpansion()

    @State var statusMessage:String = ""
    @State var saveMessage:String = ""
    @State var selectedCause:CauseModel = CauseModel()
    
    var pc:PrimaryCategory = PrimaryCategory()
    var dto:DispositionTypeOptions = DispositionTypeOptions()
    var dao:DispositionActionOptions = DispositionActionOptions()
    var activeOptions = ["Yes", "No"]

    @State var repInternalID:Int = 0
    @State var repAssigned:String = ""
    @State var repDateAssigned:Date = Date()
//    @State var repCategory:String = ""
//    @State var repActive:Bool = true
    @State var repActiveString:String = ""
    @State var repDispDate:String = ""
    @State var repDateDisp:Date = Date()
    @State var repDispType:String = ""
    @State var repDispAction:String = ""
    @State var repAppearances:[AppearanceModel] = []
    @State var repNotes:[NotesModel] = []
    
    @State var cauInternalID = 0
    @State var cauCauseNo = ""
    @State var cauOrigCharge = ""
    
    @State var cliInternalID:Int = 0
    @State var cliName:String = ""
    
    @State var dateAppr:Date = Date()
    @State var apprDate:String = ""
    @State var apprTime:String = ""
    @State var apprNote:String = ""
    @State var apprInternal:Int = 0
    
    @State var dateNote:Date = Date()
    @State var noteDate:String = ""
    @State var noteTime:String = ""
    @State var noteNote:String = ""
    @State var noteCategory:String = "NOTE"

    @State var startingFilter:String = ""
    @State var activeScreen = NextAction.maininput
    @State private var orientation = UIDeviceOrientation.portrait
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
                    Text("Representation").font(.title)             // Top of screen
                        .padding([.leading, .bottom, .trailing])    // Top of screen
                    if statusMessage != "" {                        // Top of screen
                        Text(statusMessage)                         // Top of screen
                            .font(.body)
                            .foregroundColor(Color.red)
                            .multilineTextAlignment(.leading)
                            .padding([.leading, .bottom, .trailing])
                         }
                    mainsummary                                     // Top of screen
                        .frame(width: geo.size.width * 0.99)

                    HStack {
                        VStack {                                        // left hand side
                            VStack {
                                detail
                                Spacer()
                                HStack {
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

                                HStack {
                                    Button {
                                        if auditRepresentation() {
                                            if saveMessage == "Update" {
                                                print("Select Update")
                                            } else {
                                                print("Select Save")
                                            }
                                        }
                                    } label: {
                                        Text(saveMessage)
                                    }
                                    .buttonStyle(CustomButton())
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
                            .padding()
                            .border(.indigo, width: 4)
                        }                                               // End of left hand side
                        .padding()
                        .frame(width: geo.size.width * 0.495)
                        .border(.yellow, width: 4)

                        ZStack {                                        // right hand side
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
                                                    }

                                                    SelectCauseUtil(selectedCause: $selectedCause, startingFilter: rx?.cause.causeNo)
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
                    }
                }

                
//                VStack {
//                }
            }
        }
        .onAppear {
            prepWorkArea()
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
                    Text(wrx.representation.primaryCategory)
                }
            }
            Spacer()
            VStack (alignment: .leading) {
                HStack {
                    Text("Active:")
                    Text((wrx.representation.active) ? "yes" : "no")
                }
            }
            Spacer()
            VStack (alignment: .leading) {
                if !wrx.representation.active {
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
    
    var detail: some View {
        ZStack {
            if activeScreen == .editappearance {
                VStack (alignment: .leading) {
                    Text("Appearances")
                    ScrollView {
                        ForEach(repAppearances) { appr in
                            HStack (alignment: .top) {
                                ActionEdit()
                                    .onTapGesture {
                                        dateAppr = DateService.dateString2Date(inDate: appr.appearDate, inTime: appr.appearTime)
                                        apprNote = appr.appearNote
                                        apprInternal = appr.internalID
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
                            ForEach(repNotes) { note in
                                HStack (alignment: .top) {
                                    ActionEdit()
                                        .onTapGesture {
                                            dateNote = DateService.dateString2Date(inDate: note.noteDate, inTime: note.noteTime)
                                            noteNote = note.noteNote
                                            noteCategory = note.noteCategory
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
    }

    var inputmain: some View {
        Form {
            Section(header: Text("Representation Data").background(Color.blue).foregroundColor(.white)) {
                DatePicker("Assigned", selection: $repDateAssigned, displayedComponents: [.date]).padding().onChange(of: repDateAssigned, perform: { value in
                    repAssigned = DateService.dateDate2String(inDate: repDateAssigned)
                })
                Picker("Category", selection: $wrx.representation.primaryCategory) {
                    ForEach(pc.primaryCategories, id: \.self) {
                        Text($0)
                    }
                }
                Picker("Active", selection: $repActiveString) {
                    ForEach(activeOptions, id: \.self) {
                        Text($0).onChange(of: repActiveString, perform: { value in
                            wrx.representation.active = (value == "Yes")
                         })
                    }
                }
                if !wrx.representation.active {
                    DatePicker(selection: $repDateDisp, displayedComponents: [.date], label: {Text("Disposed")}).padding().onChange(of: repDateDisp, perform: { value in
                        repDispDate = DateService.dateDate2String(inDate: value)
                    })
                    Picker(selection: $repDispType) {
                        ForEach(dto.dispositionTypeOptions , id: \.self) {
                            Text($0)
                        }
                    } label: {
                        Text("Action")
                    }
                    Picker(selection: $repDispAction) {
                        ForEach(dao.dispositionActionOptions , id: \.self) {
                            Text($0)
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
            Button {
                if apprInternal == 0 {
                    dateAppr = Date()
                    apprNote = ""
                }
            } label: {
                if apprInternal == 0 { Text("Add Appearance") }
                else { Text("Edit Appearance") }
            }
            .buttonStyle(CustomButton())
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
                    dateAppr = Date()
                    apprNote = ""
                    activeScreen = .maininput
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
            Button {
                dateNote = Date()
                noteNote = ""
            } label: {
                Text("Add Note")
            }
            .buttonStyle(CustomButton())
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
                    dateNote = Date()
                    noteNote = ""
                    noteCategory = "NOTE"
                    activeScreen = .maininput
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
    }
    
    func auditRepresentation() -> Bool {
        statusMessage = ""
        if wrx.cause.internalID == 0 { recordError(er:"invalid cause for representation") }
        if wrx.client.internalID == 0 { recordError(er:"invalid client for representation") }
        if statusMessage == "" { return true }
        return false
    }
    
    func recordError(er:String) {
        if statusMessage != "" { statusMessage = statusMessage + "\n" + er }
        else { statusMessage = er }
    }
    
    func recordCauseSelection(cm:CauseModel) -> Void {
        wrx.cause = cm
        wrx.client = CVModel.findClient(internalID:cm.involvedClient)
        cauInternalID = cm.internalID
        cauCauseNo = cm.causeNo
        cauOrigCharge = cm.originalCharge
        if wrx.client.internalID == cm.involvedClient {
            cliInternalID = wrx.client.internalID
            cliName = wrx.client.formattedName
        }
    }
    
    func prepWorkArea() -> Void {
        if let rx = rx {
            saveMessage = "Update"
            adding = false
            wrx = rx
            wrx.representation.active = rx.representation.active
            wrx.representation.primaryCategory = rx.representation.primaryCategory
            prepRepWorkArea(xrx: rx)
            cauInternalID = rx.cause.internalID
            cauCauseNo = rx.cause.causeNo
            cauOrigCharge = rx.cause.originalCharge
            cliInternalID = rx.client.internalID
            cliName = rx.client.formattedName
            startingFilter = rx.cause.sortFormat1
            print("set starting filter to /(startingFilter) - /(rx.cause.sortFormat1)")
        } else {
            saveMessage = "Add"
            adding = true
            wrx = RepresentationExpansion()
            prepRepWorkArea(xrx: wrx)
            repDateAssigned = Date()
            wrx.representation.active = true
            repActiveString = "Yes"
            wrx.representation.primaryCategory = "ORIG"
            repDateDisp = Date()
            cauInternalID = 0
            cauCauseNo = ""
            cauOrigCharge = ""
            cliInternalID = 0
            cliName = ""
            startingFilter = ""
        }
    }
    
    func prepRepWorkArea(xrx:RepresentationExpansion) {
        repInternalID = xrx.representation.internalID
        repAssigned = xrx.representation.assignedDate
        repDateAssigned = DateService.dateString2Date(inDate: repAssigned)
        repActiveString = (xrx.representation.active) ? "Yes" : "No"
        repDispDate = xrx.representation.dispositionDate
        repDateDisp = DateService.dateString2Date(inDate: repDispDate)
        repDispType = xrx.representation.dispositionType
        repDispAction = xrx.representation.dispositionAction
        repAppearances = xrx.appearances
        repNotes = xrx.notes
    }
    
    func recordAppearance(appr:AppearanceModel) async -> Void {
        if wrx.representation.internalID == 0 {
            wrx.representation = await CVModel.addRepresentation(involvedClient: wrx.representation.involvedClient, involvedCause: wrx.representation.involvedCause, active: wrx.representation.active, assignedDate: wrx.representation.assignedDate, dispositionDate: wrx.representation.dispositionDate, dispositionType: wrx.representation.dispositionType, dispositionAction: wrx.representation.dispositionAction, primaryCategory: wrx.representation.primaryCategory)
        }
    }

}

//struct EditRepresentationView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditRepresentationView()
//    }
//}
