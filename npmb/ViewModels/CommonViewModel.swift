//
//  CommonViewModel.swift
//  npmb
//
//  Created by Morris Albers on 2/25/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import SwiftUI

class CommonViewModel: ObservableObject {
    
    private let db = Firestore.firestore()
    
    let auth = Auth.auth()
    
    @Published var taskCompleted = false
    
    @Published var userSession: FirebaseAuth.User?
    
    @Published var presentedViews = NavigationPath()
    
    @Published var appStatus:String = ""
    
    @Published var lastUpdate:Date = Date()
    @Published var lastAppearanceUpdate:Date = Date()
    
    @Published var clients = [ClientModel]()
    @Published var causes = [CauseModel]()
    @Published var representations = [RepresentationModel]()
    @Published var appearances = [AppearanceModel]()
    @Published var notes = [NotesModel]()
    
    @Published var expandedcauses = [ExpandedCause]()
    @Published var expandedrepresentations = [ExpandedRepresentation]()

    var clientListener: ListenerRegistration?
    var causeListener: ListenerRegistration?
    var representationListener: ListenerRegistration?
    var appearanceListener: ListenerRegistration?
    var notesListener: ListenerRegistration?

    init() {
        userSession = auth.currentUser
        appStatus = "npmb v1.07\n"
        appStatus += "EditRepresentationView needs CRUD logic and note and appearance UI\n"
    }
    
    // MARK: Login Functions
    
