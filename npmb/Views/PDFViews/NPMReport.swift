//
//  NPMReport.swift
//  npmb
//
//  Created by Morris Albers on 11/19/23.
//

import Foundation
import UIKit
import PDFKit

struct npmReport {
    enum CarriageControl {
        case newpage
        case newblock
        case newline
        case subtitle
        case subheader
        case undefined
    }
    
    var npmTitle:String
    var npmNrPages:Int
    var npmWaterMark:UIImage
    
    var npmTitleHeight:CGFloat
    var npmTitleBottom:CGFloat
    
    var npmRawLines:[String]
    var npmPrettyLines:[npmDecoratedLine]
    var npmPrettyBlocks:[npmBlock]
    var npmPages:[npmPage]
    
    var npmLinearEquivalent:String = ""
    var npmLinearTitle:String = ""
    
    var pageRect:CGRect = CGRect()
    
    struct npmPage {
        var pageLength:CGFloat
        var npmBlocks:[npmBlock]
        
        init(pageLength:CGFloat, npmBlocks: [npmBlock]) {
            self.pageLength = pageLength
            self.npmBlocks = npmBlocks
        }
    }
    
    struct npmBlock {
        var blockLength:CGFloat
        var npmLines:[npmDecoratedLine]
        
        init(blockLength:CGFloat, npmLines: [npmDecoratedLine]) {
            self.blockLength = blockLength
            self.npmLines = npmLines
        }
    }
    
    struct npmDecoratedLine {
        var npmLineCC:CarriageControl
        var npmLineText:String
        var npmLinePosition:CGFloat
        
        init(npmLineCC: CarriageControl, npmLineText: String, npmLinePosition: CGFloat) {
            self.npmLineCC = npmLineCC
            self.npmLineText = npmLineText
            self.npmLinePosition = npmLinePosition
        }
    }
    
    init(npmTitle: String, npmNrPages: Int, npmWaterMark: UIImage, npmTitleHeight: CGFloat, npmTitleBottom:CGFloat, npmRawLines: [String], npmPrettyLines: [npmDecoratedLine], npmPrettyBlocks: [npmBlock], npmPages: [npmPage]) {
        self.npmTitle = npmTitle
        self.npmNrPages = npmNrPages
        self.npmWaterMark = npmWaterMark
        self.npmTitleHeight = npmTitleHeight
        self.npmTitleBottom = npmTitleBottom
        self.npmRawLines = npmRawLines
        self.npmPrettyLines = npmPrettyLines
        self.npmPrettyBlocks = npmPrettyBlocks
        self.npmPages = npmPages
    }
    
}
