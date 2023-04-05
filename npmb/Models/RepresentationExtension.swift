//
//  RepresentationExtension.swift
//  npmb
//
//  Created by Morris Albers on 4/1/23.
//

import Foundation
extension RepresentationModel {
    public var DateAssigned:Date {
        return DateService.dateString2Date(inDate: self.assignedDate)
    }
    
    public var DateDisposed:Date {
        return DateService.dateString2Date(inDate: self.dispositionDate)
    }
    
}
