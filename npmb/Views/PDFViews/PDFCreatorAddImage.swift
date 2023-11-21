//
//  PDFCreatorAddImage.swift
//  npmb
//
//  Created by Morris Albers on 11/18/23.
//
/*
import Foundation
import UIKit
extension PDFCreator {

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
}
*/
