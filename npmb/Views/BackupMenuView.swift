//
//  BackupMenuView.swift
//  npmb
//
//  Created by Morris Albers on 6/14/23.
//

import SwiftUI

struct BackupMenuView: View {
    @EnvironmentObject var CVModel:CommonViewModel
    @State private var showingBackupClient = false
    @State private var showingBackupCause = false
    @State private var showingBackupRepresentation = false
    var body: some View {
        VStack (alignment: .center) {
            Button {
                showingBackupClient.toggle()
            } label: {
                Text("Backup Clients")
            }
            .buttonStyle(CustomNarrowButton())
            .sheet(isPresented: $showingBackupClient, onDismiss: {
                print("Dismissed")
            })
            { BackupClient() }

            Button {
                showingBackupCause.toggle()
            } label: {
                Text("Backup Causes")
            }
            .buttonStyle(CustomNarrowButton())
            .sheet(isPresented: $showingBackupCause, onDismiss: {
                print("Dismissed")
            })
            { BackupCause() }

            Button {
                showingBackupRepresentation.toggle()
            } label: {
                Text("Backup Representations")
            }
            .buttonStyle(CustomNarrowButton())
            .sheet(isPresented: $showingBackupRepresentation, onDismiss: {
                print("Dismissed")
            })
            { BackupRepresentation() }

            Spacer()
        }
    }
}

//struct BackupMenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        BackupMenuView()
//    }
//}
