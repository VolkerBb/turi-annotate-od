//
//  Document.swift
//  ImagePreparation
//
//  Created by Volker Bublitz on 22.09.18.
//  Copyright © 2018 vobu. All rights reserved.
//

import Cocoa
import SSZipArchive

class Document: NSDocument {
    
    var impSet:IMPSet
    
    override init() {
        let workFolder = FileHelper.workFolderURL()
        let imageFolder = FileHelper.workImagesUrl(workFolder: workFolder)
        impSet = IMPSet(workFolder: workFolder, imageFolder: imageFolder, annotations: Annotations(path: [], annotations: []))
        super.init()
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
        self.addWindowController(windowController)
        // Set represented object of ViewController
        if let viewController: ViewController = windowController.contentViewController as! ViewController? {
            viewController.representedObject = self
            viewController.select(index: 0)
        }
    }
    
    override func write(to url: URL, ofType typeName: String) throws {
        try JSONEncoder().encode(impSet.annotations).write(to: FileHelper.annotationsUrl(workFolder: impSet.workFolder))
        SSZipArchive.createZipFile(atPath: url.path, withContentsOfDirectory: impSet.workFolder.path)
    }
    
    override func read(from url: URL, ofType typeName: String) throws {
        SSZipArchive.unzipFile(atPath: url.path, toDestination: impSet.workFolder.path)
        guard FileManager.default.fileExists(atPath: impSet.imageFolder.path) else {
            try? FileManager.default.removeItem(at: impSet.workFolder)
            throw NSError(domain: NSCocoaErrorDomain, code: NSFileReadUnsupportedSchemeError, userInfo: nil)
        }
        let jsonUrl = FileHelper.annotationsUrl(workFolder: impSet.workFolder)
        let annotations:Annotations = try JSONDecoder().decode(Annotations.self, from: Data(contentsOf: jsonUrl))
        impSet.annotations = annotations
    }

    override func close() {
        super.close()
        try? FileManager.default.removeItem(at: impSet.workFolder)
    }
}