    @MainActor
    func createUser(withEmail email: String, password: String) async {
        do {
            let authDataResult = try await auth.createUser(withEmail: email, password: password)
            userSession = authDataResult.user
            print("Debug: User created successfully")
        } catch {
            print("Debug: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func signIn(withEmail email: String, password: String) async -> Bool {
        do {
            let authDataResult = try await auth.signIn(withEmail: email, password: password)
            userSession = authDataResult.user
            print("Debug: User signed in successfully")
            self.clientSubscribe()
            self.causeSubscribe()
            self.noteSubscribe()
            self.appearanceSubscribe()
            self.representationSubscribe()
            return true
        } catch {
            print("Debug: Failed to sign in user with error \(error.localizedDescription)")
            return false
        }
    }
    
    @MainActor
    func signout() -> Bool {
        do {
            try auth.signOut()
            userSession = nil
            print("Debug: User signed out successfully")
            return true
        } catch {
            print("Debug: Failed to sign out user with error \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: Client Functions
    
    func clientSubscribe() {
        if clientListener == nil {
            clientListener = db.collection("clients").addSnapshotListener
            { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    return
                }
                self.clients = []
                _ = documents.map { queryDocumentSnapshot -> Void in
                    let data = queryDocumentSnapshot.data()
                    
                    let internalID = data["internalID"] as? Int ?? 0
                    let lastname = data["LastName"] as? String ?? ""
                    let firstName = data["FirstName"] as? String ?? ""
                    let middleName = data["MiddleName"] as? String ?? ""
                    let suffix = data["Suffix"] as? String ?? ""
                    let street = data["Street"] as? String ?? ""
                    let city = data["City"] as? String ?? ""
                    let state = data["State"] as? String ?? ""
                    let zip = data["Zip"] as? String ?? ""
                    let area = data["AreaCode"] as? String ?? ""
                    let exchange = data["Exchange"] as? String ?? ""
                    let number = data["TelNumber"] as? String ?? ""
                    let note = data["Note"] as? String ?? ""
                    let jail = data["Jail"] as? String ?? ""
                    let representation = data["Representation"] as? [Int] ?? []
                    let cl:ClientModel = ClientModel(fsid: queryDocumentSnapshot.documentID, intid:internalID, lastname:lastname, firstname: firstName, middlename: middleName, suffix: suffix, street: street, city: city, state: state, zip: zip, phone: FormattingService.fmtphone(area: area, exchange: exchange, number: number), note: note, jail: jail, representation: representation)
                    self.clients.append(cl)
                    if cl.internalID == 419 {
                        let debugMsg:String = Date().formatted(Date.FormatStyle().secondFraction(.milliseconds(4)))
                        print("clientSubscribe " + String(cl.internalID) + "; " + cl.formattedName + "; " + String(self.clients.count) + "; " + debugMsg)
                    }
                    return
                }
            }
        }
    }
    
    func nextClientID() -> Int {
        // find client with greatest internal id
        let greatestclient = clients.max {a, b in a.internalID < b.internalID }
        // find value of greatest internal id
        if greatestclient != nil {
            let gc = greatestclient!
            let i:Int = Int(gc.internalID)
            return i + 1
        } else {
            return 1
        }
    }
    
    public func findClient(internalID:Int) -> ClientModel {
        let workClients:[ClientModel] = clients.filter { $0.internalID == internalID }
        if workClients.count == 1 {
            return workClients[0]
        } else {
            return ClientModel()
        }
    }
    
    public static func clientAny(internalID:Int, lastName:String, firstName:String, middleName:String, suffix:String, street:String, city:String, state:String, zip:String, areacode:String, exchange:String, telnumber:String, note:String, jail:String, representation:[Int]) -> [String:Any] {
        let newClient:[String:Any] = ["internalID":internalID,
                                      "LastName":lastName,
                                      "FirstName":firstName,
                                      "MiddleName":middleName,
                                      "Suffix":suffix,
                                      "Street":street,
                                      "City":city,
                                      "State":state,
                                      "Zip":zip,
                                      "AreaCode":areacode,
                                      "Exchange":exchange,
                                      "TelNumber":telnumber,
                                      "Note":note,
                                      "Jail":jail,
                                      "Representation":representation] as [String : Any]
        return newClient
    }
    
    @MainActor
    func addClient(lastName:String, firstName:String, middleName:String, suffix:String, street:String, city:String, state:String, zip:String, areacode:String, exchange:String, telnumber:String, note:String, jail:String) async -> FunctionReturn {
        
        var rtn:FunctionReturn = FunctionReturn(status: .empty, message: "", additional: 0)
        
        let intID = nextClientID()
        let uc:[String:Any] = CommonViewModel.clientAny(internalID: intID, lastName: lastName, firstName: firstName, middleName: middleName, suffix: suffix, street: street, city: city, state: state, zip: zip, areacode: areacode, exchange: exchange, telnumber: telnumber, note: note, jail: jail, representation: [])

        let reprRef = db.collection("clients")
        
        taskCompleted = false
        
        do {
            try await reprRef.document().setData(uc)
            taskCompleted = true
            rtn.status = .successful
            rtn.message = ""
            return rtn
        }
        catch {
            rtn.status = .IOError
            rtn.message = "Add Client failed: " + error.localizedDescription
            return rtn
        }
    }

/*
    @MainActor
    func addClient(lastName:String, firstName:String, middleName:String, suffix:String, street:String, city:String, state:String, zip:String, areacode:String, exchange:String, telnumber:String, note:String, jail:String) async {
        let intID = nextClientID()
        let ud:[String:Any] = CommonViewModel.clientAny(internalID: intID, lastName: lastName, firstName: firstName, middleName: middleName, suffix: suffix, street: street, city: city, state: state, zip: zip, areacode: areacode, exchange: exchange, telnumber: telnumber, note: note, jail: jail, representation: [])
        //        let db = Firestore.firestore()
        let reprRef = db.collection("clients")
        
        taskCompleted = false
        
        do {
            try await reprRef.document().setData(ud)
            taskCompleted = true
        }
        catch {
            print("Error adding cause \(error.localizedDescription)")
        }
    }
*/
    @MainActor
    func updateClient(clientID:String, internalID:Int, lastName:String, firstName:String, middleName:String, suffix:String, street:String, city:String, state:String, zip:String, areacode:String, exchange:String, telnumber:String, note:String, jail:String, representation:[Int]) async {
        let clientData:[String:Any] = CommonViewModel.clientAny(internalID:internalID, lastName: lastName, firstName: firstName, middleName: middleName, suffix: suffix, street: street, city: city, state: state, zip: zip, areacode: areacode, exchange: exchange, telnumber: telnumber, note: note, jail: jail, representation:representation)
        
        taskCompleted = false
        
        do {
            try await db.collection("clients").document(clientID).updateData(clientData)
            taskCompleted = true
        } catch {
            print("Debug updateClient failed \(error.localizedDescription)")
        }
    }
    
    // MARK: Cause Functions
    
    func causeSubscribe() {
        if causeListener == nil {
            causeListener = db.collection("causes").addSnapshotListener
            { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    return
                }
                self.causes = []
                _ = documents.map { queryDocumentSnapshot -> Void in
                    let data = queryDocumentSnapshot.data()
                    
                    let internalID = data["internalID"] as? Int ?? 0
                    let causeNo = data["CauseNo"] as? String ?? ""
                    let involvedClient = data["InvolvedClient"] as? Int ?? 0
                    let representations = data["Representations"] as? [Int] ?? []
                    let level = data["Level"] as? String ?? ""
                    let court = data["Court"] as? String ?? ""
                    let originalcharge = data["OriginalCharge"] as? String ?? ""
                    let causeType = data["CauseType"] as? String ?? ""
                    
                    let ca:CauseModel = CauseModel(fsid: queryDocumentSnapshot.documentID, client: involvedClient, causeno: causeNo, representations: representations, involvedClient: involvedClient, level: level, court: court, originalcharge: originalcharge, causetype: causeType, intid: internalID)
                    
                    self.causes.append(ca)
                    if ca.internalID == 554 {
                        let debugMsg:String = Date().formatted(Date.FormatStyle().secondFraction(.milliseconds(4)))
                        print("causeSubscribe " + String(ca.internalID) + "; " + ca.causeNo + "; " + String(self.causes.count) + "; " + debugMsg)
                    }
                    return
                }
            }
        }
    }
    
    public func nextCauseID() -> Int {
        // find cause with greatest internal id
        let greatestcause = causes.max {a, b in a.internalID < b.internalID }
        // find value of greatest internal id
        if greatestcause != nil {
            let gc = greatestcause!
            let i:Int = Int(gc.internalID)
            return i + 1
        } else {
            return 1
        }
    }
    
    public func findCause(internalID:Int) -> CauseModel {
        let workCauses:[CauseModel] = causes.filter { $0.internalID == internalID }
        if workCauses.count == 1 {
            return workCauses[0]
        } else {
            return CauseModel()
        }
    }
    
    public static func causeAny(client:Int, causeno:String, representations:[Int], level:String, court: String, originalcharge: String, causetype: String, intid:Int) -> [String:Any] {
        let newCause:[String:Any] =   ["internalID":intid,
                                       "CauseNo":causeno,
                                       "InvolvedClient":client,
                                       "Representations":representations,
                                       "Level":level,
                                       "Court":court,
                                       "OriginalCharge":originalcharge,
                                       "CauseType":causetype
        ]
        return newCause
    }
    
    @MainActor
    func addCause(client:Int, causeno:String, representations:[Int], level:String, court: String, originalcharge: String, causetype: String) async -> FunctionReturn {
        
        var rtn:FunctionReturn = FunctionReturn(status: .empty, message: "", additional: 0)

        let intID = nextCauseID()
        let uc:[String:Any] = CommonViewModel.causeAny(client:client, causeno:causeno, representations:representations, level:level, court:court, originalcharge:originalcharge, causetype:causetype, intid:intID)
        //   let db = Firestore.firestore()
        let reprRef = db.collection("causes")
        
        taskCompleted = false
        
        do {
            try await reprRef.document().setData(uc)
            taskCompleted = true
            rtn.status = .successful
            rtn.message = ""
            return rtn
        }
        catch {
            rtn.status = .IOError
            rtn.message = "Add Cause failed: " + error.localizedDescription
            return rtn
        }
    }

    @MainActor
    func updateCause(causeID:String, client:Int, causeno:String, representations:[Int], level:String, court: String, originalcharge: String, causetype: String, intid:Int) async -> FunctionReturn {
        let causeData:[String:Any] = CommonViewModel.causeAny(client:client, causeno:causeno, representations:representations, level:level, court:court, originalcharge:originalcharge, causetype:causetype, intid:intid)
        
        var rtn:FunctionReturn = FunctionReturn(status: .empty, message: "", additional: 0)

        taskCompleted = false
        
        do {
            try await db.collection("causes").document(causeID).updateData(causeData)
            taskCompleted = true
            rtn.status = .successful
            rtn.message = ""
            return rtn
        } catch {
            rtn.status = .IOError
            rtn.message = "Update Cause failed: " + error.localizedDescription
            return rtn
         }
    }
    
    @MainActor
    func updateCause(causeID:String, updates:[String:Any]) async -> FunctionReturn {
        var rtn:FunctionReturn = FunctionReturn(status: .empty, message: "", additional: 0)

        taskCompleted = false
        
        do {
            try await db.collection("causes").document(causeID).updateData(updates)
            taskCompleted = true
            rtn.status = .successful
            rtn.message = ""
            return rtn
        } catch {
            rtn.status = .IOError
            rtn.message = "Update Cause failed: " + error.localizedDescription
            return rtn
         }
    }

    @MainActor
    func attachCauseToRepresentation(representationID:String, involvedCause:Int, involvedRepresentation:Int) async -> FunctionReturn {
        
        var rtn:FunctionReturn = FunctionReturn(status: .empty, message: "", additional: 0)
        let cm = self.findCause(internalID:involvedCause)
        var repids:[Int] = []
        
//        let reprRef = db.collection("causes")
        
        
        if cm.internalID == 0 {
            rtn.status = .empty
            rtn.message = "Cause does not exist"
            return rtn
        }

        repids = []
        for rep in self.representations.filter({ $0.involvedCause == cm.internalID }) {
            repids.append(rep.internalID)
            print("attachCauseToRepresentation adding ", rep.internalID)
        }
        
        if repids.firstIndex(of: involvedRepresentation) == nil {
            repids.append(involvedRepresentation)
        }
        print("attachCauseToRepresentation repids ", repids)
        
        let uc:[String:Any] = ["Representations":repids]
        
        Task {
            await rtn = self.updateCause(causeID:cm.id ?? "", updates: uc)
            if rtn.status != .successful {
                return rtn
            }
            
            await rtn = self.updateRepresentation(representationID: representationID, involvedCause: cm.internalID, involvedClient: cm.involvedClient)
            
            return rtn
        }
        return rtn
    }
    
    func assembleExpandedCauses() -> Void {
        self.expandedcauses = []
        for ca in self.causes {
            let cl = self.findClient(internalID: ca.involvedClient)
            let xc:ExpandedCause = ExpandedCause(cause: ca, client: cl)
            self.expandedcauses.append(xc)
        }
    }
    
    func assembleExpandedRepresentations() -> Void {
        self.assembleExpandedCauses()
        self.expandedrepresentations = []
        for re in self.representations {
            let xr:ExpandedRepresentation = ExpandedRepresentation()
            xr.representation = re
            let xc = self.expandedcauses.first(where: { $0.cause.internalID == re.involvedCause })
            xr.xpcause = xc ?? ExpandedCause()
            self.expandedrepresentations.append(xr)
        }
    }

    // MARK: Representation Functions

    func representationSubscribe() {
        if representationListener == nil {
            representationListener = db.collection("representations").addSnapshotListener
            { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    return
                }
                self.representations = []
                _ = documents.map { queryDocumentSnapshot -> Void in
                    let data = queryDocumentSnapshot.data()
                    
                    let internalID = data["internalID"] as? Int ?? 0
                    let involvedClient = data["InvolvedClient"] as? Int ?? 0
                    let involvedCause = data["InvolvedCause"] as? Int ?? 0
                    let involvedAppearances = data["InvolvedAppearances"] as? [Int] ?? []
                    let involvedNotes = data["InvolvedNotes"] as? [Int] ?? []
                    let active = data["Active"] as? Bool ?? false               // Open,Closed
                    let assignedDate = data["AssignedDate"] as? String ?? ""
                    let dispositionDate = data["DispositionDate"] as? String ?? ""
                    let dispositionType = data["DispositionType"] as? String ?? ""
                    let dispositionAction = data["DispositionAction"] as? String ?? ""
                    let primaryCategory = data["PrimaryCategory"] as? String ?? ""

                    let rm:RepresentationModel = RepresentationModel(fsid: queryDocumentSnapshot.documentID, intid:internalID, client:involvedClient, cause:involvedCause, appearances:involvedAppearances, notes: involvedNotes, active:active, assigneddate:assignedDate, dispositiondate:dispositionDate, dispositionaction:dispositionAction, dispositiontype:dispositionType, primarycategory: primaryCategory, causemodel: self.findCause(internalID: involvedCause), apprs: self.assembleAppearances(repID: internalID))

                    self.representations.append(rm)
                    let debugMsg:String = Date().formatted(Date.FormatStyle().secondFraction(.milliseconds(4)))
                    if rm.internalID == 254 {
                        print("representationsubscribe " + String(rm.internalID) + "; " + rm.primaryCategory + "; " + rm.involvedAppearances.description + "; " + String(self.representations.count) + "; " + debugMsg)
                    }
                    return
                }
            }
        }
    }

    func nextRepresentationID() -> Int {
        // find cause with greatest internal id
        let greatestrepresentation = representations.max {a, b in a.internalID < b.internalID }
        // find value of greatest internal id
        if greatestrepresentation != nil {
            let gc = greatestrepresentation!
            let i:Int = Int(gc.internalID)
            return i + 1
        } else {
            return 1
        }
    }
    
    public func findRepresentation(internalID:Int) -> RepresentationModel {
        let debugMsg:String = Date().formatted(Date.FormatStyle().secondFraction(.milliseconds(4)))
        print("findRepresentation entered " + debugMsg)
        let workRepresentations:[RepresentationModel] = representations.filter { $0.internalID == internalID }
        if workRepresentations.count == 0 { return RepresentationModel() }
        if workRepresentations.count == 1 {
            let workRep:RepresentationModel = workRepresentations[0]
            workRep.appearances = self.assembleAppearances(repID: workRep.internalID)
            return workRep
        }
        return RepresentationModel()
    }

    func RepresentationAny(internalID:Int, involvedClient:Int, involvedCause:Int, appearances:[Int], notes:[Int], active:Bool, assignedDate:String, dispositionDate:String, dispositionType:String, dispositionAction:String, primaryCategory:String) -> [String:Any] {
        let newRepresentation:[String:Any] = ["internalID":internalID,
                                     "InvolvedClient":involvedClient,
                                     "InvolvedCause":involvedCause,
                                     "InvolvedAppearances":appearances,
                                     "InvolvedNotes":notes,
                                     "Active":active,
                                     "AssignedDate":assignedDate,
                                     "DispositionDate":dispositionDate,
                                     "DispositionType":dispositionType,
                                     "DispositionAction":dispositionAction,
                                     "PrimaryCategory":primaryCategory]
        return newRepresentation
    }
    
    func RepresentationAny(internalID:Int, involvedClient:Int, involvedCause:Int, active:Bool, assignedDate:String, dispositionDate:String, dispositionType:String, dispositionAction:String, primaryCategory:String) -> [String:Any] {
        let newRepresentation:[String:Any] = ["internalID":internalID,
                                     "InvolvedClient":involvedClient,
                                     "InvolvedCause":involvedCause,
                                     "Active":active,
                                     "AssignedDate":assignedDate,
                                     "DispositionDate":dispositionDate,
                                     "DispositionType":dispositionType,
                                     "DispositionAction":dispositionAction,
                                     "PrimaryCategory":primaryCategory]
        return newRepresentation
    }
    
    func RepresentationAny(involvedAppearances:[Int]) -> [String:Any] {
        let newRepresentation:[String:Any] = ["InvolvedAppearances":involvedAppearances]
        return newRepresentation
    }
    
    func RepresentationAny(involvedNotes:[Int]) -> [String:Any] {
        let newRepresentation:[String:Any] = ["InvolvedNotes":involvedNotes]
        return newRepresentation
    }
    
    func RepresentationAny(involvedCause:Int, involvedClient:Int) -> [String:Any] {
        let newRepresentation:[String:Any] = ["InvolvedCause":involvedCause,
                                              "InvolvedClient":involvedClient]
        return newRepresentation
    }

    @MainActor
    func addRepresentation(involvedClient:Int, involvedCause:Int, active:Bool, assignedDate:String, dispositionDate:String, dispositionType:String, dispositionAction:String, primaryCategory:String) async -> FunctionReturn {
        
        var rtn:FunctionReturn = FunctionReturn(status: .empty, message: "", additional: 0)

        let intID = nextRepresentationID()
        let ud:[String:Any] = RepresentationAny(internalID: intID, involvedClient: involvedClient, involvedCause: involvedCause, appearances: [], notes: [], active: active, assignedDate: assignedDate, dispositionDate: dispositionDate, dispositionType: dispositionType, dispositionAction: dispositionAction, primaryCategory: primaryCategory)
        //   let db = Firestore.firestore()
        let reprRef = db.collection("representations")
        
        taskCompleted = false
        
        do {
            try await reprRef.document().setData(ud)
            taskCompleted = true
            rtn.status = .successful
            rtn.message = ""
            rtn.additional = intID
            return rtn
        }
        catch {
            rtn.status = .IOError
            rtn.message = "Error adding Representation:" + error.localizedDescription
            return rtn
        }
    }

    @MainActor
    func updateRepresentation(representationID:String, involvedClient:Int, involvedCause:Int, active:Bool, assignedDate:String, dispositionDate:String, dispositionType:String, dispositionAction:String, primaryCategory:String, intid:Int) async -> FunctionReturn {
        
        var rtn:FunctionReturn = FunctionReturn(status: .empty, message: "", additional: 0)

        let ud:[String:Any] = RepresentationAny(internalID: intid, involvedClient: involvedClient, involvedCause: involvedCause, active: active, assignedDate: assignedDate, dispositionDate: dispositionDate, dispositionType: dispositionType, dispositionAction: dispositionAction, primaryCategory: primaryCategory)
        let debugMsg:String = Date().formatted(Date.FormatStyle().secondFraction(.milliseconds(4)))
        print("update representation, ", representationID, ud, debugMsg)

        taskCompleted = false
        let reprRef = db.collection("representations").document(representationID)
        
        do {
            try await reprRef.setData(ud, merge: true)
            taskCompleted = true
            print("Debug update Representation succeeded")
            rtn.status = .successful
            rtn.message = ""
            let debugMsg:String = Date().formatted(Date.FormatStyle().secondFraction(.milliseconds(4)))
            print("updateRepresentation " + debugMsg)
            return rtn
        } catch {
            print("Debug update Representation failed \(error.localizedDescription)")
            rtn.status = .IOError
            rtn.message = "Update representation failed: " + error.localizedDescription
            let debugMsg:String = Date().formatted(Date.FormatStyle().secondFraction(.milliseconds(4)))
            print("updateRepresentation " + debugMsg)
            return rtn
        }
    }
    
    @MainActor
    func updateRepresentation(representationID:String, involvedappearances:[Int]) async -> FunctionReturn {
        let debugMsg:String = Date().formatted(Date.FormatStyle().secondFraction(.milliseconds(4)))
        print("updateRepresentation entered ", representationID, involvedappearances, debugMsg)
        
        var rtn:FunctionReturn = FunctionReturn(status: .empty, message: "", additional: 0)

        let ud:[String:Any] = RepresentationAny(involvedAppearances: involvedappearances)
        print(representationID, ud)

        taskCompleted = false
        let reprRef = db.collection("representations").document(representationID)
        
        do {
            try await reprRef.setData(ud, merge: true)
            taskCompleted = true
            print("Debug update Representation succeeded")
            rtn.status = .successful
            rtn.message = ""
            return rtn
        } catch {
            print("Debug update Representation failed \(error.localizedDescription)")
            rtn.status = .IOError
            rtn.message = "Update representation failed: " + error.localizedDescription
            return rtn
        }
    }
    
    @MainActor
    func updateRepresentation(representationID:String, involvednotes:[Int]) async -> FunctionReturn {
        print("updateRepresentation - notes entered ", representationID, involvednotes)
        
        var rtn:FunctionReturn = FunctionReturn(status: .empty, message: "", additional: 0)

        let ud:[String:Any] = RepresentationAny(involvedNotes: involvednotes)
        print(representationID, ud)

        taskCompleted = false
        let reprRef = db.collection("representations").document(representationID)
        
        do {
            try await reprRef.setData(ud, merge: true)
            taskCompleted = true
            print("Debug update Representation succeeded")
            rtn.status = .successful
            rtn.message = ""
            return rtn
        } catch {
            print("Debug update Representation failed \(error.localizedDescription)")
            rtn.status = .IOError
            rtn.message = "Update representation failed: " + error.localizedDescription
            return rtn
        }
    }
    
    @MainActor
    func updateRepresentation(representationID:String, involvedCause:Int, involvedClient:Int) async -> FunctionReturn {
//        print("updateRepresentation entered ", representationID, involvednotes)
        
        var rtn:FunctionReturn = FunctionReturn(status: .empty, message: "", additional: 0)

        let ud:[String:Any] = RepresentationAny(involvedCause: involvedCause, involvedClient: involvedClient)
        print(representationID, ud)

        taskCompleted = false
        let reprRef = db.collection("representations").document(representationID)
        
        do {
            try await reprRef.setData(ud, merge: true)
            taskCompleted = true
            print("Debug update Representation succeeded")
            rtn.status = .successful
            rtn.message = ""
            return rtn
        } catch {
            print("Debug update Representation failed \(error.localizedDescription)")
            rtn.status = .IOError
            rtn.message = "Update representation failed: " + error.localizedDescription
            return rtn
        }
    }

    // MARK: Representation Expansion Functions
    
    public func findRepresentationExpansion(internalID:Int) -> RepresentationExpansion {
        let rx = RepresentationExpansion()
        rx.representation = findRepresentation(internalID: internalID)
        rx.client = findClient(internalID: rx.representation.involvedClient)
        rx.cause = findCause(internalID: rx.representation.involvedCause)
        return rx
    }
    
    public func findRepresentationExpansion(representation:RepresentationModel) -> RepresentationExpansion {
        let rx = RepresentationExpansion()
        rx.representation = representation
        rx.client = findClient(internalID: rx.representation.involvedClient)
        rx.cause = findCause(internalID: rx.representation.involvedCause)
        return rx
    }
    
    // MARK: Appearance Functions

    func appearanceSubscribe() {
        if appearanceListener == nil {
            appearanceListener = db.collection("appearances").addSnapshotListener
            { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
//                    self.msgs.append("no appearances")
                    return
                }
                self.appearances = []
                _ = documents.map { queryDocumentSnapshot -> Void in
                    let data = queryDocumentSnapshot.data()
                    
                    let internalID = data["internalID"] as? Int ?? 0
                    let involvedClient = data["InvolvedClient"] as? Int ?? 0
                    let involvedCause = data["InvolvedCause"] as? Int ?? 0
                    let involvedRepresentation = data["InvolvedRepresentation"] as? Int ?? 0
                    let appearDate = data["AppearDate"] as? String ?? ""
                    let appearTime = data["AppearTime"] as? String ?? ""
                    let appearNote = data["AppearNote"] as? String ?? ""
          
                    let am:AppearanceModel = AppearanceModel(fsid: queryDocumentSnapshot.documentID, intid:internalID, client:involvedClient, cause:involvedCause, representation: involvedRepresentation, appeardate:appearDate, appeartime:appearTime, appearnote:appearNote, clientmodel: self.findClient(internalID: involvedClient))
                    self.appearances.append(am)
                    self.setAppearanceTimeStamp()
                    if am.internalID > 550 {
                        let debugMsg:String = self.lastAppearanceUpdate.formatted(Date.FormatStyle().secondFraction(.milliseconds(4)))
                        print("appearancesubscribe " + String(am.internalID) + "; " + am.appearDate + "; " + String(self.appearances.count) + "; " + debugMsg)
                    }
                    return
                }
            }
        }
    }

    func nextAppearanceID() -> Int {
         let greatestappearance = appearances.max {a, b in a.internalID < b.internalID }
        // find value of greatest internal id
        if greatestappearance != nil {
            let gc = greatestappearance!
            let i:Int = Int(gc.internalID)
            return i + 1
        } else {
            return 1
        }
    }

    func AppearanceAny(intid:Int, client:Int, cause:Int, representation:Int, appeardate:String, appeartime:String, appearnote:String) -> [String:Any] {
        let newAppearance:[String:Any] = ["internalID":intid,
                                          "InvolvedClient":client,
                                          "InvolvedCause":cause,
                                          "InvolvedRepresentation":representation,
                                          "AppearDate":appeardate,
                                          "AppearTime":appeartime,
                                          "AppearNote":appearnote]
        return newAppearance
    }
    
    @MainActor
    func addAppearance(involvedClient:Int, involvedCause:Int, involvedRepresentation:Int, appearDate:String, appearTime:String, appearNote:String) async -> FunctionReturn {
        
        var rtn:FunctionReturn = FunctionReturn(status: .empty, message: "", additional: 0)

        let intID = nextAppearanceID()
        let ua:[String:Any] = self.AppearanceAny(intid:intID, client:involvedClient, cause:involvedCause, representation:involvedRepresentation, appeardate:appearDate, appeartime:appearTime, appearnote:appearNote)
        
        let reprRef = db.collection("appearances")
        
        taskCompleted = false
        
        do {
            try await reprRef.document().setData(ua)
            taskCompleted = true
            rtn.status = .successful
            rtn.message = ""
            let debugMsg:String = Date().formatted(Date.FormatStyle().secondFraction(.milliseconds(4)))
            print("addAppearance success " + debugMsg, rtn)
            return rtn
        }
        catch {
            rtn.status = .IOError
            rtn.message = "Update Appearance failed: " + error.localizedDescription
            let debugMsg:String = Date().formatted(Date.FormatStyle().secondFraction(.milliseconds(4)))
            print("addAppearance failure " + debugMsg, rtn)
            return rtn
        }
    }

    @MainActor
    func addAppearanceToRepresentation(representationID:String, involvedClient:Int, involvedCause:Int, involvedRepresentation:Int, appearDate:String, appearTime:String, appearNote:String) async -> FunctionReturn {
        
        var rtn:FunctionReturn = FunctionReturn(status: .empty, message: "", additional: 0)
        var apprs:[AppearanceModel] = []
        var apprids:[Int] = []
        
        Task {
            await rtn = self.addAppearance(involvedClient:involvedClient, involvedCause:involvedCause, involvedRepresentation:involvedRepresentation, appearDate:appearDate, appearTime:appearTime, appearNote:appearNote)
            print("addAppearanceToRepresentation received ", rtn)
            if rtn.status != .successful {
                return rtn
            }
            
            apprs = assembleAppearances(repID:involvedRepresentation)
            apprids = []
            for appr in apprs {
                apprids.append(appr.internalID)
            }

            await rtn = self.updateRepresentation(representationID: representationID, involvedappearances:apprids)
            print("addAppearanceToRepresentation updateRepresentation returned ", rtn)
            return rtn
        }
        return rtn
    }

    @MainActor
    func updateAppearance(appearanceID:String, intID:Int, involvedClient:Int, involvedCause:Int, involvedRepresentation:Int, appearDate:String, appearTime:String, appearNote:String) async -> FunctionReturn {
        
        var rtn:FunctionReturn = FunctionReturn(status: .empty, message: "", additional: 0)

        let ua:[String:Any] = self.AppearanceAny(intid:intID, client:involvedClient, cause:involvedCause, representation:involvedRepresentation, appeardate:appearDate, appeartime:appearTime, appearnote:appearNote)
        
        taskCompleted = false
        let reprRef = db.collection("appearances").document(appearanceID)
        
        do {
            try await reprRef.setData(ua, merge: true)
            taskCompleted = true
            rtn.status = .successful
            rtn.message = ""
            return rtn
        } catch {
            rtn.status = .IOError
            rtn.message = "Update appearance failed: " + error.localizedDescription
            return rtn
        }
    }

    public func assembleAppearances(repID:Int) -> [AppearanceModel] {
        let workAppearances:[AppearanceModel] = appearances.filter { $0.involvedRepresentation == repID }
        return workAppearances.sorted { $0.appearDate < $1.appearDate }
    }

// MARK: Note Functions
    
    func noteSubscribe() {
        if notesListener == nil {
            notesListener = db.collection("notes").addSnapshotListener
            { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    return
                }
                self.notes = []
                _ = documents.map { queryDocumentSnapshot -> Void in
                    let data = queryDocumentSnapshot.data()
                    let internalID = data["internalID"] as? Int ?? 0
                    let involvedClient = data["involvedClient"] as? Int ?? 0
                    let involvedCause = data["involvedCause"] as? Int ?? 0
                    let involvedRepresentation = data["involvedRepresentation"] as? Int ?? 0
                    let noteDate = data["noteDate"] as? String ?? ""
                    let noteTime = data["noteTime"] as? String ?? ""
                    let noteNote = data["noteNote"] as? String ?? ""
                    let noteCategory = data["noteCategory"] as? String ?? ""
          
                    let nm:NotesModel = NotesModel(fsid: queryDocumentSnapshot.documentID, intid:internalID, client:involvedClient, cause:involvedCause, representation:involvedRepresentation, notedate:noteDate, notetime:noteTime, notenote:noteNote, notecat:noteCategory)
                    self.notes.append(nm)
                    let debugMsg:String = Date().formatted(Date.FormatStyle().secondFraction(.milliseconds(4)))
                    print("noteSubscribe " + String(nm.internalID)  + "; " + debugMsg)

                    return
                }
            }
        }
    }

