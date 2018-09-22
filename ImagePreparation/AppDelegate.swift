//
//  AppDelegate.swift
//  ImagePreparation
//
//  Created by Volker Bublitz on 22.09.18.
//  Copyright © 2018 vobu. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        FileHelper.cleanApplicationSupport()
    }


}

