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
    @State var repCategory:String = ""
    @State var repActive:Bool = true
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
    @State var startingFilter:String = ""
    @State var activeScreen = NextAction.maininput
    @State private var orientation = UIDeviceOrientation.portrait
    
    enum NextAction {
        case maininput
        case editappearance
        case editnote
        case selectcause
    }

    var body: some View {
        GeometryReader { geo in
            VStack (alignment: .leading) {
                VStack (alignment: .leading) {
                    Text("Representation").font(.title)
                        .padding([.leading, .bottom, .trailing])
                    if statusMessage != "" {
                        Text(statusMessage)
                            .font(.body)
                            .foregroundColor(Color.red)
                            .multilineTextAlignment(.leading)
                            .padding([.leading, .bottom, .trailing])
                         }
                    HStack {
                        VStack {
                            VStack {
                                detail
                                Spacer()
                                HStack {
                                    Button {
                                        activeScreen = .maininput
                                    } label: {
                                        Text("Edit Representation")
                                    }
                                    .buttonStyle(CustomButton())
                                    Button {
                                        activeScreen = .selectcause
                                    } label: {
                                        Text("Attach Cause")
                                    }
                                    .buttonStyle(CustomButton())
                                    Button {
                                        activeScreen = .editappearance
                                    } label: {
                                        Text("Add/Edit Appearance")
                                    }
                                    .buttonStyle(CustomButton())
                                    Button {
                                        activeScreen = .editnote
                                    } label: {
                                        Text("Add/Edit Note")
                                    }
                                    .buttonStyle(CustomButton())
                                }

                                HStack {
                                    Button {
                                        if saveMessage == "Update" {
                                            print("Select Update")
                                        } else {
                                            print("Select Save")
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
                                        .frame(maxWidth: .infinity, maxHeight: 55)
                                        .background(.gray.opacity(0.3), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
                                    }
                                }
                            }
                            .padding()
                            .border(.indigo, width: 4)
                        }
                        .padding()
                        .frame(width: geo.size.width * 0.495)
                        .border(.yellow, width: 4)

                        ZStack {
                            VStack {
                                if activeScreen == .maininput {
                                    inputmain
                                } else {
                                    if activeScreen == .editnote {
                                        HStack {
                                            Button {
                                                activeScreen = .maininput
                                            } label: {
                                                Text("Add/Edit Main")
                                            }
                                            .buttonStyle(CustomButton())
                                            Button {
                                                activeScreen = .editappearance
                                            } label: {
                                                Text("Add/Edit Appearance")
                                            }
                                            .buttonStyle(CustomButton())
                                        }
                                    } else {
                                        if activeScreen == .editappearance {
                                            HStack {
                                                Button {
                                                    activeScreen = .maininput
                                                } label: {
                                                    Text("Add/Edit Main")
                                                }
                                                .buttonStyle(CustomButton())
                                                Button {
                                                    activeScreen = .editnote
                                                } label: {
                                                    Text("Add/Edit Note")
                                                }
                                                .buttonStyle(CustomButton())
                                            }
                                        } else {
                                            if activeScreen == .selectcause {
                                                SelectCauseUtil(selectedCause: $selectedCause, startingFilter: rx?.cause.causeNo)
                                                    .padding()
                                                    .border(.indigo, width: 4)
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                        .padding(.bottom)
                        .frame(width: geo.size.width * 0.495)
                        .border(.yellow, width: 4)
                    }
                }

                
//                VStack {
//                }
            }
        }
        .onAppear {
            if let rx = rx {
                saveMessage = "Update"
                repInternalID = rx.representation.internalID
                repAssigned = rx.representation.assignedDate
                repDateAssigned = DateService.dateString2Date(inDate: repAssigned)
                repActive = rx.representation.active
                repActiveString = (repActive) ? "Yes" : "No"
                repCategory = rx.representation.primaryCategory
                repDispDate = rx.representation.dispositionDate
                repDateDisp = DateService.dateString2Date(inDate: repDispDate)
                repDispType = rx.representation.dispositionType
                repDispAction = rx.representation.dispositionAction
                repAppearances = rx.appearances
                repNotes = rx.notes
                cauInternalID = rx.cause.internalID
                cauCauseNo = rx.cause.causeNo
                cauOrigCharge = rx.cause.originalCharge
                cliInternalID = rx.client.internalID
                cliName = rx.client.formattedName
                startingFilter = rx.cause.sortFormat1
                print("set starting filter to /(startingFilter) - /(rx.cause.sortFormat1)")
            } else {
                saveMessage = "Add"
                repInternalID = 0
                repAssigned = ""
                repDateAssigned = Date()
                repActive = true
                repActiveString = "Yes"
                repCategory = ""
                repDispDate = ""
                repDispType = ""
                repDateDisp = Date()
                repDispAction = ""
                repAppearances = []
                repNotes = []
                cauInternalID = 0
                cauCauseNo = ""
                cauOrigCharge = ""
                cliInternalID = 0
                cliName = ""
                startingFilter = ""
            }
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
    
    
    var detail: some View {
        VStack (alignment: .leading) {
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
                HStack {
                    Text("Active:")
                    Text((repActive) ? "yes" : "no")
                }
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
            .padding(.all, 20.0)
            .border(.indigo, width: 4)
            
            VStack (alignment: .leading) {
                Text("Appearances")
                ScrollView {
                    ForEach(repAppearances) { appr in
                        HStack (alignment: .top) {
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
            
            VStack (alignment: .leading) {
                Text("Notes")
                ScrollView {
                    ForEach(repNotes) { note in
                        HStack (alignment: .top) {
                            Text(note.noteDate)
                            Text(note.noteTime)
                            Text(note.noteNote)
                            Spacer()
                        }
                     }
                }
            }
            .padding(.all, 20.0)
            .border(.indigo, width: 4)

        }
                
    }
    
    var inputmain: some View {
        Form {
            Section(header: Text("Representation Data").background(Color.blue).foregroundColor(.white)) {
                DatePicker("Assigned", selection: $repDateAssigned, displayedComponents: [.date]).padding().onChange(of: repDateAssigned, perform: { value in
                    repAssigned = DateService.dateDate2String(inDate: repDateAssigned)
                })
                Picker("Category", selection: $repCategory) {
                    ForEach(pc.primaryCategories, id: \.self) {
                        Text($0)
                    }
                }
                Picker("Active", selection: $repActiveString) {
                    ForEach(activeOptions, id: \.self) {
                        Text($0).onChange(of: repActiveString, perform: { value in
                            repActive = (value == "Yes")
                         })
                    }
                }
                if !repActive {
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
}

//struct EditRepresentationView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditRepresentationView()
//    }
//}
