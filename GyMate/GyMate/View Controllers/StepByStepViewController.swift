//
//  StepByStepViewController.swift
//  GyMate
//
//  Created by Malik Sheharyaar Talhat on 2019-11-29.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
import Firebase
import SpriteKit

class StepByStepViewController: UIViewController {
    let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate

    var seconds :Int = 30
    //Used to calculate overall time spent on workout
    var totalSeconds : Int = 0
    var secondsUsed = 0
    //To keep track of current set
    var count :Int  = -1
    //Number of sets
    var setCount :Int  = 0
    var totalSets :Int  = 0
    var totalExercises :Int  = 0
    var timer = Timer()
    //Initalize timer for when workout is started
    var completionTimer = Timer()
    var completedworkout : Workout!
    
    @IBOutlet var sceneView: SKView!
    var scene:SpriteScene?
    //Firebase URL path for selected workout
    var workoutType : String = ""
    @IBOutlet var lblWorkoutName : UILabel!
    @IBOutlet var lblTimer: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var lblSets: UILabel!
    @IBOutlet var lblExerciseTitle: UILabel!
    @IBOutlet var lblCount: UILabel!
    @IBOutlet var startOutlet: UIButton!
    @IBOutlet var skipOutlet: UIButton!
    @IBOutlet var doneOutlet: UIButton!
    
    
    @IBAction func startWorkout (sender: Any){

        self.count = 0
        self.setCount = self.totalSets
        updateFromDB()
        completionTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StepByStepViewController.totalTime), userInfo: nil, repeats: true)
        self.lblTimer.text = " "
        doneOutlet.isHidden = false
        skipOutlet.isHidden = true
        startOutlet.isHidden = true
    }
    @objc func counter()
    {
        seconds -= 1
        lblTimer.text = String(seconds) + "s"
        
        //Reveal buttons when rest timer has ended
        if (seconds == 0)
        {

            timer.invalidate()
            totalSeconds += secondsUsed - seconds
            skipOutlet.isHidden = true
            startOutlet.isHidden = true
            doneOutlet.isHidden = false
        }
        if let scene = self.scene {
            scene.starScene()
    
        }
    }
    @objc func totalTime()
    {
        totalSeconds += 1

    }
    
    @IBAction func skipWorkout (sender: Any){
        
        timer.invalidate()
        completionTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StepByStepViewController.totalTime), userInfo: nil, repeats: true)
        //Accommodate for time elapsed udring rest
        totalSeconds += secondsUsed - seconds
        seconds = 30
        self.lblTimer.text = ""
        skipOutlet.isHidden = true
        startOutlet.isHidden = true
        doneOutlet.isHidden = false
    }
    @IBAction func doneWorkout (sender: Any){
        completionTimer.invalidate()
        workoutType = mainDelegate.selectedWorkout
        doneOutlet.isHidden = true
        startOutlet.isHidden = true
        lblTimer.text = "..."

        let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)
        
        //Once sets have been completed, move onto the next exercise if there is one
        if setCount < 0{
            if count < totalExercises-1 {
                self.count += 1
                ref.child("workouts/\(workoutType)").observeSingleEvent(of: .value, with: { snapshot in

                    let name = snapshot.childSnapshot(forPath: "exercises/\(self.count)/name").value  as! String
                    self.lblExerciseTitle.text = name
                    
                    let sets = snapshot.childSnapshot(forPath: "exercises/\(self.count)/sets").value  as! Int
                    self.totalSets = sets
                    self.setCount = self.totalSets
                    self.setCount -= 1
                    self.lblSets.text = String(self.setCount+1)
                    
                    let desc = snapshot.childSnapshot(forPath: "exercises/\(self.count)/desc").value  as! String
                    
                    self.lblDesc.text = desc
                    
                    let restPeriod = snapshot.childSnapshot(forPath: "exercises/\(self.count)/restPeriod").value  as! Int
                    self.seconds = restPeriod
                    self.secondsUsed = restPeriod
                    
                })
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StepByStepViewController.counter), userInfo: nil, repeats: true)
                lblCount.text = "\((count+1)) / \(self.totalExercises)"
                
            }else
            {
                    //Save completed workout to Firebase
                    let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)
                ref.observeSingleEvent(of: DataEventType.value, with: { snapshot in


                    self.completedworkout = Workout.deserializeWorkout(workoutDict: (snapshot.childSnapshot(forPath: "workouts/\(self.workoutType)").value as! NSMutableDictionary))
                        let name = self.completedworkout.name
                        
                        
                        let workoutRef = ref.child("workoutsCompleted").child("finishedWorkouts/\(name)")
                    //Using helper function to serializes Workout object in a format that Firebase can store automatically (Dictionary)
                    workoutRef.setValue(self.completedworkout.getFBSerializedFormat())
                        
                    workoutRef.child("time").setValue(self.totalSeconds)
                    
                    // Update total workout time (for dashboard)
                    ref.child("totalGymTime").setValue((snapshot.childSnapshot(forPath: "totalGymTime").value as? Int ?? 0) + (self.totalSeconds / 3600))
                   
                    //Calories burned might be implemented later
                    workoutRef.child("calorie").setValue(150)
                    
                     })
                    mainDelegate.totalTime = self.totalSeconds
                    //Goto WorkOutSummary View controller once workout has been completed
                    performSegue(withIdentifier: "WorkOutSummarySegue", sender: nil)
            }
        }else{
            updateFromDB()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StepByStepViewController.counter), userInfo: nil, repeats: true)
            lblCount.text = "\((count+1)) / \(self.totalExercises)"
        }
        skipOutlet.isHidden = false

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        workoutType = mainDelegate.selectedWorkout
        doneOutlet.isHidden = true
        skipOutlet.isHidden = true
       
        let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)
        ref.child("workouts/\(workoutType)").observeSingleEvent(of: .value, with: { snapshot in
            
            if self.count == -1 {
                let name = snapshot.childSnapshot(forPath: "name").value  as! String
                 self.lblWorkoutName.text = name
                 
                 let sets = snapshot.childSnapshot(forPath: "exercises/0/sets").value  as! Int
                 self.totalSets = sets
                 self.lblSets.text = String(self.totalSets)
                 let totalTime = snapshot.childSnapshot(forPath: "time").value  as! Int
                
                 // TODO: Add total workout time to view somewhere
                 let desc = snapshot.childSnapshot(forPath: "desc").value  as! String

                self.lblDesc.text = desc
            }
            let exercises = snapshot.childSnapshot(forPath: "exercises").childrenCount
            self.totalExercises = Int(exercises)
            
            // Show exercize number count
            self.lblCount.text = "\((self.count + 1)) / \(self.totalExercises)"

        })
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Setup the Sprite scene
        self.scene = SpriteScene(size: CGSize(width: self.sceneView.frame.size.width, height: self.sceneView.frame.size.height))
        self.sceneView.presentScene(scene)
        
    }
    
    func updateFromDB() {
        /// Load data into label

        workoutType = mainDelegate.selectedWorkout
        let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)
        

        ref.child("workouts/\(workoutType)").observeSingleEvent(of: .value, with: { snapshot in

            let name = snapshot.childSnapshot(forPath: "exercises/\(self.count)/name").value  as! String
            self.lblExerciseTitle.text = name
            
            self.setCount -= 1
            self.lblSets.text = String(self.setCount+1)
            
            
            let desc = snapshot.childSnapshot(forPath: "exercises/\(self.count)/desc").value  as! String

            self.lblDesc.text = desc

            
            let restPeriod = snapshot.childSnapshot(forPath: "exercises/\(self.count)/restPeriod").value  as! Int
            self.seconds = restPeriod
            self.secondsUsed = restPeriod

        })
    }
}
