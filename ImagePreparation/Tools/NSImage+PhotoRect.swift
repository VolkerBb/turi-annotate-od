//
//  NSImage+PhotoRect.swift
//  ImagePreparation
//
//  Created by Volker Bublitz on 16.09.18.
//  Copyright © 2018 Volker Bublitz. All rights reserved.
//

import Cocoa

extension NSImageView {
    
    func photoReduction() -> CGFloat {
        guard let size = self.image?.size else {
            return 1.0
        }
        let iFrame = self.bounds
        let xRatio = NSWidth(iFrame)/size.width
        let yRatio = NSHeight(iFrame)/size.height
        return min(xRatio, yRatio)
    }
    
    func photoRectInImageView() -> NSRect {
        guard let size = self.image?.size else {
            return NSRect.zero
        }
        let iBounds = self.bounds
        let reduction = self.photoReduction()
        let width = size.width * reduction
        let height = size.height * reduction
        let x = (iBounds.size.width - width)/2.0
        let y = (iBounds.size.height - height)/2.0
        return NSRect(x: x, y: y, width: width, height: height)
    }
    
}
