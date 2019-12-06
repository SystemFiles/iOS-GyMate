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
    var name : String
    var time : Double
    
    init(ID : Int, name : String, time : Double) {
        self.ID = ID
        self.name = name
        self.time = time
    }

    
    /// Deserialize a received Firebase response to a instance of the CompletedWorkout class
    static func deserializeWorkout(workoutDict : NSMutableDictionary!) -> CompletedWorkout {
        // Build workout object
        let workoutObj : CompletedWorkout = CompletedWorkout(ID: workoutDict!["id"] as! Int, name: workoutDict!["name"] as! String, time: workoutDict!["time"] as! Double)
        
        return workoutObj
    }
    
    /// Serializes CompletedWorkout object in a format that Firebase can store automatically (Dictionary)
    func getFBSerializedFormat() -> NSMutableDictionary {
        // Build serialized workout object
        let workoutObj : NSMutableDictionary = [
            "id" : self.ID,
            "name" : self.name,
            "time" : self.time        ]

        return workoutObj
    }

}
