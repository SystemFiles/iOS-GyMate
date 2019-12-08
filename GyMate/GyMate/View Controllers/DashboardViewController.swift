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
            if (snapshot.childSnapshot(forPath: "workouts").childrenCount > 1) { //go through all custom workouts
                for child in snapshot.childSnapshot(forPath: "workouts/custom").children {
                    let workoutSnapshot = child as! DataSnapshot
                    let newWorkoutDict = workoutSnapshot.value as! NSMutableDictionary
                    self.workouts.append(Workout.deserializeWorkout(workoutDict: newWorkoutDict))
                }
            }
            
            // Load in completed workouts
            let completedWorkoutsRef = snapshot.childSnapshot(forPath: "workoutsCompleted/finishedWorkouts")
            for workout in completedWorkoutsRef.children.allObjects as! [DataSnapshot] {
                let workoutObj = CompletedWorkout(ID: workout.childSnapshot(forPath: "id").value as! Int, date: workout.key, name: workout.childSnapshot(forPath: "name").value as! String, desc: workout.childSnapshot(forPath: "desc").value as! String, time: workout.childSnapshot(forPath: "time").value as! Double)
                self.completedWorkouts.append(workoutObj)
            }
            
            // Update Dashboard Gym Time Statistic
            self.lbGymTime.text = "\(snapshot.childSnapshot(forPath: "totalGymTime").value as? Int ?? 0)hrs @ The Gym!"
            
            // Update other user-data
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
    
    /// Used to call StepByStep View Controller on the selected row
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
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return tableView == workoutTable && indexPath.row != 0
    }
    
    /// Style the action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "DELETE", handler: {_,_,_ in
            // Delete data from local and remote locations simultaneously
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            let deleteRef = mainDelegate.userRef.child("\(Auth.auth().currentUser!.uid)/workouts/custom/\(self.workouts[indexPath.row].name)")
            deleteRef.removeValue()
            self.workouts.remove(at: indexPath.row)
            
            // Update table
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        })
        
        action.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0)
        return UISwipeActionsConfiguration(actions: [action])
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
            
            completedWorkoutCell.lbDesc.text = "\(rowData[indexPath.row].desc)"
            completedWorkoutCell.lbName.text = rowData[indexPath.row].name
            completedWorkoutCell.lbTime.text = "\(Int(rowData[indexPath.row].time))m"
            completedWorkoutCell.lbDate.text = "\(rowData[indexPath.row].date)"
            
            return completedWorkoutCell
        }
        
            
    }
    
    

}
