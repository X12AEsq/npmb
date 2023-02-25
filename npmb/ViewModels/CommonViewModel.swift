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

class CommonViewModel: ObservableObject {
    
    private let db = Firestore.firestore()
    
    let auth = Auth.auth()
    
    @Published var taskCompleted = false
    
    @Published var userSession: FirebaseAuth.User?
    
    @Published var clients = [ClientModel]()
//    @Published var expenses = [Expense]()
//    
    var clientListener: ListenerRegistration?
//    var expenseListener: ListenerRegistration?
    
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
//                    self.msgs.append("No clients")
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
//                    print("about to add client \(cl.internalID) \(cl.lastName) \(cl.firstName) \(cl.middleName) \(cl.suffix) \(cl.street) \(cl.city) \(cl.zip) \(cl.phone)  \(cl.note) \(cl.representationID)")
                    self.clients.append(cl)
//                    print("\(cl.internalID) returned, count = \(self.clients.count)")
                    return
                }
//                print("\(self.clients.count) clients recovered")
            }
//            print("data recovered?")
        }
//        print("clientSubscribe complete \(self.clients.count) records")
    }
}

