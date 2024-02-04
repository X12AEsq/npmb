//
//  TXTCreator.swift
//  npmb
//
//  Created by Morris Albers on 11/23/23.
//

import Foundation
import SwiftUI

class TXTCreator {
    var textReport: npmReport = npmReport(npmTitle: "", npmNrPages: 0, npmWaterMark: UIImage(), npmTitleHeight: 0.0, npmTitleBottom: 0.0, npmRawLines: [], npmPrettyLines: [], npmPrettyBlocks: [], npmPages: [])
    
    func setNPMLines(reportLines: npmReport) {
        textReport = reportLines
        for line in reportLines.npmRawLines {
            let newLines:[npmReport.npmDecoratedLine] = PDFUtility.xlateCC(rawLine: line)
            for newLine in newLines {
                textReport.npmPrettyLines.append(newLine)
            }
        }
    }
    
    func createDocument() -> npmReport {
        var report:npmReport = textReport
    
//        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let lineHeight = 12
        
//        var pageNumber:Int = 0;
        
        report.npmLinearEquivalent = ""
        
        report = addTitle(inReport: report, lineHeight: CGFloat(lineHeight), sizeOnly: true)
        report.npmPrettyBlocks = PDFUtility.buildPrettyBlocks(inReport: report, lineHeight: CGFloat(lineHeight))
        report.npmPages = PDFUtility.buildPrettyPages(npmBlocks: report.npmPrettyBlocks, pageStart: report.npmTitleBottom, pageHeight: pageHeight)
        
        report.npmLinearEquivalent = ""
        report = addTitle(inReport: report, lineHeight: CGFloat(lineHeight), sizeOnly: false)

        for page in report.npmPages {
            
            report.npmLinearEquivalent = report.npmLinearEquivalent 
                + beginPage()
                + report.npmLinearTitle
            var linePosition:CGFloat = report.npmTitleBottom
            
            for block in page.npmBlocks {
                for line in block.npmLines {
                    report.npmLinearEquivalent = report.npmLinearEquivalent + line.npmLineText + "\n"
                    linePosition = linePosition + CGFloat(lineHeight)
                }
            }
        }
            
        return report
    }
    
    func addTitle(inReport: npmReport, lineHeight: CGFloat, sizeOnly:Bool) -> npmReport {
        var workingReport = inReport
        
        var fullTitle:[String] = []
        fullTitle.append("Morris E. Albers II, Attorney and Counsellor at Law, PLLC")
        fullTitle.append(workingReport.npmTitle)
      
        workingReport.npmTitleHeight = lineHeight * 2.0
        workingReport.npmTitleBottom = workingReport.npmTitleHeight * 1.5
    
        if !sizeOnly {
            workingReport.npmLinearTitle = ""
            for line in fullTitle {
                workingReport.npmLinearTitle = workingReport.npmLinearTitle + line + "\n"
            }
        }

        return workingReport
    }
    
    func beginPage() -> String {
        return "\u{0c}"
    }

}
