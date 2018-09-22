//
//  FileHelper.swift
//  ImagePreparation
//
//  Created by Volker Bublitz on 22.09.18.
//  Copyright © 2018 vobu. All rights reserved.
//

import Cocoa

class FileHelper: NSObject {

    static func workImagesUrl(workFolder: URL) -> URL {
        let imageFolder = workFolder.appendingPathComponent("images")
        assureDirectoryIsAvailable(imageFolder)
        return imageFolder
    }
    
    static func annotationsUrl(workFolder: URL) -> URL {
        return workFolder.appendingPathComponent("annotations.json")
    }
    
    static func workFolderURL() -> URL {
        let uuid = UUID().uuidString
        guard let workFolder = applicationSupportUrl()?.appendingPathComponent(uuid) else {
            fatalError("unable to work with application support files")
        }
        assureDirectoryIsAvailable(workFolder)
        return workFolder
    }
    
    static func cleanApplicationSupport() {
        guard let dir = applicationSupportUrl(),
            let urls = try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil, options: []) else {
            return
        }
        urls.forEach { (url) in
            try? FileManager.default.removeItem(at: url)
        }
    }
    
    private static func assureDirectoryIsAvailable(_ url: URL) {
        let fm = FileManager.default
        if !fm.fileExists(atPath: url.path) {
            do {
                try fm.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error {
                fatalError("Stopping application - no access to working directory " + error.localizedDescription)
            }
        }
    }
    
    private static func applicationSupportUrl() -> URL? {
        if let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let appDirectory = url.appendingPathComponent(Bundle.main.bundleIdentifier ?? AppConfiguration.appName)
            return appDirectory
        }
        return nil
    }
    
}
