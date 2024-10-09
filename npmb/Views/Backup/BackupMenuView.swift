//
//  BackupMenuView.swift
//  npmb
//
//  Created by Morris Albers on 6/14/23.
//

import SwiftUI

struct BackupMenuView: View {
    @EnvironmentObject var CVModel:CommonViewModel
    @State private var showingBackupToJSON = false
    @State private var showingBackupClient = false
    @State private var showingBackupCause = false
    @State private var showingBackupRepresentation = false
    @State private var showingBackupAppearance = false
    @State private var showingBackupNotes = false
    @State private var showingBackupPractice = false
    var body: some View {
        VStack (alignment: .center) {
            Button {
                showingBackupToJSON.toggle()
            } label: {
                Text("Backup to JSON")
            }
            .buttonStyle(CustomNarrowButton())
            .sheet(isPresented: $showingBackupToJSON, onDismiss: {
                print("Dismissed")
            })
            { BackupToJSON() }
                
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
                showingBackupPractice.toggle()
            } label: {
                Text("Backup Practice")
            }
            .buttonStyle(CustomNarrowButton())
            .sheet(isPresented: $showingBackupPractice, onDismiss: {
                print("Dismissed")
            })
            { BackupPractice() }

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
                showingBackupNotes.toggle()
            } label: {
                Text("Backup Notes")
            }
            .buttonStyle(CustomNarrowButton())
            .sheet(isPresented: $showingBackupNotes, onDismiss: {
                print("Dismissed")
            })
            { BackupNotes() }

            Button {
                showingBackupAppearance.toggle()
            } label: {
                Text("Backup Appearancess")
            }
            .buttonStyle(CustomNarrowButton())
            .sheet(isPresented: $showingBackupAppearance, onDismiss: {
                print("Dismissed")
            })
            { BackupAppearance() }

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
