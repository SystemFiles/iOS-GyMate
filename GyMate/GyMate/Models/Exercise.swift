//
//  Exercise.swift
//  GyMate
//
//  Created by Liam Stickney on 2019-11-16.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit

class Exercise: NSObject {
    
    var id : Int
    var name : String
    var desc : String
    var imgBodyDiagram : URL
    var sets : Int
    var reps : Int
    var restPeriod : Double
    
    init(name : String, desc : String, imgBodyDiagram : URL, sets : Int, reps : Int, restPeriod : Double) {
        self.name = name
        self.desc = desc
        self.imgBodyDiagram = imgBodyDiagram
        self.sets = sets
        self.reps = reps
        self.restPeriod = restPeriod
    }
    
}
