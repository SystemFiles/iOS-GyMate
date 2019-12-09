//
//  Workout.swift
//  GyMate
//
//  Created by Liam Stickney on 2019-11-14.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
//Initalze a Workout Object
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
    
    /// Add an exercise to this workout
    func addExercise(exercise : Exercise) {
        self.exercises.append(exercise)
    }
    
    /// Deserialize a received Firebase response to a instance of the Workout class
    static func deserializeWorkout(workoutDict : NSMutableDictionary!) -> Workout {
        // Build workout object
        let workoutObj : Workout = Workout(ID: workoutDict!["id"] as! Int, name: workoutDict!["name"] as! String, desc: workoutDict!["desc"] as! String, time: workoutDict!["time"] as! Double, exercises : [])
        
        // Build exercise list in workout
        for exerciseDict in (workoutDict!["exercises"] as! [NSMutableDictionary]) {
            let curExercise = Exercise(id: exerciseDict["id"] as! Int, name: exerciseDict["name"] as! String, desc: exerciseDict["desc"] as! String, imgBodyDiagram: exerciseDict["imgBodyDiagram"] as! String, sets: exerciseDict["sets"] as! Int, reps: exerciseDict["reps"] as! Int, restPeriod: exerciseDict["restPeriod"] as! Double)
            
            // Add the exercise to the workout
            workoutObj.exercises.append(curExercise)
        }
        
        return workoutObj
    }
    
    /// Serializes Workout object in a format that Firebase can store automatically (Dictionary)
    func getFBSerializedFormat() -> NSMutableDictionary {
        // Build serialized workout object
        let workoutObj : NSMutableDictionary = [
            "id" : self.ID,
            "name" : self.name,
            "desc" : self.desc,
            "time" : self.time,
            "exercises" : []
        ]
        
        var serializedExercises : [NSMutableDictionary] = []
        
        // Go through all exercises in workout and serialize them for Firebase
        for exercise in exercises {
            let serializedObj : NSMutableDictionary = [
                "id" : exercise.id,
                "name" : exercise.name,
                "desc" : exercise.desc,
                "imgBodyDiagram" : exercise.imgBodyDiagram as Any,
                "sets" : exercise.sets,
                "reps" : exercise.reps,
                "restPeriod" : exercise.restPeriod
            ]
            
            // Add the exercise to the array
            serializedExercises.append(serializedObj)
        }
        
        // Add the list of exercises in the workout to the serialized workout object
        workoutObj["exercises"] = serializedExercises
        
        return workoutObj
    }
}
