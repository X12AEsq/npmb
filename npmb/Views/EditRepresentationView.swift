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
    @State var origRepresentation:RepresentationModel = RepresentationModel()
//    @State var currRepresentation:RepresentationModel = RepresentationModel()
    @State var workingid:Int = 0
//    @State var wrx:RepresentationExpansion = RepresentationExpansion()

    @State var statusMessage:String = ""
    @State var saveMessage:String = ""
//    @State var rep:RepresentationModel = RepresentationModel()
//    @State var cau:CauseModel = CauseModel()
//    @State var cli:ClientModel = ClientModel()
    @State var selectedCause:CauseModel = CauseModel()
    
    var pc:PrimaryCategory = PrimaryCategory()
    var dto:DispositionTypeOptions = DispositionTypeOptions()
    var dao:DispositionActionOptions = DispositionActionOptions()
    var activeOptions = ["Yes", "No"]
/*
    These variables are initialized to the original input; they then become the workarea for data input. They are initialized along with origRepresentation at entry. After that, origRepresentation will not change unless there is an update or addition. If that happens, both origRepresentation and the curr** variables will be reinitialized
*/
    @State var currDocumentID:String = ""
    @State var currInternalID:Int = 0
    @State var currAssignedDate:String = ""
    @State var currDateAssigned:Date = Date()
    @State var currCategory:String = ""
    @State var currActive:Bool = true
    @State var currActiveString:String = ""
    @State var currDispDate:String = ""
    @State var currDateDisp:Date = Date()
    @State var currDispType:String = ""
    @State var currDispAction:String = ""
    @State var currApprs:[AppearanceModel] = []
    @State var repNotes:[NotesModel] = []
    @State var currInvolvedCause:Int = 0
    @State var currInvolvedClient:Int = 0
