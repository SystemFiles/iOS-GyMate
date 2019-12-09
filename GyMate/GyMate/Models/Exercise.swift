//
//  Exercise.swift
//  GyMate
//
//  Created by Liam Stickney on 2019-11-16.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit

class Exercise: NSObject {
    
    // Exercise fields
    var id : Int
    var name : String
    var desc : String
    var imgBodyDiagram : String?
    var sets : Int
    var reps : Int
    var restPeriod : Double
    
    /// Initalize an instance of Exercise
    init(id : Int, name : String, desc : String, imgBodyDiagram : String, sets : Int, reps : Int, restPeriod : Double) {
        self.id = id
        self.name = name
        self.desc = desc
        self.imgBodyDiagram = imgBodyDiagram
        self.sets = sets
        self.reps = reps
        self.restPeriod = restPeriod
    }
    
}
