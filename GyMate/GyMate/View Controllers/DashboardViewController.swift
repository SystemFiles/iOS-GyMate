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
    
    @IBOutlet var workoutTable : UITableView!
    @IBOutlet var lbUser : UILabel!
    
    let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // get current user reference
        let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)
        
        // Retreive all data
        ref.observe(DataEventType.value, with: { snapshot in
            self.workouts = []
            self.workoutTable.reloadData()
            
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
            
            self.lbUser.text = username
            self.workoutTable.reloadData() // Reload table data for workouts
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
        let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)
        
        let selectedName = self.workouts[indexPath.row].name

        var selectedWorkouts : [Workout] = []
        
        // Retreive all data
        ref.observe(DataEventType.value, with: { snapshot in
            
    selectedWorkouts.append(Workout.deserializeWorkout(workoutDict: (snapshot.childSnapshot(forPath: "workouts/recommended").value as! NSMutableDictionary)))

        if (snapshot.childSnapshot(forPath: "workouts").childrenCount > 0) { //go through all custom workouts
            for child in snapshot.childSnapshot(forPath: "workouts/custom").children {
                let name = child
                print("This is the name for selected custom workout\(name)")
                let workoutSnapshot = child as! DataSnapshot
                let newWorkoutDict = workoutSnapshot.value as! NSMutableDictionary
                selectedWorkouts.append(Workout.deserializeWorkout(workoutDict: newWorkoutDict))

            }
            var namedWorkout:String
                for workout in selectedWorkouts {
                    print("The workout names are: \(workout.name)")
                    if workout.name == selectedName{
                        namedWorkout = workout.name
                        if namedWorkout == "The Lean Bulk"
                        {
                            print("We have the selected name \(selectedName) and we have data from FB as \(namedWorkout)")
                                                
                            mainDelegate.selectedWorkout = "recommended"
                        }
                        else if namedWorkout == "All About that Balance"
                        {
                            print("We have the selected name \(selectedName) and we have data from FB as \(namedWorkout)")
                                                
                            mainDelegate.selectedWorkout = "recommended"
                        }
                        else if namedWorkout == "Lean wit Me"
                        {
                            print("We have the selected name \(selectedName) and we have data from FB as \(namedWorkout)")
                                                
                            mainDelegate.selectedWorkout = "recommended"
                        }
                        else
                        {
                            print("We have the selected name \(selectedName) and we have data from FB as \(namedWorkout)")
                                                
                            mainDelegate.selectedWorkout = "custom/\(namedWorkout)"

                        }

                    }
                }
            print("This is the workout \(mainDelegate.selectedWorkout)")
            self.gotoSteps()
            
            }
        })
    }
    func gotoSteps(){
        performSegue(withIdentifier: "ChooseSegueToView", sender: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workouts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let workoutCell : SelectWorkoutTableViewCell = tableView.dequeueReusableCell(withIdentifier: "workoutCell") as? SelectWorkoutTableViewCell ?? SelectWorkoutTableViewCell(style: .default, reuseIdentifier: "workoutCell")
            
        let rowData = self.workouts
        
        workoutCell.workoutTitle.text = rowData[indexPath.row].name
        workoutCell.workoutDesc.text = rowData[indexPath.row].desc
        workoutCell.workoutTime.text = "\(rowData[indexPath.row].time)min"
        
            
        return workoutCell
            
    }
    
    

}
