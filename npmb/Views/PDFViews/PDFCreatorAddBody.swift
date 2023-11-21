//
//  PDFCreatorAddBody.swift
//  npmb
//
//  Created by Morris Albers on 11/16/23.
//
/*
import Foundation
import UIKit
extension PDFCreator {
    struct bodyLine {
        var line:String
        var linePos:CGFloat
        var lineHei:CGFloat
        
        init(line: String, linePos: CGFloat, lineHei: CGFloat) {
            self.line = line
            self.linePos = linePos
            self.lineHei = lineHei
        }
    }
    
    struct bodyBlock {
        var block:[String]
        var height:CGFloat
        init() {
            self.block = []
            self.height = 0.0
        }
    }
    
    struct pageBlock {
        var pagebodies:[bodyBlock]
        var pagenr:Int
        
        init() {
            self.pagebodies = []
            self.pagenr = 0
        }
    }
    
    func addBodyText (context: UIGraphicsPDFRendererContext, pageRect: CGRect, titleBottom: CGFloat, bodylines: [String]) {
        var doc:[bodyBlock] = []
        var workBlock:bodyBlock = bodyBlock()
        var pageCount:Int = 1;
        var workTitleBottom:CGFloat = titleBottom
//        var pageNumber:Int = 1;
        var spaceHeight:CGFloat = 0.0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        
        let lineAttributes = [
            NSAttributedString.Key.font: UIFont.monospacedSystemFont(ofSize: 12, weight: UIFont.Weight.regular),
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor : UIColor.systemBlue
        ]

        for bl in bodylines {
            let attributedLine = NSAttributedString(string: bl, attributes: lineAttributes)
            if spaceHeight < 0.1 {
                spaceHeight = attributedLine.size().height / 2
            }
            if bl.first == "-" {
                workBlock.block = []
                var work:String = bl
                work.remove(at: work.startIndex)
                workBlock.block.append(work)
                workBlock.height = attributedLine.size().height
                continue
            }
            if bl.first == "+" {
                var work:String = bl
                work.remove(at: work.startIndex)
                workBlock.block.append(work)
                workBlock.height = workBlock.height + attributedLine.size().height
                doc.append(workBlock)
                continue
            }
            var work:String = bl
            work.remove(at: work.startIndex)
            workBlock.block.append(work)
            workBlock.height = workBlock.height + attributedLine.size().height
        }
        
        var currLength:CGFloat = titleBottom - spaceHeight
        var pages:[pageBlock] = []
        var pb:pageBlock = pageBlock()
        for bb in doc {
            pb.pagebodies.append(bb)
            pb.pagenr = pageCount
            if currLength + bb.height + spaceHeight > pageRect.height {
                pageCount = pageCount + 1
                currLength = titleBottom - spaceHeight
                pages.append(pb)
            } else {
                currLength = currLength + bb.height
            }
        }
        
        if pb.pagebodies.count > 0 {
            pages.append(pb)
        }
        
        if pages.count > 0 {
            var nextLine:CGFloat = 0.0
            for pb in pages {
                if pb.pagenr > 1 {
                    context.beginPage()
//                    workTitleBottom = addTitle(pageRect: pageRect)
                    nextLine = workTitleBottom + spaceHeight
//                    addImage(pageRect: pageRect, image: <#UIImage#>)
                }
                for bb in pb.pagebodies {
                    for pl in bb.block {
                        let attributedLine = NSAttributedString(string: pl, attributes: lineAttributes)
                        let lineStringSize = attributedLine.size()
                        let lineStringRect = CGRect(x: 36,
                                                    y: nextLine, width: lineStringSize.width,
                                                     height: lineStringSize.height)
                        attributedLine.draw(in: lineStringRect)
                        nextLine = nextLine + lineStringSize.height
                    }
                }
                print("bb done")
            }
            print("pb done")
        }
        
        print("wait")
/*
        var lineCount:Int = 0
        var nextBlock:CGFloat = titleBottom + 20.0
        for bl in bodylines {
            let attributedLine = NSAttributedString(string: bl, attributes: lineAttributes)
            let lineStringSize = attributedLine.size()
            block.append(bodyLine(line: bl, linePos: nextBlock, lineHei: lineStringSize.height))
            let lineStringRect = CGRect(x: 36,
                                         y: nextBlock, width: lineStringSize.width,
                                         height: lineStringSize.height)
            attributedLine.draw(in: lineStringRect)
            nextBlock = nextBlock + lineStringSize.height
            if nextBlock > pageRect.height {
                print("oops")
            }
            lineCount = lineCount + 1
        }
        print("xxx")
*/
//
//            var bodyRect = CGRect(x: 20, y: ycoord,
//                                  width: pageRect.width - 40 ,height: 20)
//            bl.draw(in: bodyRect, withAttributes: attributes)
//        }
    }
}
*/
