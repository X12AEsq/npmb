//
//  npmbApp.swift
//  npmb
//
//  Created by Morris Albers on 2/25/23.
//

import SwiftUI
import FirebaseCore
//import SwiftData

@available(iOS 17.0, *)
@main
struct npmbApp: App {
    @StateObject var CVModel = CommonViewModel()
//    var container: ModelContainer

    init() {
        FirebaseApp.configure()
        
//        do {
//            let config1 = ModelConfiguration(for: SDPractice.self, isStoredInMemoryOnly: false)
//            let config2 = ModelConfiguration(for: SDClient.self, isStoredInMemoryOnly: false)
//
//            container = try ModelContainer(for: SDPractice.self, SDClient.self, configurations: config1, config2)
//        } catch {
//            fatalError("Failed to configure SwiftData container.")
//        }

    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(CVModel)
        }
//        .modelContainer(for: SDPractice.self)
    }
}
