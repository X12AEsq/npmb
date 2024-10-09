//
//  SDCause.swift
//  npmb
//
//  Created by Morris Albers on 4/29/24.
//
/*
import Foundation
import SwiftData

@available(iOS 17, *)
@Model
class SDCause {
    var internalID: Int?
    var causeNo: String?
    var causeType: String?           //  Appointed/Private/Family
    var involvedClient: Int?
    var involvedRepresentations: [Int]?
    var level: String?
    var court: String?
    var originalCharge: String?
    var practice: SDPractice?
    
    init(internalID: Int? = nil, causeNo: String? = nil, causeType: String? = nil, involvedClient: Int? = nil, involvedRepresentations: [Int]? = nil, level: String? = nil, court: String? = nil, originalCharge: String? = nil, practice: SDPractice? = nil) {
        self.internalID = internalID
        self.causeNo = causeNo
        self.causeType = causeType
        self.involvedClient = involvedClient
        self.involvedRepresentations = involvedRepresentations
        self.level = level
        self.court = court
        self.originalCharge = originalCharge
        self.practice = practice
    }
    
    @Transient var sortFormat1:String {
        let intID:Int = self.internalID ?? -1
        let part1:String = String(intID)
        let part2:String = FormattingService.rjf(base: part1, len: 4, zeroFill: true)
        let part3:String = FormattingService.ljf(base: self.causeNo ?? "", len:9)
        let part4:String = FormattingService.ljf(base: self.originalCharge ?? "", len:12)
        let part5:String = part3 + "-" + part2 + "-" + part4
        let part6:String = FormattingService.ljf(base: part5, len:30)
        return part6
    }
    
    @Transient var sortFormat2:String {
        let intID:Int = self.internalID ?? -1
        let part1:String = String(intID)
        let part2:String = FormattingService.rjf(base: part1, len: 4, zeroFill: true)
        let part3:String = FormattingService.ljf(base: self.causeNo ?? "", len:9)
        let part4:String = FormattingService.ljf(base: self.originalCharge ?? "", len:12)
        let part5 = part2 + "-" + part3 + "-" + part4
        let part6:String = FormattingService.ljf(base: part5, len:30)
        return part6
    }
}
*/
