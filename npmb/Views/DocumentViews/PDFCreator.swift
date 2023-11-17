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
    let title: String
    let body: [String]
    var bodyX:Int = 20
    var bodyY:Int = 70
    var charHeight:Int = 20
    var charWidth:Int = 15
    var lineHeight:Int = 6
    var charSpace:Int = 15  // controls line spacking

//  let image: UIImage
//  let contactInfo: String
  
//  init(title: String, body: String, image: UIImage, contact: String) {
init(title: String, body: [String]) {
    self.title = title
    self.body = body
//    self.image = image
//    self.contactInfo = contact
  }
  
  func createDocument() -> Data {
/*
 1:Create a dictionary with the PDF’s metadata using predefined keys. You can find the full list of keys in Apple’s Auxiliary Dictionary Keys documentation. To set the metadata, you create UIGraphicsPDFRendererFormat object and assign the dictionary to documentInfo.
 */
    let pdfMetaData = [
      kCGPDFContextCreator: "PDF Creator",
      kCGPDFContextAuthor: "alberslegal.com",
      kCGPDFContextTitle: title
    ]
    let format = UIGraphicsPDFRendererFormat()
    format.documentInfo = pdfMetaData as [String: Any]
    
/*
 2: Recall that PDF files use a coordinate system with 72 points per inch. To create a PDF document with a specific size, multiply the size in inches by 72 to get the number of points. Here, you’ll use 8.5 x 11 inches, because that’s the standard U.S. letter size. You then create a rectangle of the size you just calculated.
 
 The PDF coordinates and Core Graphics share the same point size, but coordinates for a Core Graphics context begin at the top left corner ([0,0]) and increase down and to the right.
 */
    let pageWidth = 8.5 * 72.0
    let pageHeight = 11 * 72.0
    let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
    
/*
 
 3: UIGraphicsPDFRenderer(bounds:format:) creates a PDFRenderer object with the dimensions of the rectangle and the format containing the metadata.
 */
    let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
/*
 4: pdfData(actions:) includes a block where you create the PDF. The renderer creates a Core Graphics context that becomes the current context within the block. Drawing done on this context will appear on the PDF.
 */
    let data = renderer.pdfData { (context) in
/*
 5: context.beginPage() starts a new PDF page. You must call beginPage() one time before giving any other drawing instructions. You can call it again to create multi-page PDF documents.
 */
      context.beginPage()
/*
 6: Using draw(at:withAttributes:) on a String draws the string to the current context. You set the size of the string to 72 points. (Modified from original example)
 
        let attributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 72)
            ]
        let text = "I'm a PDF!"
        text.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
*/
        let titleBottom = addTitle(pageRect: pageRect)
        self.bodyY = Int(titleBottom + 0.5) + self.charHeight
/*
      let imageBottom = addImage(pageRect: pageRect, imageTop: titleBottom + 18.0)
 */
//      addBodyText(pageRect: pageRect, textTop: imageBottom + 18.0)
//        addBodyText(pageRect: pageRect, textTop: titleBottom + 18.0)
        addBodyText(bodylines: body)
/*
      let context = context.cgContext
      drawTearOffs(context, pageRect: pageRect, tearOffY: pageRect.height * 4.0 / 5.0, numberTabs: 8)
      drawContactLabels(context, pageRect: pageRect, numberTabs: 8)
 */
    }
    
    return data
  }
  
  func addTitle(pageRect: CGRect) -> CGFloat {
      let fullTitle:String = "Morris E. Albers II, Attorney and Counsellor at Law, PLLC\n" + title
/*
 1: You create an instance of the system font that has a size of 18 points and is in bold.
 */
      
    let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
/*
 2: You create an attributes dictionary and set the NSAttributedString.Key.font key to this font.
 */
      
    let titleAttributes: [NSAttributedString.Key: Any] =
      [NSAttributedString.Key.font: titleFont]
/*
 3: Then, you create NSAttributedString containing the text of the title in the chosen font.
 */

    let attributedTitle = NSAttributedString(string: fullTitle, attributes: titleAttributes)
/*
 4: Using size() on the attributed string returns a rectangle with the size the text will occupy in the current context.
 */
      
    let titleStringSize = attributedTitle.size()
/*
 5: You now create a rectangle 36 points from the top of the page which horizontally centers the title on the page. The figure below shows how to calculate the x coordinate needed to center the text.
 */

    let titleStringRect = CGRect(x: (pageRect.width - titleStringSize.width) / 2.0,
                                 y: 36, width: titleStringSize.width,
                                 height: titleStringSize.height)
/*
 6: Using draw(in:) on NSAttributedString draws it inside the rectangle.
 */
      
    attributedTitle.draw(in: titleStringRect)
/*
 7: This code adds the y coordinate of the rectangle to the height of the rectangle to find the coordinate of the bottom of the rectangle, as shown in the following figure. The code then returns this coordinate to the caller.
 https://koenig-media.raywenderlich.com/uploads/2019/06/centering-text.png?__hstc=149040233.bda537edd3926ebe0df850c73b27e971.1699997779411.1700071592897.1700111052229.4&__hssc=149040233.1.1700111052229&__hsfp=3627516616
 */
    return titleStringRect.origin.y + titleStringRect.size.height
  }

