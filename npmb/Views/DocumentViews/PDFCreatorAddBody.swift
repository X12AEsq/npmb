//
//  PDFCreatorAddBody.swift
//  npmb
//
//  Created by Morris Albers on 11/16/23.
//

import Foundation
import UIKit
extension PDFCreator {
    func addBodyText (bodylines:[String]) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        
        let attributes = [
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.font: UIFont.monospacedSystemFont(ofSize: 12, weight: UIFont.Weight.regular),
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor : UIColor.systemBlue
        ]
        
//        var bodyRect = CGRect(x: 20, y: 70,
//                              width: pageRect.width - 40 ,height: pageRect.height - 80)
        var lineCount:Int = 0
        var ycoord:Int = self.bodyY
//        if self.subTitle.count > 0 {
//            for tl in self.subTitle {
//                var xcoord:Int = self.bodyX
//                let l:Int = tl.count
//                var i:Int = 0
//                var bodyRect:CGRect = CGRect()
//                while i < l {
//                    let s:String = tl
//                    let j = s.index(s.startIndex, offsetBy: i)
//                    bodyRect = CGRect(x: xcoord, y: ycoord, width: self.charWidth, height: self.charHeight)
//                    let y = String(s[j])
//                    y.draw(in:bodyRect, withAttributes: attributes)
//                    i = i + 1
//                    xcoord = xcoord + self.lineHeight
//                }
//                ycoord = ycoord + self.charSpace
//                lineCount = lineCount + 1
//            }
//        }
        for bl in bodylines {
            var xcoord:Int = self.bodyX
            let l:Int = bl.count
            var i:Int = 0
            var bodyRect:CGRect = CGRect()
            while i < l {
                let s:String = bl
                let j = s.index(s.startIndex, offsetBy: i)
                bodyRect = CGRect(x: xcoord, y: ycoord, width: self.charWidth, height: self.charHeight)
                let y = String(s[j])
                y.draw(in:bodyRect, withAttributes: attributes)
                i = i + 1
                xcoord = xcoord + self.lineHeight
            }
            ycoord = ycoord + self.charSpace
            lineCount = lineCount + 1
        }
        print("xxx")
        
//
//            var bodyRect = CGRect(x: 20, y: ycoord,
//                                  width: pageRect.width - 40 ,height: 20)
//            bl.draw(in: bodyRect, withAttributes: attributes)
//        }
    }
}
