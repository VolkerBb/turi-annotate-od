//
//  Annotations.swift
//  ImagePreparation
//
//  Created by Volker Bublitz on 16.09.18.
//  Copyright © 2018 Volker Bublitz. All rights reserved.
//

import Cocoa

struct Annotations: Codable {
    var path:[String]
    var annotations:[Annotation]
}

struct Annotation: Codable {
    var coordinates:Coordinates
    var label:String
}

struct Coordinates: Codable {
    var width:Double
    var height:Double
    var x:Double
    var y:Double
}