//    @State var repAdding:Bool = false
    @State var repChangedFlag:Bool = false
    
    @State var currcauInternalID = 0
    @State var currcauCauseNo = ""
    @State var currcauOrigCharge = ""
    
    @State var currcliInternalID:Int = 0
    @State var currcliName:String = ""
    
    @State var dateAppr:Date = Date()
    @State var apprDocumentID:String = ""
    @State var apprDate:String = ""
    @State var apprTime:String = ""
    @State var apprNote:String = ""
    @State var apprCategory:String = ""
    @State var apprInternal:Int = 0
    @State var apprLocalUpdateDate:Date = Date()
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
    
    var body: some View {
        GeometryReader { geo in
            VStack (alignment: .leading) {
                VStack (alignment: .leading) {
// MARK: CROSS PAGE HEADER AT TOP: variable:mainsummary
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
                    HStack {
// MARK: LEFT HAND SIDE OF PAGE BOTTOM: variable:detail
                        
/*
    For appearance or note input, disappear the main and cause buttons, and only display the appear or note buttons if there has been no representation change.
*/
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
                                        if !repChangedFlag {
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
/*
    These action buttons allow the representation itself to be added ...
*/
                                HStack {
                                    if activeScreen != .editappearance && activeScreen != .editnote {
                                        Button {
                                            if auditRepresentation() {
                                                Task {
                                                    if currDocumentID == "" {
                                                        await callResult = CVModel.addRepresentation(involvedClient: currInvolvedClient, involvedCause: currInvolvedCause, active: currActive, assignedDate: currAssignedDate, dispositionDate: currDispDate, dispositionType: currDispType, dispositionAction: currDispAction, primaryCategory: currCategory)
                                                        print("add representation returned ", callResult)
                                                        if callResult.status == .successful {
                                                            statusMessage = ""
                                                            initWorkArea(orig: callResult.additional)
//                                                            rep = CVModel.findRepresentation(internalID:callResult.additional)
                                                            await callResult = CVModel.attachCauseToRepresentation(representationID:origRepresentation.id ?? "",involvedCause: currInvolvedCause, involvedRepresentation:origRepresentation.internalID)
                                                            print("attach cause returned ", callResult)
                                                            if callResult.status == .successful {
                                                                statusMessage = ""
                                                                initWorkArea(orig: origRepresentation.internalID)
//                                                                prepWorkArea(repid: rep.internalID)
                                                                activeScreen = .maininput
                                                            } else {
                                                                statusMessage = callResult.message
                                                            }
                                                        } else {
                                                            statusMessage = callResult.message
                                                        }
                                                    } else {
                        // TODO: need to handle the case where the attached cause changes - recriprocal pointers
                                                        await callResult = CVModel.updateRepresentation(representationID: currDocumentID, involvedClient: currInvolvedClient, involvedCause: currInvolvedCause, active: currActive, assignedDate: currAssignedDate, dispositionDate: currDispDate, dispositionType: currDispType, dispositionAction: currDispAction, primaryCategory: currCategory, intid: currInternalID)
                                                        if callResult.status == .successful {
                                                            statusMessage = ""
                                                            initWorkArea(orig: currInternalID)
//                                                            prepWorkArea(repid: workingid)
                                                        } else {
                                                            statusMessage = callResult.message
                                                        }
                                                    }
                                                }
                                            }
                                        } label: {
                                            Text(saveMessage)
                                        }
                                        .buttonStyle(CustomButton())
                                        if repChangedFlag {
                                            Button {
                                                initWorkArea(orig: currInternalID)
//                                                            prepWorkArea(repid: workingid)
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
// MARK: RIGHT HAND SIDE OF PAGE BOTTOM: variables can be inputmain, inputNote, or inputAppr
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
                                                    // TODO: This is all messed up - need to pop the selection screen, then act on the results; that initial check on internalID is messing with the logic
                                                    SelectCauseUtil(selectedCause: $selectedCause, startingFilter: selectedCause.causeNo)
                                                    Spacer()
                                                    HStack {
                                                        Button {
                                                            print("selectcauseutil returned ", selectedCause.causeNo)
                                                            currcauCauseNo = selectedCause.causeNo
                                                            currcauInternalID = selectedCause.internalID
                                                            currcauOrigCharge = selectedCause.originalCharge
//                                                            currcliInternalID = selectedCause.client.internalID
//                                                            currcliName = selectedCause.client.formattedName
//                                                            cau = selectedCause
//                                                            cli = CVModel.findClient(internalID: cau.involvedClient)
//                                                            cauInternalID = cau.internalID
//                                                            cauCauseNo = cau.causeNo
//                                                            cauOrigCharge = cau.originalCharge
//                                                            cliInternalID = cli.internalID
//                                                            cliName = cli.formattedName
//                                                            currInvolvedCause = cauInternalID
//                                                            currInvolvedClient = cliInternalID
                                                            activeScreen = .maininput
                                                        }
                                                    label: {
                                                        Text("Select")
                                                    }
                                                    .buttonStyle(CustomButton())
                                                    Button {
//                                                        cau = CauseModel()
//                                                        cli = ClientModel()
//                                                        cauInternalID = 0
//                                                        cauCauseNo = ""
//                                                        cauOrigCharge = ""
//                                                        cliInternalID = 0
//                                                        cliName = ""
                                                        activeScreen = .maininput
                                                        }
                                                    label: {
                                                        Text("Quit")
                                                    }
                                                    .buttonStyle(CustomButton())
                                                        
                                                        //                                                    if selectedCause.internalID != 0 {
                                                        //                                                        Button {
                                                        //                                                            recordCauseSelection(cm:selectedCause)
                                                        //                                                            print("selectcauseutil returned ", selectedCause.causeNo)
                                                        //                                                        }
                                                        //                                                        label: {
                                                        //                                                        if adding { Text("add cause") }
                                                        //                                                        else { Text("update cause") }
                                                        //                                                        }
                                                        //                                                        .buttonStyle(CustomButton())
                                                        //                                                    } else {
                                                        //                                                        SelectCauseUtil(selectedCause: $selectedCause, startingFilter: selectedCause.causeNo)
                                                        //                                                    }
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
// MARK: END OF MAIN VIEW; initial appearance handling
        .onAppear {
            print("Checkpoint 3")
            initWorkArea(orig: rxid)
            workingid = rxid
//            prepWorkArea(repid: workingid)
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
    
    func initWorkArea(orig:Int) -> Void {
        if orig == 0 {
            saveMessage = "Add"
        } else {
            saveMessage = "Update"
        }
        let xr = CVModel.expandedrepresentations.first(where: { $0.representation.internalID == rxid })
        
        origRepresentation = xr?.representation ?? RepresentationModel()
        repChangedFlag = false
/*
 self.id = fsid
 self.involvedClient = client
 self.involvedCause = cause
 self.involvedAppearances = appearances
 self.involvedNotes = notes
 self.active = active
 self.dispositionDate = dispositiondate
 self.dispositionAction = dispositionaction
 self.cause = causemodel
*/
//        currRepresentation = origRepresentation
        currInternalID = origRepresentation.internalID
        currAssignedDate = origRepresentation.assignedDate
        currDateAssigned = origRepresentation.DateAssigned
        currDispDate = origRepresentation.dispositionDate
        currDateDisp = origRepresentation.DateDisposed
        currDispType = origRepresentation.dispositionType
        currDispAction = origRepresentation.dispositionAction
        currCategory = origRepresentation.primaryCategory
        currActive = origRepresentation.active
        print("Set point 1", currActive, origRepresentation.active)
        currActiveString = (origRepresentation.active) ? "Yes" : "No"
        currApprs = origRepresentation.appearances
        
        currcliInternalID = origRepresentation.involvedClient
        currcliName = xr?.xpcause.client.formattedName ?? "No Client"

        currcauInternalID = origRepresentation.involvedCause
        currcauCauseNo = xr?.xpcause.cause.causeNo ?? "No Cause"
        currcauOrigCharge = xr?.xpcause.cause.originalCharge ?? "No Cause"
    }
    
// MARK: CROSS PAGE HEADER AT TOP: variable:mainsummary

    var mainsummary: some View {
        HStack (alignment: .top){
            VStack (alignment: .leading) {
                HStack {
                    Text("Representation:")
                    Text(String(currInternalID))
                }
                HStack {
                    Text("Assigned: ")
                    Text(currAssignedDate)
                }
                HStack {
                    Text("Category: ")
                    Text(currCategory)
                }
            }
            Spacer()
            VStack (alignment: .leading) {
                HStack {
                    Text("Active:")
                    Text((currActive) ? "yes" : "no")
                }
            }
            Spacer()
            VStack (alignment: .leading) {
                if !currActive {
                    HStack {
                        Text("Competed:")
                        Text(currDispDate)
                        Text(" ")
                        Text(currDispType)
                        Text(" ")
                        Text(currDispAction)
                    }
                }
                HStack {
                    Text("Cause:")
                    Text(String(currcauInternalID))
                    Text(" ")
                    Text(currcauCauseNo)
                    Text(" ")
                    Text(currcauOrigCharge)
                }
                HStack {
                    Text("Client:")
                    Text(String(currcliInternalID))
                    Text(" ")
                    Text(currcliName)
                }
            }
        }
        .padding(.all, 20.0)
        .border(.yellow, width: 4)
    }
    
// MARK: LEFT HAND SIDE OF PAGE BOTTOM: variable:detail
    
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
                        ForEach(currApprs) { appr in
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
            print("Checkpoint 1")
        }
    }
/*
    inputmain is the data entry screen for the representation itself; it appears on the right hand side of the bottom when "main" has been selected for entry
*/
    // MARK: RIGHT HAND SIDE OF PAGE BOTTOM: inputmain

    var inputmain: some View {
        VStack (alignment: .leading) {
            HStack {
                Text("Assigned")
                DatePicker("", selection: $currDateAssigned, displayedComponents: [.date]).padding().onChange(of: currDateAssigned, perform: { value in
                        currAssignedDate = DateService.dateDate2String(inDate: value)
                    if currAssignedDate != origRepresentation.assignedDate { print("change 1"); repChangedFlag = true }
                    }
                )
            }
            HStack {
                Text("Category")
                Spacer()
                Picker("Category", selection: $currCategory) {
                    ForEach(pc.primaryCategories, id: \.self) {
                        Text($0).onChange(of: currCategory, perform: { value in
                            print("select category ", currCategory, value)
                            currCategory = value
                            if currCategory != origRepresentation.primaryCategory { print("change 2"); repChangedFlag = true }
                        })
                    }
                }
            }
            HStack {
                Text("Active")
                Spacer()
                Picker("", selection: $currActiveString) {
                    ForEach(activeOptions, id: \.self) {
                        Text($0).onChange(of: currActiveString, perform: { value in
                            print("Set point 2", currActive, origRepresentation.active, value)
                            currActive = (value == "Yes")
                            if currActive != origRepresentation.active { print("change 3"); repChangedFlag = true }
                        })
                    }
                }
            }
            if !currActive {
                HStack {
                    Text("Disposed")
                    DatePicker("", selection: $currDateDisp, displayedComponents: [.date]).padding()
                        .onChange(of: currDateDisp, perform: { value in
                            currDispDate = DateService.dateDate2String(inDate: value)
                            if currDispDate != origRepresentation.dispositionDate { print("change 4"); repChangedFlag = true }
                        })
                }
                
                HStack {
                    Text("Disposition Type")
                    Spacer()
                    Picker(selection: $currDispType) {
                        ForEach(dto.dispositionTypeOptions , id: \.self) {
                            Text($0).onChange(of: currDispType, perform: { value in
                                if currDispType != origRepresentation.dispositionType { print("change 5"); repChangedFlag = true }
                            })
                        }
                    } label: {
                        Text("Type")
                    }
                }
                
                HStack {
                    Text("Disposition Action")
                    Spacer()
                    Picker(selection: $currDispAction) {
                        ForEach(dao.dispositionActionOptions , id: \.self) {
                            Text($0).onChange(of: currDispAction, perform: { value in
                                if currDispAction != origRepresentation.dispositionAction { print("change 6"); repChangedFlag = true }
                            })
                        }
                    } label: {
                        Text("Action")
                    }
                }
            }
            Spacer()
// Top
            HStack {
                Button {
                    if auditRepresentation() {
                        Task {
                            if currDocumentID == "" {
                                await callResult = CVModel.addRepresentation(involvedClient: currInvolvedClient, involvedCause: currInvolvedCause, active: currActive, assignedDate: currAssignedDate, dispositionDate: currDispDate, dispositionType: currDispType, dispositionAction: currDispAction, primaryCategory: currCategory)
                                print("add representation returned ", callResult)
                                if callResult.status == .successful {
                                    statusMessage = ""
                                    repChangedFlag = false
                                    initWorkArea(orig: callResult.additional)
//                                    rep = CVModel.findRepresentation(internalID:callResult.additional)
                                    await callResult = CVModel.attachCauseToRepresentation(representationID:currDocumentID, involvedCause: currInvolvedCause, involvedRepresentation:currInternalID)
                                    print("attach cause returned ", callResult)
                                    if callResult.status == .successful {
                                        statusMessage = ""
                                        initWorkArea(orig: currInternalID)
//                                        prepWorkArea(repid: rep.internalID)
                                        activeScreen = .maininput
                                    } else {
                                        statusMessage = callResult.message
                                    }
                                } else {
                                    statusMessage = callResult.message
                                }
                            } else {
// TODO: need to handle the case where the attached cause changes - recriprocal pointers
                                await callResult = CVModel.updateRepresentation(representationID: currDocumentID, involvedClient: currInvolvedClient, involvedCause: currInvolvedCause, active: currActive, assignedDate: currAssignedDate, dispositionDate: currDispDate, dispositionType: currDispType, dispositionAction: currDispAction, primaryCategory: currCategory, intid: currInternalID)
                                if callResult.status == .successful {
                                    statusMessage = ""
                                    repChangedFlag = false
                                    initWorkArea(orig: currInternalID)
//                                    prepWorkArea(repid: workingid)
                                } else {
                                    statusMessage = callResult.message
                                }
                            }
                        }
                    }
                } label: {
                    Text("Save")
                }
                .buttonStyle(CustomButton())
                Button {
//                    prepWorkArea(repid: rep.internalID)
                    initWorkArea(orig: origRepresentation.internalID)
                    activeScreen = .maininput
                } label: {
                    Text("Quit (no save")
                }
                .buttonStyle(CustomButton())
            }
// Bottom
        }
        .onAppear {
            print("checkpoint 2")
            initWorkArea(orig: rxid)
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
                        if apprInternal == 0 {
                            Task {
                                await callResult = CVModel.addAppearanceToRepresentation(representationID: currDocumentID, involvedClient: currInvolvedClient, involvedCause: currInvolvedCause, involvedRepresentation: currInternalID, appearDate: apprDate, appearTime: apprTime, appearNote: apprNote)
                                print("inputAppr addAppearanceToRepresentation returned ", callResult)
                                switch callResult.status {
                                case .successful:
                                    statusMessage = ""
                                    initWorkArea(orig: currInternalID)
//                                    prepWorkArea(repid: workingid)
                                    print("successful appearance add, prepWorkArea invoked ", workingid, CVModel.lastAppearanceUpdate)
                                case .IOError:
                                    print("I have no idea ", callResult)
                                    statusMessage = callResult.message
                                default:
                                    print("I have even less idea")
                                }
                            }
                        } else {
                            Task {
                                await callResult = CVModel.updateAppearance(appearanceID: apprDocumentID, intID: apprInternal, involvedClient: currInvolvedClient, involvedCause: currInvolvedCause, involvedRepresentation: currInternalID, appearDate: apprDate, appearTime: apprTime, appearNote: apprNote)
                                if callResult.status == .successful {
                                    statusMessage = ""
                                    initWorkArea(orig: currInternalID)
//                                    prepWorkArea(repid: workingid)
                                    print("successful appearance update, prepWorkArea invoked ", workingid, CVModel.lastAppearanceUpdate)
                                } else {
                                    statusMessage = callResult.message
                                }
                            }
                        }
                        print("We're getting to here?")
                        dateAppr = Date()
                        apprNote = ""
                        activeScreen = .maininput
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
                                await callResult = CVModel.addNoteToRepresentation(representationID: currDocumentID, client: currInvolvedClient, cause: currInvolvedCause, representation: currInternalID, notedate: noteDate, notetime: noteTime, notenote: noteNote, notecategory: noteCategory)
                            } else {
                                // CVModel.updateNote ....
                            }
                            dateNote = Date()
                            noteNote = ""
                            noteCategory = "NOTE"
                            activeScreen = .maininput
                            if callResult.status == .successful {
                                statusMessage = ""
                                initWorkArea(orig: currInternalID)
//                                    prepWorkArea(repid: workingid)
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
        if currInvolvedCause == 0 { recordError(er:"invalid cause for representation") }
        if currInvolvedClient == 0 { recordError(er:"invalid client for representation") }
        if statusMessage == "" { return true }
        return false
    }
    
    func auditAppearance() -> Bool {
        statusMessage = ""
        if currDocumentID == "" { recordError(er:"unknown document id for representation") }
        if currInternalID == 0 { recordError(er:"unknown internal id for representation") }
        if currInvolvedCause == 0 { recordError(er:"invalid cause for representation") }
        if currInvolvedClient == 0 { recordError(er:"invalid client for representation") }
        if apprDate == "" { recordError(er: "invalid appearance date")}
        if apprTime == "" { recordError(er: "invalid appearance time")}
        if statusMessage == "" { return true }
        return false
    }
    
    func auditNote() -> Bool {
        statusMessage = ""
        if currDocumentID == "" { recordError(er:"unknown document id for representation") }
        if currInternalID == 0 { recordError(er:"unknown internal id for representation") }
        if currInvolvedCause == 0 { recordError(er:"invalid cause for representation") }
        if currInvolvedClient == 0 { recordError(er:"invalid client for representation") }
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
//        if rep.involvedCause != cm.internalID {
//
//        }
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
    
//    func prepWorkArea(repid:Int) -> Void {
//        if repid == 0 {
//            rep = RepresentationModel()
//            repApprs = []
//            repNotes = []
//        } else {
//            rep = CVModel.findRepresentation(internalID:repid)
//            repApprs = CVModel.assembleAppearances(repID: repid)
//            repNotes = CVModel.assembleNotes(repID: repid)
//            apprLocalUpdateDate = Date()
//            print("prepWorkArea counts", repApprs.count, repNotes.count, apprLocalUpdateDate, CVModel.lastAppearanceUpdate)
//        }
//
//        if rep.involvedCause == 0 {
//            cau = CauseModel()
//        } else {
//            cau = CVModel.findCause(internalID: rep.involvedCause)
//        }
//
//        if rep.involvedClient == 0 {
//            cli = ClientModel()
//        } else {
//            cli = CVModel.findClient(internalID: rep.involvedClient)
//        }
//        repClient = rep.involvedClient
//        repCause = rep.involvedCause
//        repActive = rep.active
//        repActiveString = (rep.active) ? "Yes" : "No"
//        repCategory = rep.primaryCategory
//        repInternalID = rep.internalID
//        repDocumentID = rep.id ?? ""
//        repAssigned = rep.assignedDate
//        repDateAssigned = DateService.dateString2Date(inDate: repAssigned)
//        repDispDate = rep.dispositionDate
//        repDateDisp = DateService.dateString2Date(inDate: repDispDate)
//        repDispType = rep.dispositionType
//        repDispAction = rep.dispositionAction
//        if rep.internalID != 0 {
//            saveMessage = "Update"
//            adding = false
//            repAppearances = rep.appearances
//            repNotes = rep.notes
//            cauInternalID = cau.internalID
//            cauCauseNo = cau.causeNo
//            cauOrigCharge = cau.originalCharge
//            cliInternalID = cli.internalID
//            cliName = cli.formattedName
//            startingFilter = cau.sortFormat1
//            repAdding = false
//            repChanged = false
//        } else {
//            saveMessage = "Add"
//            adding = true
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
//            repAdding = true
//            repChanged = false
//        }
//        CVModel.setTimeStamp()
//    }
    
//    func repChanged() -> Bool {
//        repChangedFlag = false
//        if origRepresentation.involvedClient != currInvolvedClient { repChangedFlag = true }
//        if origRepresentation.involvedCause != currInvolvedCause { repChangedFlag = true }
//        print("Set point 3", currActive, origRepresentation.active)
//        if origRepresentation.active != currActive { repChangedFlag = true }
//        if origRepresentation.primaryCategory != currCategory { repChangedFlag = true }
//        if origRepresentation.internalID != currInternalID { repChangedFlag = true }
//        if origRepresentation.assignedDate != currAssignedDate { repChangedFlag = true }
//        if origRepresentation.dispositionDate != currDispDate { repChangedFlag = true }
//        if origRepresentation.dispositionType != currDispType { repChangedFlag = true }
//        if origRepresentation.dispositionAction != currDispAction { repChangedFlag = true }
//        return repChangedFlag
//    }
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