    func nextNoteID() -> Int {
         let greatestnote = notes.max {a, b in a.internalID < b.internalID }
        // find value of greatest internal id
        if greatestnote != nil {
            let gn = greatestnote!
            let i:Int = Int(gn.internalID)
            return i + 1
        } else {
            return 1
        }
    }

    func NoteAny(intid:Int, client:Int, cause:Int, representation:Int, notedate:String, notetime:String, notenote:String, notecategory:String) -> [String:Any] {
        let newNote:[String:Any] = ["internalID":intid,
                                          "involvedClient":client,
                                          "involvedCause":cause,
                                          "involvedRepresentation":representation,
                                          "noteDate":notedate,
                                          "noteTime":notetime,
                                          "noteNote":notenote,
                                          "noteCategory":notecategory]
        return newNote
    }
    
    @MainActor
    func addNote(client:Int, cause:Int, representation:Int, notedate:String, notetime:String, notenote:String, notecategory:String) async -> FunctionReturn {
        
        var rtn:FunctionReturn = FunctionReturn(status: .empty, message: "", additional: 0)

        let intID = nextNoteID()
        
        let un:[String:Any] = self.NoteAny(intid:intID, client:client, cause:cause, representation:representation, notedate:notedate, notetime:notetime, notenote:notenote, notecategory:notecategory)
        
        let reprRef = db.collection("notes")
        
        taskCompleted = false
        
        do {
            try await reprRef.document().setData(un)
            taskCompleted = true
            print("Debug update Note ", rtn)
            rtn.status = .successful
            rtn.message = ""
            print("addNote returning 1: ", rtn)
            return rtn
        }
        catch {
            print("Debug update Note failed \(error.localizedDescription)")
            rtn.status = .IOError
            rtn.message = "Update Note failed: " + error.localizedDescription
            print("addNote returning 2: ", rtn)
            return rtn
        }
    }

