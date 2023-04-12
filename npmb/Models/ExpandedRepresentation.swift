//
//  ExpandedRepresentation.swift
//  npmb
//
//  Created by Morris Albers on 4/4/23.
//

import Foundation
class ExpandedRepresentation: Identifiable {
    static func == (lhs: ExpandedRepresentation, rhs: ExpandedRepresentation) -> Bool {
        lhs.representation.internalID == rhs.representation.internalID
    }
    var representation:RepresentationModel
    var xpcause:ExpandedCause
    var appearances:[AppearanceModel]
    var notes:[NotesModel]
    
    init() {
        self.representation = RepresentationModel()
        self.xpcause = ExpandedCause()
        self.appearances = [AppearanceModel]()
        self.notes = [NotesModel]()
    }
}
