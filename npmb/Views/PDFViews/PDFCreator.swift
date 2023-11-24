//
//  PDFDoc.swift
//  npmb
//
//  Created by Morris Albers on 11/14/23.
//

import Foundation
import SwiftUI
import UIKit
import PDFKit

/*
 From https://www.kodeco.com/4023941-creating-a-pdf-in-swift-with-pdfkit?page=1#toc-anchor-002
 */

class PDFCreator: NSObject {
    var npmLines: npmReport = npmReport(npmTitle: "", npmNrPages: 0, npmWaterMark: UIImage(), npmTitleHeight: 0.0, npmTitleBottom: 0.0, npmRawLines: [], npmPrettyLines: [], npmPrettyBlocks: [], npmPages: [])
    
    func setNPMLines(reportLines: npmReport) {
        npmLines = reportLines
        for line in reportLines.npmRawLines {
            let newLines:[npmReport.npmDecoratedLine] = PDFUtility.xlateCC(rawLine: line)
            for newLine in newLines {
                npmLines.npmPrettyLines.append(newLine)
            }
        }
        
        print("done")
    }
    
    func createDocument() -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "PDF Creator",
            kCGPDFContextAuthor: "alberslegal.com",
            kCGPDFContextTitle: npmLines.npmTitle
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
    
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified

        let lineAttributes = [
            NSAttributedString.Key.font: UIFont.monospacedSystemFont(ofSize: 12, weight: UIFont.Weight.regular),
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor : UIColor.systemBlue
        ]

        let attributedLine = NSAttributedString(string: "xx", attributes: lineAttributes)

        let lineStringSize = attributedLine.size()
        
        npmLines.pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        npmLines = addTitle(npmLines: npmLines, sizeOnly: true)
        npmLines.npmPrettyBlocks = PDFUtility.buildPrettyBlocks(inReport: npmLines, lineHeight: lineStringSize.height)
        npmLines.npmPages = PDFUtility.buildPrettyPages(npmBlocks: npmLines.npmPrettyBlocks, pageStart: npmLines.npmTitleBottom, pageHeight: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: npmLines.pageRect, format: format)
        let data = renderer.pdfData { (context) in
            for page in npmLines.npmPages {

                context.beginPage()
                
                npmLines = addTitle(npmLines: npmLines, sizeOnly: false)
                addImage(pageRect: npmLines.pageRect, image: npmLines.npmWaterMark)
                var linePosition:CGFloat = npmLines.npmTitleBottom
                
                for block in page.npmBlocks {
                    for line in block.npmLines {
                        let attributedLine = NSAttributedString(string: line.npmLineText, attributes: lineAttributes)
                        let lineStringSize = attributedLine.size()
                        let lineStringRect = CGRect(x: 36,
                                                    y: linePosition, width: lineStringSize.width,
                                                    height: lineStringSize.height)
                        attributedLine.draw(in: lineStringRect)
                        linePosition = linePosition + lineStringSize.height
                    }
                }
            }
        }
    
        return data
    }
    
    func addTitle(npmLines: npmReport, sizeOnly:Bool) -> npmReport {
        var workLines = npmLines
        
        let fullTitle:String = "Morris E. Albers II, Attorney and Counsellor at Law, PLLC\n" + npmLines.npmTitle
      
        let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
      
        let titleAttributes: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: titleFont]

        let attributedTitle = NSAttributedString(string: fullTitle, attributes: titleAttributes)
      
        let titleStringSize = attributedTitle.size()

        let titleStringRect = CGRect(x: (npmLines.pageRect.width - titleStringSize.width) / 2.0,
                                 y: 36, width: titleStringSize.width,
                                 height: titleStringSize.height)
        
        workLines.npmTitleHeight = titleStringSize.height
        workLines.npmTitleBottom = titleStringRect.origin.y + titleStringRect.size.height * 1.5
        
        if !sizeOnly {
            attributedTitle.draw(in: titleStringRect)
        }

        return workLines
    }

    func addImage(pageRect: CGRect, image:UIImage) {
        let aspectWidth = (pageRect.width - 100) / image.size.width
        let aspectHeight = (pageRect.height - 100) / image.size.height
        let aspectRatio = min(aspectWidth, aspectHeight)

        let scaledWidth = image.size.width * aspectRatio
        let scaledHeight = image.size.height * aspectRatio

        let imageX = (pageRect.width - scaledWidth) / 2.0
        let imageY = (pageRect.height - scaledHeight) / 2.0
        let imageRect = CGRect(x: imageX, y: imageY,
                               width: scaledWidth, height: scaledHeight)

        image.draw(in: imageRect)
    }

/*
 https://koenig-media.raywenderlich.com/uploads/2019/06/centering-text.png?__hstc=149040233.bda537edd3926ebe0df850c73b27e971.1699997779411.1700071592897.1700111052229.4&__hssc=149040233.1.1700111052229&__hsfp=3627516616
 */
}
