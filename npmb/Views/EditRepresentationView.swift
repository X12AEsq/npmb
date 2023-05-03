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
    @State var selectedClient:ClientModel = ClientModel()
    @State var selectedCause:CauseModel = CauseModel()
    @State var selectedAppearance:AppearanceModel = AppearanceModel()
    
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
//    @State var currApprs:[AppearanceModel] = []
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
    @State var apprInternal:Int = 0
    @State var apprClient:Int = 0
    @State var apprCause:Int = 0
    @State var apprRepresentation:Int = 0
    @State var apprChanged:Bool = false
//    @State var apprLocalUpdateDate:Date = Date()
//    @State var apprArray:[AppearanceModel] = []
    
    @State var dateNote:Date = Date()
    @State var noteDocumentID:String = ""
    @State var noteDate:String = ""
    @State var noteTime:String = ""
    @State var noteNote:String = ""
    @State var noteCategory:String = "NOTE"
    @State var noteInternal:Int = 0
    @State var noteClient:Int = 0
    @State var noteCause:Int = 0
    @State var noteRepresentation:Int = 0
    @State var noteChanged:Bool = false

    @State var xr:ExpandedRepresentation = ExpandedRepresentation()

    @State var startingFilter:String = ""
//    @State var activeScreen = NextAction.maininput
    @State private var orientation = UIDeviceOrientation.portrait
    @State var callResult:FunctionReturn = FunctionReturn()
    @State var adding:Bool = false
    
    @State private var showingSelCause = false
    @State private var showingInpMain = false
    @State private var showingInpAppearance = false
    @State private var showingInpNote = false
    @State private var showingPrintStatus = false

