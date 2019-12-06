//
//  DashboardViewController.swift
//  GyMate
//
//  Created by Liam Stickney on 2019-11-21.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
import Firebase

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var workouts : [Workout] = []
    var completedWorkouts : [CompletedWorkout] = []
    
    @IBOutlet var workoutTable : UITableView!
    @IBOutlet var lbUser : UILabel!
    @IBOutlet var lbGymTime : UILabel!
    @IBOutlet var completedWorkoutTable : UITableView!
    
    let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // get current user reference
        let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)
        
        // Retreive all data
        ref.observe(DataEventType.value, with: { snapshot in
            self.workouts = []
            self.completedWorkouts = []
            self.workoutTable.reloadData()
            self.completedWorkoutTable.reloadData()
            
            let username = snapshot.childSnapshot(forPath: "username").value as! String
            self.workouts.append(Workout.deserializeWorkout(workoutDict: (snapshot.childSnapshot(forPath: "workouts/recommended").value as! NSMutableDictionary)))
        
            // Make sure no errors when retreiving custom workouts
            var selectedWorkouts : [Workout] = []
            if (snapshot.childSnapshot(forPath: "workouts").childrenCount > 1) { //go through all custom workouts
                for child in snapshot.childSnapshot(forPath: "workouts/custom").children {
                    let workoutSnapshot = child as! DataSnapshot
                    let newWorkoutDict = workoutSnapshot.value as! NSMutableDictionary
                    selectedWorkouts.append(Workout.deserializeWorkout(workoutDict: newWorkoutDict))
                }
            }
            
            //add them to the user's workouts
            for workout in selectedWorkouts {
                self.workouts.append(workout)
            }
            
            var selectedCompletedWorkouts : [CompletedWorkout] = []
            for child in snapshot.childSnapshot(forPath: "workoutsCompleted/finishedWorkouts").children {
                
                let completedWorkoutSnapshot = child as! DataSnapshot
                let newWorkoutDict = completedWorkoutSnapshot.value as! NSMutableDictionary
                selectedCompletedWorkouts.append(CompletedWorkout.deserializeWorkout(workoutDict: newWorkoutDict))
            }
            
            for completedWorkout in selectedCompletedWorkouts {
                self.completedWorkouts.append(completedWorkout)
            }
            
            // Update Dashboard Gym Time Statistic
            self.lbGymTime.text = "\(snapshot.childSnapshot(forPath: "totalGymTime").value as? Int ?? 0)hrs @ The Gym!"
            
            self.lbUser.text = username
            self.workoutTable.reloadData() // Reload table data for workouts
            self.completedWorkoutTable.reloadData() //reload table data for completed workouts
        })
        // Do any additional setup after loading the view.
    }
    
    //rewind to dashboard from add workout
    @IBAction func rewindToDashboardVC(sender: UIStoryboardSegue!) {
        workoutTable.reloadData()
    }
    
    @IBAction func logoutUser(sender: UIButton!) {
        // Perform user logout
        try! Auth.auth().signOut()
        
        // If user used 'stay logged in' feature
        if mainDelegate.launchedBefore {
            // remove user from defaults
            mainDelegate.userDefault.set(false, forKey: "usersignedin")
        }
    }
    
    @IBAction func addWorkout(sender: UIButton!) {
        let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        mainDelegate.workoutCurrentID = self.workouts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == workoutTable {

                 let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                 let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)
                 
                 let selectedName = self.workouts[indexPath.row].name

                 var selectedWorkouts : [Workout] = []
                 
                 // Retreive all data
                 ref.observe(DataEventType.value, with: { snapshot in
            
                 //Add recommended workout to list
             selectedWorkouts.append(Workout.deserializeWorkout(workoutDict: (snapshot.childSnapshot(forPath: "workouts/recommended").value as! NSMutableDictionary)))

                 if (snapshot.childSnapshot(forPath: "workouts").childrenCount > 0) { //go through all custom workouts
                     for child in snapshot.childSnapshot(forPath: "workouts/custom").children {

                         let workoutSnapshot = child as! DataSnapshot
                         let newWorkoutDict = workoutSnapshot.value as! NSMutableDictionary
                         selectedWorkouts.append(Workout.deserializeWorkout(workoutDict: newWorkoutDict))

                     }
                     var namedWorkout:String
                         //Check if selected workout has been appended to list
                         //Then store the URL pathway in the delegate
                         for workout in selectedWorkouts {
                     
                             if workout.name == selectedName{
                                 namedWorkout = workout.name
                                 if namedWorkout == "The Lean Bulk"
                                 {
                                     mainDelegate.selectedWorkout = "recommended"
                                 }
                                 else if namedWorkout == "All About that Balance"
                                 {
                                     mainDelegate.selectedWorkout = "recommended"
                                 }
                                 else if namedWorkout == "Lean wit Me"
                                 {
                                     mainDelegate.selectedWorkout = "recommended"
                                 }
                                 else
                                 {
                                     mainDelegate.selectedWorkout = "custom/\(namedWorkout)"

                                 }

                             }
                         }
                     
                     self.gotoSteps()
                     
                     }
                 })
        }
        
    }
    //Used to call StepByStep View Controller on the selected row
    func gotoSteps(){
        performSegue(withIdentifier: "StepByStepSegue", sender: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == workoutTable {
            return self.workouts.count
        } else {
            return self.completedWorkouts.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == workoutTable {
            let workoutCell : SelectWorkoutTableViewCell = tableView.dequeueReusableCell(withIdentifier: "workoutCell") as? SelectWorkoutTableViewCell ?? SelectWorkoutTableViewCell(style: .default, reuseIdentifier: "workoutCell")
                
            let rowData = self.workouts
            
            workoutCell.workoutTitle.text = rowData[indexPath.row].name
            workoutCell.workoutDesc.text = rowData[indexPath.row].desc
            workoutCell.workoutTime.text = "\(Int(rowData[indexPath.row].time))m"
            
                
            return workoutCell
            
        } else {
            
            let completedWorkoutCell : CompletedWorkoutTableViewCell = tableView.dequeueReusableCell(withIdentifier: "completedWorkoutCell") as? CompletedWorkoutTableViewCell ?? CompletedWorkoutTableViewCell(style: .default, reuseIdentifier: "completedWorkoutCell")
            
            let rowData = self.completedWorkouts
            
            completedWorkoutCell.lbName.text = rowData[indexPath.row].name
            completedWorkoutCell.lbTime.text = "\(Int(rowData[indexPath.row].time))m"
            
            return completedWorkoutCell
        }
        
            
    }
    
    

}
