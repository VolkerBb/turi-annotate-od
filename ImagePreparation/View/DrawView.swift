//
//  DrawView.swift
//  ImagePreparation
//
//  Created by Volker Bublitz on 16.09.18.
//  Copyright © 2018 Volker Bublitz. All rights reserved.
//

import Cocoa

protocol DrawViewDelegate {
    func drawView(_ drawView: DrawView, didDrawRect rect: NSRect)
    func drawViewShouldStartDrawing(_ drawView: DrawView) -> Bool
}

class DrawView: NSView {
    
    var delegate: DrawViewDelegate?
    var startingPoint = NSPoint.zero
    var endPoint = NSPoint.zero
    
    var path: NSBezierPath = NSBezierPath()
    var rect: NSRect = NSRect.zero
    
    func drawMLRect(rect: NSRect) {
        startingPoint = rect.origin
        endPoint = NSPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height)
        updateMLRect()
    }
    
    override func mouseDown(with event: NSEvent) {
        guard delegate?.drawViewShouldStartDrawing(self) ?? false else {
            return
        }
        startingPoint = convert(event.locationInWindow, from: nil)
        updateMLRect()
    }
    
    override func mouseDragged(with event: NSEvent) {
        guard delegate?.drawViewShouldStartDrawing(self) ?? false else {
            return
        }
        endPoint = convert(event.locationInWindow, from: nil)
        updateMLRect()
    }
    
    override func mouseUp(with event: NSEvent) {
        guard delegate?.drawViewShouldStartDrawing(self) ?? false else {
            return
        }
        let originX = min(startingPoint.x, endPoint.x)
        let originY = min(startingPoint.y, endPoint.y)
        let width = abs(startingPoint.x - endPoint.x)
        let height = abs(startingPoint.y - endPoint.y)
        delegate?.drawView(self, didDrawRect: NSRect(x: originX, y: originY, width: width, height: height))
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        NSColor.black.set()
        
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        path.lineWidth = 2.0
        path.stroke()
    }
    
    private func updateMLRect() {
        path = NSBezierPath()
        path.move(to: startingPoint)
        path.line(to: NSPoint(x: startingPoint.x, y: endPoint.y))
        path.line(to: NSPoint(x: endPoint.x, y: endPoint.y))
        path.line(to: NSPoint(x: endPoint.x, y: startingPoint.y))
        path.line(to: NSPoint(x: startingPoint.x, y: startingPoint.y))
        needsDisplay = true
    }
}
