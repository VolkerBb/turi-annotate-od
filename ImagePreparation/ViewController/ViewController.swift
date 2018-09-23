//
//  ViewController.swift
//  ImagePreparation
//
//  Created by Volker Bublitz on 22.09.18.
//  Copyright © 2018 vobu. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, DrawViewDelegate {

    var document:Document?
    private var currentIndex = 0
    
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var drawView: DrawView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawView.delegate = self

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
            document = representedObject as? Document
        }
    }
    
    private func updateUI() {
        guard let path = document?.impSet.annotations.path[currentIndex],
            let realP = realPath(mlPath: path),
            let image = NSImage(contentsOfFile: realP),
            let annotation = document?.impSet.annotations.annotations[currentIndex] else {
                return
        }
        imageView.image = image
        textField.stringValue = annotation.label
        
        let imageRect = self.imageView.photoRectInImageView()
        let pixelSize = image.pixelSize()
        
        let scale = Double(pixelSize.width / imageRect.size.width)
        let oX = annotation.coordinates.x / scale
        let oY = (Double(pixelSize.height) - annotation.coordinates.y) / scale
        let oWidth = annotation.coordinates.width / scale
        let oHeight = annotation.coordinates.height / scale
        
        let rectX = Double(imageRect.origin.x) + (oX - oWidth / 2.0)
        let rectY = Double(imageRect.origin.y) + (oY - oHeight / 2.0)
        let rect = NSRect(x: rectX, y: rectY, width: oWidth, height: oHeight)
        
        self.drawView.drawMLRect(rect: rect)
    }
    
    private func realPath(mlPath: String) -> String? {
        guard let basePath = document?.impSet.workFolder.path else {
            return nil
        }
        return basePath + "/" + mlPath
    }

    //MARK: - Actions
    
    @IBAction func nextClicked(_ sender: Any) {
        updateLabel()
        guard currentIndex < (document?.impSet.annotations.path.count ?? 0) - 1 else {
            currentIndex = 0
            updateUI()
            return
        }
        currentIndex = currentIndex + 1
        updateUI()
    }
    
    @IBAction func previousClicked(_ sender: Any) {
        updateLabel()
        guard currentIndex > 0 else {
            currentIndex = (document?.impSet.annotations.path.count ?? 1) - 1
            updateUI()
            return
        }
        currentIndex = currentIndex - 1
        updateUI()
    }
    
    private func updateLabel() {
        if document?.impSet.annotations.annotations.count ?? 0 > currentIndex {
            document?.impSet.annotations.annotations[currentIndex].label = textField.stringValue
        }
    }
    
    // MARK: - Delegates
    
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        document?.impSet.annotations.annotations[currentIndex].label = textField.stringValue
        return true
    }
    
    func drawViewShouldStartDrawing(_ drawView: DrawView) -> Bool {
        return document?.impSet.annotations.path.count ?? 0 > currentIndex
    }
    
    func drawView(_ drawView: DrawView, didDrawRect rect: NSRect) {
        updateLabel()
        guard let path = document?.impSet.annotations.path[currentIndex],
            let realP = realPath(mlPath: path),
            let image = NSImage(contentsOfFile: realP) else {
                return
        }
        let imageRect = imageView.photoRectInImageView()
        let pX = Double(rect.origin.x - imageRect.origin.x)
        let pY = Double(rect.origin.y - imageRect.origin.y)
        let pixelSize = image.pixelSize()
        let scale = Double(pixelSize.width / imageRect.size.width)
        let mlX = pX * scale
        let mlY = pY * scale
        let mlWidth = Double(rect.width) * scale
        let mlHeight = Double(rect.height) * scale
        let mlCenterX = mlX + mlWidth / 2.0
        let mlCenterY = mlY + mlHeight / 2.0
        document?.impSet.annotations.annotations[currentIndex].coordinates.height = mlHeight
        document?.impSet.annotations.annotations[currentIndex].coordinates.width = mlWidth
        document?.impSet.annotations.annotations[currentIndex].coordinates.x = mlCenterX
        document?.impSet.annotations.annotations[currentIndex].coordinates.y = Double(pixelSize.height) - mlCenterY
    }
    
    func select(index: Int) {
        guard document?.impSet.annotations.path.count ?? 0 > index else {
            return
        }
        currentIndex = index
        updateUI()
    }

}