/*
    enum NextAction {
        case maininput
        case editappearance
        case editnote
        case selectcause
    }
 */
    var NoteCatOptions = ["TODO", "NOTE", "DONE"]
    
    var body: some View {
        VStack (alignment: .leading) {
            if statusMessage != "" {
                Text(statusMessage)
            }
            ScrollView {
                VStack (alignment: .leading) {
                    HStack {
                        Text("Representation:").font(.system(.body, design: .monospaced))
                        Text(String(currInternalID)).font(.system(.body, design: .monospaced))
                        Spacer()
                    }
                    HStack {
                        Text("Assigned: ").font(.system(.body, design: .monospaced))
                        Text(currAssignedDate).font(.system(.body, design: .monospaced))
                        Spacer()
                    }
                    HStack {
                        Text("Category: ").font(.system(.body, design: .monospaced))
                        Text(currCategory).font(.system(.body, design: .monospaced))
                        Spacer()
                    }
                    HStack {
                        Text("Active:").font(.system(.body, design: .monospaced))
                        Text((currActive) ? "yes" : "no").font(.system(.body, design: .monospaced))
                        Spacer()
                    }
                    
                }
                VStack (alignment: .leading) {
                    if !currActive {
                        HStack {
                            Text("Competed:").font(.system(.body, design: .monospaced))
                            Text(currDispDate).font(.system(.body, design: .monospaced))
                            Text(" ").font(.system(.body, design: .monospaced))
                            Text(currDispType).font(.system(.body, design: .monospaced))
                            Text(" ").font(.system(.body, design: .monospaced))
                            Text(currDispAction).font(.system(.body, design: .monospaced))
                            Spacer()
                        }
                    }
                    HStack {
                        Text("Cause:").font(.system(.body, design: .monospaced))
                        Text(String(currcauInternalID)).font(.system(.body, design: .monospaced))
                        Text(" ").font(.system(.body, design: .monospaced))
                        Text(currcauCauseNo).font(.system(.body, design: .monospaced))
                        Text(" ").font(.system(.body, design: .monospaced))
                        Text(currcauOrigCharge).font(.system(.body, design: .monospaced))
                        Spacer()
                    }
                    HStack {
                        Text("Client:").font(.system(.body, design: .monospaced))
                        Text(String(currcliInternalID)).font(.system(.body, design: .monospaced))
                        Text(" ").font(.system(.body, design: .monospaced))
                        Text(currcliName).font(.system(.body, design: .monospaced))
                        Spacer()
                    }
                }
                .padding(.bottom, 20.0)
                // MARK: Appearances display
                VStack (alignment: .leading) {
                    HStack {
                        Button {
                            initAppearanceWorkArea(orig: AppearanceModel())
                            showingInpAppearance.toggle()
                        } label: {
                            Text("Add new appearance").font(.system(.body, design: .monospaced))
                        }
                        .sheet(isPresented: $showingInpAppearance, onDismiss: {
                            if apprChanged {
                                initWorkArea(orig: xr.representation.internalID)
                            }
                        })  { EditRepInputAppearance(xr: $xr, dateAppr: $dateAppr, apprDate: $apprDate, apprTime: $apprTime, apprNote: $apprNote, apprChanged: $apprChanged)
                        }
                        Spacer()
                    }
                    
                    ForEach(xr.appearances, id: \.id) { appearance in
                        GeometryReader { geo in
                            HStack {
                                Button {
                                    initAppearanceWorkArea(orig: appearance)
                                    showingInpAppearance.toggle()
                                } label: {
                                    Text(appearance.stringLabel).font(.system(.body, design: .monospaced))
                                }
                                .sheet(isPresented: $showingInpAppearance, onDismiss: {
                                    if apprChanged {
                                        initWorkArea(orig: xr.representation.internalID)
                                    }
                                })  { EditRepInputAppearance(xr: $xr, dateAppr: $dateAppr, apprDate: $apprDate, apprTime: $apprTime, apprNote: $apprNote, apprChanged: $apprChanged)
                                }
                            }
                        }
                    }
                }
                .padding(.bottom, 20.0)
                // MARK: Notes display
                VStack (alignment: .leading) {
                    HStack {
                        Button {
                            initNoteWorkArea(orig: NotesModel())
                            showingInpNote.toggle()
                        } label: {
                            Text("Add new note").font(.system(.body, design: .monospaced))
                        }
                        .sheet(isPresented: $showingInpNote, onDismiss: {
                            if noteChanged {
                                initWorkArea(orig: xr.representation.internalID)
                            }
                        })  { EditRepInputNote(xr: $xr, dateNote: $dateNote, noteDate: $noteDate, noteTime: $noteTime, noteCategory: $noteCategory, noteNote: $noteNote, noteChanged: $noteChanged)
                            
                        }
                        Spacer()
                    }
                }
                
                ForEach(xr.notes, id: \.id) { note in
                    GeometryReader { geo in
                        HStack {
                            Button {
                                initNoteWorkArea(orig: note)
                                showingInpNote.toggle()
                            } label: {
                                Text(note.stringLabel).font(.system(.body, design: .monospaced))
                            }
                            .sheet(isPresented: $showingInpNote, onDismiss: {
                                if noteChanged {
                                    initWorkArea(orig: xr.representation.internalID)
                                }
                            })  { EditRepInputNote(xr: $xr, dateNote: $dateNote, noteDate: $noteDate, noteTime: $noteTime, noteCategory: $noteCategory, noteNote: $noteNote, noteChanged: $noteChanged)
                            }
                        }
                    }
                }
            }

            HStack {
                Spacer()
                if repChanged() {
                    Button {
                        CVModel.logItem(viewModel: "EditRepresentationView", item: "add/update")
                        if auditRepresentation() {
                            if currDocumentID == "" {
                                Task {
                                    await callResult =                             CVModel.addRepresentation(involvedClient: currcliInternalID, involvedCause: currcauInternalID, active: currActive, assignedDate: currAssignedDate, dispositionDate: currDispDate, dispositionType: currDispType, dispositionAction: currDispAction, primaryCategory: currCategory)
                                    if callResult.status == .successful {
                                        statusMessage = ""
                                        initWorkArea(orig: callResult.additional)
                                    } else {
                                        statusMessage = callResult.message
                                    }
                                }
                            } else {
                                Task {
                                    await callResult = CVModel.updateRepresentation(representationID: currDocumentID, involvedClient: currcliInternalID, involvedCause: currcauInternalID, active: currActive, assignedDate: currAssignedDate, dispositionDate: currDispDate, dispositionType: currDispType, dispositionAction: currDispAction, primaryCategory: currCategory, intid: currInternalID)
                                    if callResult.status == .successful {
                                        statusMessage = ""
                                        initWorkArea(orig: currInternalID)
                                    } else {
                                        statusMessage = callResult.message
                                    }
                                }
                            }
                        }
                        CVModel.logItem(viewModel: "EditRepresentationView", item: "add/update done")
                    } label: {
                        Text(saveMessage)
                    }
                    .buttonStyle(CustomNarrowButton())
                }
                
                Button {
                    showingInpMain.toggle()
                } label: {
                    Text("Main")
                }
                .buttonStyle(CustomNarrowButton())
                .sheet(isPresented: $showingInpMain, onDismiss: {
                    currInvolvedCause = currcauInternalID
                    currInvolvedClient = currcliInternalID
                })  { EditRepInputMain(currDateAssigned: $currDateAssigned, currAssignedDate: $currAssignedDate, currCategory: $currCategory, currActiveString: $currActiveString, currActive: $currActive, currDateDisp: $currDateDisp, currDispDate: $currDispDate, currDispType: $currDispType, currDispAction: $currDispAction) }
                
                Button {
                    showingSelCause.toggle()
                } label: {
                    Text("Cause")
                }
                .buttonStyle(CustomNarrowButton())
                .sheet(isPresented: $showingSelCause, onDismiss: {
                    currcauCauseNo = selectedCause.causeNo
                    currcauInternalID = selectedCause.internalID
                    currcauOrigCharge = selectedCause.originalCharge
                    selectedClient = CVModel.findClient(internalID: selectedCause.involvedClient)
                    currcliInternalID = selectedClient.internalID
                    currcliName = selectedClient.formattedName
                    currInvolvedCause = currcauInternalID
                    currInvolvedClient = currcliInternalID
                }) {
                    EditRepSelectCause(selectedCause: $selectedCause)
                }
                
                Button {
                    showingPrintStatus.toggle()
                } label: {
                    Text("Print")
                }
                .buttonStyle(CustomGreenButton())
                .sheet(isPresented: $showingPrintStatus, onDismiss: {
                    print("Print Status List Dismissed")
                })
                { PrintRepresentationStatus(xr: xr) }
                
                Button {
                    CVModel.logItem(viewModel: "EditRepresentationView", item: "checkpoint 2a")
                    initWorkArea(orig: rxid)
                    statusMessage = "Refreshed"
                } label: {
                    Text("Refresh")
                }
                .buttonStyle(CustomGreenButton())
                Spacer()
            }
        }
        .padding(.leading, 10.0)
        .onAppear {
            CVModel.logItem(viewModel: "EditRepresentationView", item: "checkpoint 2")
            initWorkArea(orig: rxid)
        }
    }
    
    func initWorkArea(orig:Int) -> Void {
        if orig == 0 {
            saveMessage = "Add"
        } else {
            saveMessage = "Update"
        }
        
        CVModel.assembleExpandedCauses()
        CVModel.assembleExpandedRepresentations()

        CVModel.logItem(viewModel: "EditRepresentationView", item: "initWorkArea " + String(orig) + "; " + String(rxid))
        xr = CVModel.expandedrepresentations.first(where: { $0.representation.internalID == rxid }) ?? ExpandedRepresentation()
        
        origRepresentation = xr.representation
//        repChangedFlag = false

        currInternalID = origRepresentation.internalID
        currDocumentID = origRepresentation.id ?? ""
        
        if currInternalID != 0 {
            currAssignedDate = origRepresentation.assignedDate
            currDateAssigned = origRepresentation.DateAssigned
            currDispDate = origRepresentation.dispositionDate
            currDateDisp = origRepresentation.DateDisposed
        } else {
            currDateAssigned = Date()
            currDateAssigned = Date()
            currDateDisp = currDateAssigned
            currAssignedDate = DateService.dateDate2String(inDate: currDateAssigned)
            currDispDate = DateService.dateDate2String(inDate: currDateDisp)
        }
        currDispType = origRepresentation.dispositionType
        currDispAction = origRepresentation.dispositionAction
        currCategory = origRepresentation.primaryCategory
        currActive = origRepresentation.active
        currActiveString = (origRepresentation.active) ? "Yes" : "No"
//        currApprs = origRepresentation.appearances
        
        currcliInternalID = origRepresentation.involvedClient
        currcliName = xr.xpcause.client.formattedName

        currcauInternalID = origRepresentation.involvedCause
        currcauCauseNo = xr.xpcause.cause.causeNo
        currcauOrigCharge = xr.xpcause.cause.originalCharge
    }
    
    func repChanged() -> Bool {
        if origRepresentation.involvedClient != currcliInternalID { return true }
        if origRepresentation.involvedCause != currInvolvedCause { return true }
        if origRepresentation.active != currActive { return true }
        if origRepresentation.primaryCategory != currCategory { return true }
        if origRepresentation.internalID != currInternalID { return true }
        if origRepresentation.assignedDate != currAssignedDate { return true }
        if origRepresentation.dispositionDate != currDispDate { return true }
        if origRepresentation.dispositionType != currDispType { return true }
        if origRepresentation.dispositionAction != currDispAction { return true }
        return false
    }
    
    func auditRepresentation() -> Bool {
        statusMessage = ""
        if currInvolvedCause == 0 { recordError(er:"invalid cause for representation") }
        if currInvolvedClient == 0 { recordError(er:"invalid client for representation") }
        if statusMessage == "" { return true }
        return false
    }
    
    func initAppearanceWorkArea(orig:AppearanceModel) {
        if orig.internalID == 0 {
            dateAppr = Date()
            orig.appearDate = DateService.dateDate2String(inDate:dateAppr)
            orig.appearTime = DateService.dateTime2String(inDate:dateAppr)
            orig.involvedRepresentation = currInternalID
            orig.involvedCause = currcauInternalID
            orig.involvedClient = currcliInternalID
        }
        apprDocumentID = orig.id ?? ""
        apprDate = orig.appearDate
        apprTime = orig.appearTime
        apprNote = orig.appearNote
        apprCause = orig.involvedClient
        apprClient = orig.involvedClient
        apprRepresentation = orig.involvedRepresentation
        apprInternal = orig.internalID
        dateAppr =  DateService.dateString2Date(inDate:orig.appearDate, inTime:orig.appearTime)
        apprChanged = false
    }
    
    func initNoteWorkArea(orig:NotesModel) {
        if orig.internalID == 0 {
            dateNote = Date()
            orig.noteDate = DateService.dateDate2String(inDate:dateAppr)
            orig.noteTime = DateService.dateTime2String(inDate:dateAppr)
            orig.noteCategory = "ORIG"
            orig.involvedRepresentation = currInternalID
            orig.involvedCause = currcauInternalID
            orig.involvedClient = currcliInternalID
        }
        noteDocumentID = orig.id ?? ""
        noteDate = orig.noteDate
        noteTime = orig.noteTime
        noteNote = orig.noteNote
        noteCause = orig.involvedClient
        noteClient = orig.involvedClient
        noteRepresentation = orig.involvedRepresentation
        noteInternal = orig.internalID
        dateNote =  DateService.dateString2Date(inDate:orig.noteDate, inTime:orig.noteTime)
        noteChanged = false
    }

    func recordError(er:String) {
        if statusMessage != "" { statusMessage = statusMessage + "\n" + er }
        else { statusMessage = er }
        CVModel.logItem(viewModel:"EditRepresentationView", item:er)
    }
}

//struct EditRepresentationView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditRepresentationView()
//    }
//}
