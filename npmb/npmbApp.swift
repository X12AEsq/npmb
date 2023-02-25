//
//  npmbApp.swift
//  npmb
//
//  Created by Morris Albers on 2/25/23.
//

import SwiftUI
import FirebaseCore

@main
struct npmbApp: App {
    @StateObject var CVModel = CommonViewModel()
    
    init() {
        FirebaseApp.configure()

    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(CVModel)
        }
    }
}
