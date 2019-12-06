//
//  CompletedWorkout.swift
//  GyMate
//
//  Created by Liam Stickney on 2019-12-06.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit

class CompletedWorkout: NSObject {
    
    var ID : Int
    var date : String
    var name : String
    var desc : String
    var time : Double
    
    init(ID: Int, date: String?, name: String, desc: String, time: Double) {
        self.ID = ID
        self.date = date!
        self.name = name
        self.desc = desc
        self.time = time
    }
}
