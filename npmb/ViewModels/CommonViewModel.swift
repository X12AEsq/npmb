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

    @Published var clients = [ClientModel]()
    @Published var causes = [CauseModel]()

    var clientListener: ListenerRegistration?
    var causeListener: ListenerRegistration?
    
    init() {
        userSession = auth.currentUser
    }
    
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
    func addCause(client:Int, causeno:String, representations:[Int], level:String, court: String, originalcharge: String, causetype: String, intid:Int) async {
       let intID = nextCauseID()
       let ud:[String:Any] = CommonViewModel.causeAny(client:client, causeno:causeno, representations:representations, level:level, court:court, originalcharge:originalcharge, causetype:causetype, intid:intid)
    //   let db = Firestore.firestore()
       let reprRef = db.collection("causes")
       
       taskCompleted = false
       
       do {
          try await reprRef.document().setData(ud)
          taskCompleted = true
       }
       catch {
          print("Error adding Cause \(error.localizedDescription)")
       }
    }

    @MainActor
    func updateCause(causeID:String, client:Int, causeno:String, representations:[Int], level:String, court: String, originalcharge: String, causetype: String, intid:Int) async {
        let causeData:[String:Any] = CommonViewModel.causeAny(client:client, causeno:causeno, representations:representations, level:level, court:court, originalcharge:originalcharge, causetype:causetype, intid:intid)

       taskCompleted = false
       
       do {
          try await db.collection("causes").document(causeID).updateData(causeData)
          taskCompleted = true
          
       } catch {
          print("Debug updateCause failed \(error.localizedDescription)")
       }
    }
    
//    func sortedCauses(option:CauseSortOptions) -> [CauseModel] {
//        switch option {
//        case .byCauseNo:
//            return causes.sorted { $0.causeNo < $1.causeNo }
//        case .byIntID:
//            return causes.sorted { $0.internalID < $1.internalID }
//        }
//    }
}


