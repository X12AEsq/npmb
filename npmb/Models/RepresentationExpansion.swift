//
//  RepresentationExpansion.swift
//  npmb
//
//  Created by Morris Albers on 3/9/23.
//

import Foundation
class RepresentationExpansion: Identifiable, Codable, ObservableObject {
    var representation:RepresentationModel
    var client:ClientModel
    var cause:CauseModel
    
    init() {
        self.representation = RepresentationModel()
        self.client = ClientModel()
        self.cause = CauseModel()
    }
    
    init(rm:RepresentationModel) {
        self.representation = rm
        self.client = ClientModel()
        self.cause = CauseModel()
    }
}
