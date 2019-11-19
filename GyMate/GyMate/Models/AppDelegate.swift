//
//  AppDelegate.swift
//  GyMate
//
//  Created by Ben Sykes on 2019-11-07.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userRef : DatabaseReference!
    var ectoWorkout : Workout!
    var mesoWorkout : Workout!
    var endoWorkout : Workout!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        self.userRef = Database.database().reference(withPath: "user-data")
        
        // Setup default body type workouts
        self.setWorkouts()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func setWorkouts() {
        // Build ecto workout
        ectoWorkout = Workout(ID: 0, name: "Long but Lean!", desc: "This workout routine, coupled with a bulking diet, will help beginners who struggle to gain muscle mass and weight to start building that lean, chisled, muscle and strenth through a tried and tested workout!", time: 105.0, exercises: [])
        
        // Add exercises
        ectoWorkout.exercises.append(Exercise(id: 0, name: "Barbell Bench Press", desc: "", imgBodyDiagram: "barbell_bench_press", sets: 4, reps: 10, restPeriod: 60.0))
        // Add rest of workouts from SLACK (MY CHAT MESSAGES TO MYSELF)
        
        // Build meso workout
        
        // Build endo workout
    }
}

