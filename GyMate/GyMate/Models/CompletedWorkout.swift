//
//  CompletedWorkout.swift
//  GyMate
//
//  Created by Liam Stickney on 2019-12-06.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
///CompletedWorkout object to define object attributes
class CompletedWorkout: NSObject {
    //Workout ID
    var ID : Int
    //Workout date
    var date : String
    //Workout name
    var name : String
    //Workout description
    var desc : String
    //Workout completion time
    var time : Double
    
    //Initalize attributes
    init(ID: Int, date: String?, name: String, desc: String, time: Double) {
        self.ID = ID
        self.date = date!
        self.name = name
        self.desc = desc
        self.time = time
    }
}