    @MainActor
    func addNoteToRepresentation(representationID:String, client:Int, cause:Int, representation:Int, notedate:String, notetime:String, notenote:String, notecategory:String) async -> FunctionReturn {
        
        var rtn:FunctionReturn = FunctionReturn(status: .empty, message: "", additional: 0)
        var notes:[NotesModel] = []
        var noteids:[Int] = []
        
        Task {
            await rtn = self.addNote(client: client, cause: cause, representation: representation, notedate: notedate, notetime: notetime, notenote: notenote, notecategory: notecategory)
            if rtn.status != .successful {
                return rtn
            }
            
            notes = assembleNotes(repID:representation)
            noteids = []
            for note in notes {
                noteids.append(note.internalID)
            }

            await rtn = self.updateRepresentation(representationID: representationID, involvednotes: noteids)
            return rtn
        }
        return rtn
    }

    public func assembleNotes(repID:Int) -> [NotesModel] {
        let workNotes:[NotesModel] = notes.filter { $0.involvedRepresentation == repID }
        return workNotes.sorted { $0.noteDate < $1.noteDate }
    }

// MARK: Time Stamp Functions
    
    func setTimeStamp() -> Void {
        self.lastUpdate = Date()
    }

    func isLater(thisTime:Date) -> Bool {
        if thisTime > lastUpdate { return true }
        return false
    }

    func getTimeStamp() -> Date {
        return self.lastUpdate
    }
    
    func setAppearanceTimeStamp() -> Void {
        self.lastAppearanceUpdate = Date()
    }
    
    func getLastAppearanceTimeStamp() -> Date {
        return self.lastAppearanceUpdate
    }
    
    func appearanceRefreshOverdue(thisTime:Date) -> Bool {
        if self.lastAppearanceUpdate > thisTime { return true }
        return false
    }

}
