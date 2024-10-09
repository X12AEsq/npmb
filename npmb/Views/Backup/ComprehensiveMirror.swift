//
//  ComprehensiveMirros.swift
//  npmb
//
//  Created by Morris Albers on 2/18/24.
//

import Foundation
struct ComprehensiveMirror: Codable {
    var practicesBackup:[PracticeMirror]
    var clientsBackup:[ClientMirror]
    var causesBackup:[CauseMirror]
    var appearancesBackup:[AppearanceMirror]
}
