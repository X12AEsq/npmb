//
//  PDFUtility.swift
//  npmb
//
//  Created by Morris Albers on 11/23/23.
//

import Foundation
import SwiftUI
import UIKit
import PDFKit

class PDFUtility: NSObject {
    
    public static func xlateCC(rawLine:String) -> [npmReport.npmDecoratedLine] {
        var newLine:npmReport.npmDecoratedLine = npmReport.npmDecoratedLine(npmLineCC: npmReport.CarriageControl.undefined, npmLineText: "", npmLinePosition: 0.0)
        var rtnArray:[npmReport.npmDecoratedLine] = []

        newLine.npmLineText = rawLine
        newLine.npmLineText.remove(at: newLine.npmLineText.startIndex)
        if rawLine.first == "-" {
            newLine.npmLineCC = npmReport.CarriageControl.newblock
            rtnArray.append(newLine)
            return rtnArray
        }
        if rawLine.first == "+" {
            newLine.npmLineCC = npmReport.CarriageControl.newline
            rtnArray.append(newLine)
            return rtnArray
        }
        if rawLine.first == "*" {
            newLine.npmLineCC = npmReport.CarriageControl.subheader
            rtnArray.append(newLine)
            return rtnArray
        }
        newLine.npmLineCC = npmReport.CarriageControl.newline
        rtnArray.append(newLine)
        return rtnArray
    }
    
    public static func buildPrettyBlocks(inReport: npmReport, lineHeight:CGFloat) -> [npmReport.npmBlock] {
        var newReport:npmReport = inReport
        var newBlock:npmReport.npmBlock = npmReport.npmBlock(blockLength: 0.0, npmLines: [])
        var rtnBlocks:[npmReport.npmBlock] = []

        while newReport.npmPrettyLines.count > 0 {
            if newReport.npmPrettyLines[0].npmLineCC == npmReport.CarriageControl.newblock
            || newReport.npmPrettyLines[0].npmLineCC == npmReport.CarriageControl.subheader {
                if newBlock.npmLines.count > 0 {
                    rtnBlocks.append(newBlock)
                }
                if newReport.npmPrettyLines[0].npmLineCC == npmReport.CarriageControl.newblock {
                    newBlock.npmLines = []
                    newBlock.npmLines.append(newReport.npmPrettyLines[0])
                    newBlock.blockLength = lineHeight
                    newReport.npmPrettyLines.remove(at: 0)
                    continue
                } else {
                    newBlock.npmLines = []
                    let newbl:npmReport.npmDecoratedLine = npmReport.npmDecoratedLine(npmLineCC: npmReport.CarriageControl.newline, npmLineText: " ", npmLinePosition: 0.0)
                    var newl:npmReport.npmDecoratedLine = inReport.npmPrettyLines[0]
                    newl.npmLineCC = npmReport.CarriageControl.newline
                    newBlock.npmLines.append(newbl)
                    newBlock.npmLines.append(newl)
                    newBlock.npmLines.append(newbl)
                    newBlock.blockLength = newBlock.blockLength + lineHeight * 3.0
                    rtnBlocks.append(newBlock)
                    newBlock.npmLines = []
                    newReport.npmPrettyLines.remove(at: 0)
                    continue
                }
            }
            if newReport.npmPrettyLines[0].npmLineCC == npmReport.CarriageControl.newline {
                newBlock.blockLength = newBlock.blockLength + lineHeight
                newBlock.npmLines.append(newReport.npmPrettyLines[0])
                newReport.npmPrettyLines.remove(at: 0)
                continue
            }
        }
        
        if newBlock.npmLines.count > 0 {
            rtnBlocks.append(newBlock)
        }
        
        return rtnBlocks
    }
    
    public static func buildPrettyPages(npmBlocks: [npmReport.npmBlock], pageStart:CGFloat, pageHeight:CGFloat) -> [npmReport.npmPage] {
        var newPages: [npmReport.npmPage] = []
        var newPage:npmReport.npmPage = npmReport.npmPage(pageLength: pageStart, npmBlocks: [])
        var prettyBlocks:[npmReport.npmBlock] = npmBlocks

        while prettyBlocks.count > 0 {
            if newPage.pageLength + prettyBlocks[0].blockLength > pageHeight {
                newPages.append(newPage)
                newPage.pageLength = pageStart
                newPage.npmBlocks = []
                newPage.npmBlocks.append(prettyBlocks[0])
                prettyBlocks.remove(at: 0)
                continue
            }
            newPage.pageLength = newPage.pageLength + prettyBlocks[0].blockLength
            newPage.npmBlocks.append(prettyBlocks[0])
            prettyBlocks.remove(at: 0)
        }
        
        if newPage.npmBlocks.count > 0 {
            newPages.append(newPage)
        }
        
        return newPages
    }
}
