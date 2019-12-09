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

///Completed by Malik Sheharyaar Talhat and modifications made by Ben Sykes
///This class includes two timers, first the completionTimer is used to determine total time spent on a workout
///Second timer is used to determine the rest time per exercise
///Note: Only one timer is active at a time, when the rest phase begins, the completion timer is halted and the normal timer beings. Once the rest time ends, it is halted and the completion  timer resumes again
class StepByStepViewController: UIViewController {
    //Reference to app delegate
    let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var estimatedCompletionTime : Int = 0
    //Variable used to set rest timer for each exercise in the workout
    var seconds :Int = 30
    //Used to calculate overall time spent on workout
    var totalSeconds : Int = 0
    //Used to store an instace of the last rest time to determine if the user used the whole amount of given rest time or if they skipped the rest timer before it reached 0 seconds
    var secondsUsed = 0
    //To keep track of current set
    var count :Int  = -1
    //Number of sets
    var setCount :Int  = 0
    //Total sets
    var totalSets :Int  = 0
    //Total exercises
    var totalExercises :Int  = 0
    //Initalize timer for when a exercises is started
    var timer = Timer()
    //Initalize timer for when workout is started
    var completionTimer = Timer()
    //Store a Workout object
    var completedworkout : Workout!
    
    @IBOutlet var sceneView: SKView!
    //Spritekit scene for visuals
    var scene:SpriteScene?
    //Firebase URL path for selected workout
    var workoutType : String = ""
    //Workout name
    @IBOutlet var lblWorkoutName : UILabel!
    //Exercise counter label
    @IBOutlet var lblTimer: UILabel!
    //Workout/Exercise description
    @IBOutlet var lblDesc: UILabel!
    //Display number of sets
    @IBOutlet var lblSets: UILabel!
    //Display number of reps
    @IBOutlet var lblRepCount : UILabel!
    //Display exercise name
    @IBOutlet var lblExerciseTitle: UILabel!
    //Display number of exercises in a workout
    @IBOutlet var lblCount: UILabel!
    //Display estimated workout completion time (Added by Ben Sykes)
    @IBOutlet var lblEstimatedTime : UILabel!
    //Outlet for start workout button
    @IBOutlet var startOutlet: UIButton!
    //Outlet for skipping button (used for skipping the rest time between sets)
    @IBOutlet var skipOutlet: UIButton!
    //Outlet for done button (when reps are completed, this outlet is called to initiate the rest time between sets)
    @IBOutlet var doneOutlet: UIButton!
    //Dissmiss View
    @IBAction func dissmissView(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    //Start workout
    @IBAction func startWorkout (sender: Any){
        //Note count was initalized as -1 to allow the code in viewDidLoad to launch
        //Current exercise set
        self.count = 0
        //Total number of sets
        self.setCount = self.totalSets
        //Retrieve workout data
        updateFromDB()
        //Start completion timer
        completionTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StepByStepViewController.totalTime), userInfo: nil, repeats: true)
        //Hide unnecessary elements
        self.lblTimer.text = " "
        doneOutlet.isHidden = false
        skipOutlet.isHidden = true
        startOutlet.isHidden = true
    }
    ///Function to handle computation of timer
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
    ///Function to handle computation of completionTimer
    @objc func totalTime()
    {
        totalSeconds += 1

    }
    
    @IBAction func skipWorkout (sender: Any){
        
        timer.invalidate()
        completionTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StepByStepViewController.totalTime), userInfo: nil, repeats: true)
        //Accommodate for time elapsed during rest
        totalSeconds += secondsUsed - seconds
        //To reset seconds
        seconds = 30
        self.lblTimer.text = ""
        skipOutlet.isHidden = true
        startOutlet.isHidden = true
        doneOutlet.isHidden = false
    }
    ///Handles workout progression
    @IBAction func doneWorkout (sender: Any){
        completionTimer.invalidate()
        //Obtain type of workout from saved value within the app delegate
        workoutType = mainDelegate.selectedWorkout
        doneOutlet.isHidden = true
        startOutlet.isHidden = true
        lblTimer.text = "..."
        //Reference to current user from Firebase
        let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)
        
        //Once sets have been completed, move onto the next exercise if there is one
        if setCount < 0{
            //Check how many exercises have been completed from the workout
            if count < totalExercises-1 {
                self.count += 1
                //Reference to workout data stored in Firebase
                ref.child("workouts/\(workoutType)").observeSingleEvent(of: .value, with: { snapshot in
                    //Name reference
                    let name = snapshot.childSnapshot(forPath: "exercises/\(self.count)/name").value  as! String
                    self.lblExerciseTitle.text = name
                    //Number of set reference
                    let sets = snapshot.childSnapshot(forPath: "exercises/\(self.count)/sets").value  as! Int
                    self.totalSets = sets
                    self.setCount = self.totalSets
                    //Logical correction
                    self.setCount -= 1
                    //Instead of diplaying set number 0 to user, it is displayed as set 1
                    self.lblSets.text = String(self.setCount+1)
                    //Exercise description reference
                    let desc = snapshot.childSnapshot(forPath: "exercises/\(self.count)/desc").value  as! String
                    
                    self.lblDesc.text = desc
                    //Rest time reference
                    let restPeriod = snapshot.childSnapshot(forPath: "exercises/\(self.count)/restPeriod").value  as! Int
                    
                    self.seconds = restPeriod
                    self.secondsUsed = restPeriod
                    
                    // Set rep count for exercise
                    self.lblRepCount.text = "For \(snapshot.childSnapshot(forPath: "exercises/\(self.count)/reps").value as! Int) Reps"
                    
                })
                //Start timer for rest time
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StepByStepViewController.counter), userInfo: nil, repeats: true)
                lblCount.text = "\((count+1)) / \(self.totalExercises)"
                
            }else
            {
                    //Save completed workout to Firebase
                    let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)
                    ref.observeSingleEvent(of: DataEventType.value, with: { snapshot in

                    //Covert workout from Firebase to a readble object and store it
                    self.completedworkout = Workout.deserializeWorkout(workoutDict: (snapshot.childSnapshot(forPath: "workouts/\(self.workoutType)").value as! NSMutableDictionary))
                        
                    //Current date of when the workout is completed (Added by Ben Sykes)
                    let currentDate : String = Date().description.split(separator: " ")[0].lowercased()
                    //Add workouts to Firebase according to current date (assuming now one does the same workout 2 times a day)
                    let workoutRef = ref.child("workoutsCompleted").child("finishedWorkouts/\(currentDate)")
                    //Using helper function to serializes Workout object in a format that Firebase can store automatically (Dictionary)
                    workoutRef.setValue(self.completedworkout.getFBSerializedFormat())
                    //Save workout completion time to Firebase
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
            //Retrieve data from Firebase
            updateFromDB()
            //Start timer for rest phase of exercise
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StepByStepViewController.counter), userInfo: nil, repeats: true)
            lblCount.text = "\((count+1)) / \(self.totalExercises)"
        }
        skipOutlet.isHidden = false

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //Type of workout (recommneded or custom)
        workoutType = mainDelegate.selectedWorkout
        doneOutlet.isHidden = true
        skipOutlet.isHidden = true
       
        let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)
        ref.child("workouts/\(workoutType)").observeSingleEvent(of: .value, with: { snapshot in
            //Used to load the workout data first and then later functions would load the data for the exercises in the workout
            if self.count == -1 {
                let name = snapshot.childSnapshot(forPath: "name").value  as! String
                self.lblWorkoutName.text = name
                 //Total number of sets in workout
                let sets = snapshot.childSnapshot(forPath: "exercises/0/sets").value  as! Int
                self.totalSets = sets
                self.lblSets.text = String(self.totalSets)
                let totalTime = Int(snapshot.childSnapshot(forPath: "time").value  as! Double)
                
                // TODO: Add total workout time to view somewhere
                self.lblEstimatedTime.text = "Estimated Completion Time: \(totalTime) minutes"
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
        
        //Obtain workout data from firebase
        ref.child("workouts/\(workoutType)").observeSingleEvent(of: .value, with: { snapshot in

            let name = snapshot.childSnapshot(forPath: "exercises/\(self.count)/name").value  as! String
            self.lblExerciseTitle.text = name
            
            self.setCount -= 1
            self.lblSets.text = String(self.setCount+1)
            
            
            let desc = snapshot.childSnapshot(forPath: "exercises/\(self.count)/desc").value  as! String

            self.lblDesc.text = desc

            // Set rep count for exercise
            self.lblRepCount.text = "For \(snapshot.childSnapshot(forPath: "exercises/\(self.count)/reps").value as? Int ?? 0) Reps"
            
            let restPeriod = snapshot.childSnapshot(forPath: "exercises/\(self.count)/restPeriod").value  as! Int
            self.seconds = restPeriod
            self.secondsUsed = restPeriod

        })
    }
}
