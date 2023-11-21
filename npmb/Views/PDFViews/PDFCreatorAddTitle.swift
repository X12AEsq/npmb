//
//  PDFCreatorAddTitle.swift
//  npmb
//
//  Created by Morris Albers on 11/20/23.
//
/*
import Foundation
import SwiftUI
import UIKit
import PDFKit

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
*/
