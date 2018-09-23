//
//  NSImage+Resize.swift
//  ImagePreparation
//
//  Created by Volker Bublitz on 16.09.18.
//  Copyright © 2018 Volker Bublitz. All rights reserved.
//

import Cocoa

extension NSImage {
    
    func resizedImage(w: CGFloat, h: CGFloat) -> NSImage {
        let destSize = NSMakeSize(w, h)
        let newImage = NSImage(size: destSize)
        newImage.lockFocus()
        self.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, self.size.width, self.size.height), operation: .destinationOver, fraction: CGFloat(1))
        newImage.unlockFocus()
        return newImage
    }
    
    func writeToFile(file: URL, usingType type: NSBitmapImageRep.FileType) {
        let properties = [NSBitmapImageRep.PropertyKey.compressionFactor: 1.0]
        guard
            let imageData = tiffRepresentation,
            let imageRep = NSBitmapImageRep(data: imageData),
            let fileData = imageRep.representation(using: type, properties: properties) else {
                return
        }
        try? fileData.write(to: file)
    }
    
    func pixelSize() -> NSSize {
        guard let h = representations.first?.pixelsHigh,
            let w = representations.first?.pixelsWide else {
                return size
        }
        return NSSize(width: w, height: h)
    }
    
}