//    func addBodyText(pageRect: CGRect, textTop: CGFloat) {
//        let textFont = UIFont.monospacedSystemFont(ofSize: 12.0, weight: .regular)
///*
//1: You create an NSMutableParagraphStyle object to define how text should flow and wrap. Natural alignment sets the alignment based on the localization of the app. Lines are set to wrap at word breaks.
//*/
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .natural
//        paragraphStyle.lineBreakMode = .byWordWrapping
///*
//2: The dictionary holds the text attributes that set the paragraph style in addition to the font. You create an NSAttributedString that combines the text and formatting, just like you did with the title.
//*/
//        let textAttributes = [
//            NSAttributedString.Key.paragraphStyle: paragraphStyle,
//            NSAttributedString.Key.font: textFont
//        ]
//        let attributedText = NSAttributedString(string: body, attributes: textAttributes)
///*
//3: The rectangle for the text is a little different. It offsets 10 points from the left and sets the top at the passed value. The width is set to the width of the page minus a margin of 10 points on each side. The height is the distance from the top to 1/5 of the page height from the bottom.
//*/
//        let textRect = CGRect(x: 10, y: textTop, width: pageRect.width - 20,
//                          height: pageRect.height - textTop - pageRect.height / 5.0)
//        attributedText.draw(in: textRect)
//    }
/*
  func addImage(pageRect: CGRect, imageTop: CGFloat) -> CGFloat {
    // 1
    let maxHeight = pageRect.height * 0.4
    let maxWidth = pageRect.width * 0.8
    // 2
    let aspectWidth = maxWidth / image.size.width
    let aspectHeight = maxHeight / image.size.height
    let aspectRatio = min(aspectWidth, aspectHeight)
    // 3
    let scaledWidth = image.size.width * aspectRatio
    let scaledHeight = image.size.height * aspectRatio
    // 4
    let imageX = (pageRect.width - scaledWidth) / 2.0
    let imageRect = CGRect(x: imageX, y: imageTop,
                           width: scaledWidth, height: scaledHeight)
    // 5
    image.draw(in: imageRect)
    return imageRect.origin.y + imageRect.size.height
  }
  
  // 1
  func drawTearOffs(_ drawContext: CGContext, pageRect: CGRect,
                    tearOffY: CGFloat, numberTabs: Int) {
    // 2
    drawContext.saveGState()
    drawContext.setLineWidth(2.0)
    
    // 3
    drawContext.move(to: CGPoint(x: 0, y: tearOffY))
    drawContext.addLine(to: CGPoint(x: pageRect.width, y: tearOffY))
    drawContext.strokePath()
    drawContext.restoreGState()
    
    // 4
    drawContext.saveGState()
    let dashLength = CGFloat(72.0 * 0.2)
    drawContext.setLineDash(phase: 0, lengths: [dashLength, dashLength])
    // 5
    let tabWidth = pageRect.width / CGFloat(numberTabs)
    for tearOffIndex in 1..<numberTabs {
      // 6
      let tabX = CGFloat(tearOffIndex) * tabWidth
      drawContext.move(to: CGPoint(x: tabX, y: tearOffY))
      drawContext.addLine(to: CGPoint(x: tabX, y: pageRect.height))
      drawContext.strokePath()
    }
    // 7
    drawContext.restoreGState()
  }
*/
/*
  func drawContactLabels(_ drawContext: CGContext, pageRect: CGRect, numberTabs: Int) {
    let contactTextFont = UIFont.systemFont(ofSize: 10.0, weight: .regular)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .natural
    paragraphStyle.lineBreakMode = .byWordWrapping
    let contactBlurbAttributes = [
      NSAttributedString.Key.paragraphStyle: paragraphStyle,
      NSAttributedString.Key.font: contactTextFont
    ]
    let attributedContactText = NSMutableAttributedString(string: contactInfo, attributes: contactBlurbAttributes)
    // 1
    let textHeight = attributedContactText.size().height
    let tabWidth = pageRect.width / CGFloat(numberTabs)
    let horizontalOffset = (tabWidth - textHeight) / 2.0
    drawContext.saveGState()
    // 2
    drawContext.rotate(by: -90.0 * CGFloat.pi / 180.0)
    for tearOffIndex in 0...numberTabs {
      let tabX = CGFloat(tearOffIndex) * tabWidth + horizontalOffset
      // 3
      attributedContactText.draw(at: CGPoint(x: -pageRect.height + 5.0, y: tabX))
    }
    drawContext.restoreGState()
  }
 */
}
/*
struct PDFKitView: UIViewRepresentable {
    public var documentData: Data?

    func makeUIView(context: UIViewRepresentableContext<PDFKitView>) -> PDFView {
        // Creating a new PDFVIew and adding a document to it
        let pdfView = PDFView()
//        pdfView.document = PDFDocument(data: documentData)
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: UIViewRepresentableContext<PDFKitView>) {
        // TODO
    }
}
*/
/*
 let pdfCreator = PDFCreator(title: title, body: body, image: image, contact: contact)
 let pdfData = pdfCreator.createFlyer()

 */
