//
//  ViewController+Actions.swift
//  ImagePreparation
//
//  Created by Volker Bublitz on 22.09.18.
//  Copyright © 2018 vobu. All rights reserved.
//

import Cocoa

extension ViewController {

    @IBAction func importImages(_ sender: Any?) {
        guard let window = self.view.window else {
            return
        }
        let openPanel = folderOpenPanel()
        openPanel.beginSheetModal(for: window) { (response) in
            switch response {
            case NSApplication.ModalResponse.OK:
                self.importImages(fromUrl: openPanel.urls.first)
            default:
                break
            }
        }
    }
    
    @IBAction func exportML(_ sender: Any?) {
        guard let window = self.view.window else {
            return
        }
        let openPanel = folderOpenPanel()
        openPanel.canCreateDirectories = true
        openPanel.beginSheetModal(for: window) { (response) in
            switch response {
            case NSApplication.ModalResponse.OK:
                self.exportML(toUrl: openPanel.urls.first)
            default:
                break
            }
        }
    }
    
    private func exportML(toUrl url: URL?) {
        guard let url = url,
            let impSet = document?.impSet else {
            return
        }
        document?.save(self)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        try? encoder.encode(impSet.annotations).write(to: FileHelper.annotationsUrl(workFolder: impSet.workFolder))
        var exportUrl = url.appendingPathComponent(AppConfiguration.mlExportDirName)
        var count = 2
        while FileManager.default.fileExists(atPath: exportUrl.path) {
            exportUrl = url.appendingPathComponent(String(format: "%@_%li", AppConfiguration.mlExportDirName, count))
            count = count + 1
        }
        try? FileManager.default.copyItem(at: impSet.workFolder, to: exportUrl)
        copy(resource: "MLCreate", pathExtension: "ipynb", exportURL: exportUrl)
        copy(resource: "MLCreate", pathExtension: "py", exportURL: exportUrl)
    }
    
    private func copy(resource: String, pathExtension: String, exportURL: URL) {
        guard let url = Bundle.main.url(forResource: resource, withExtension: pathExtension) else {
            return
        }
        let targetUrl = exportURL.appendingPathComponent(resource).appendingPathExtension(pathExtension)
        try? FileManager.default.copyItem(at: url, to: targetUrl)
    }
    
    private func importImages(fromUrl url: URL?) {
        guard let url = url,
            let _ = document?.impSet else {
            return
        }
        addNormalizedImages(url: url)
        if document?.impSet.annotations.path.count ?? 0 > 0 {
            select(index: 0)
        }
    }
    
    private func addNormalizedImages(url u: URL) {
        guard let urls = try? FileManager.default.contentsOfDirectory(at: u, includingPropertiesForKeys: nil, options: []) else {
            return
        }
        
        var annotationList:[Annotation] = []
        var mlPaths:[String] = []
        
        urls.forEach { (fileUrl) in
            guard let targetImageUrl = document?.impSet.imageFolder.appendingPathComponent(fileUrl.lastPathComponent),
                let image = NSImage(contentsOf: fileUrl),
                image.size.width > 0, image.size.height > 0,
                Double(image.size.width) < Double.infinity,
                Double(image.size.height) < Double.infinity else {
                    return
            }
            let width = image.size.width
            let height = image.size.height
            let scale = max(AppConfiguration.normalizedBaseSizeInPixels / width,
                            AppConfiguration.normalizedBaseSizeInPixels / height)
            let targetSize = NSSize(width: width * scale, height: height * scale)
            let resized = image.resizedImage(w: targetSize.width, h: targetSize.height)
            resized.writeToFile(file: targetImageUrl, usingType: .jpeg)
            let mlPath:String = targetImageUrl.pathComponents.suffix(2).joined(separator: "/")
            mlPaths.append(mlPath)
            let pixelSize = resized.pixelSize()
            let coordinates = Coordinates(width: Double(pixelSize.width), height: Double(pixelSize.height),
                                          x: Double(pixelSize.width) / 2.0, y: Double(pixelSize.height) / 2.0)
            let annotation = Annotation(coordinates: coordinates, label: AppConfiguration.defaultLabel)
            annotationList.append(annotation)
        }
        document?.impSet.annotations.annotations.append(contentsOf: annotationList)
        document?.impSet.annotations.path.append(contentsOf: mlPaths)
    }
    
    private func folderOpenPanel() -> NSOpenPanel {
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        return openPanel
    }
}
