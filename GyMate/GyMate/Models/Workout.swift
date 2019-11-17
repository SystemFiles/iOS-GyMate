//
//  Workout.swift
//  GyMate
//
//  Created by Liam Stickney on 2019-11-14.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit

class Workout: NSObject {

    
    var ID : Int
    var name : String
    var desc : String
    var time : Double
    var exercises : [Exercise]
    
    init(ID : Int, name : String, desc : String, time : Double, exercises : [Exercise]) {
        self.ID = ID
        self.name = name
        self.desc = desc
        self.time = time
        self.exercises = exercises
    }
    
    
    func addExercise(exercise : Exercise) {
        self.exercises.append(exercise)
    }
    
}
