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
    
    var workouts : [NSMutableDictionary] = []
    
    @IBOutlet var workoutTable : UITableView!
    @IBOutlet var lbUser : UILabel!
    
    let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // get current user reference
        let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)
        
        // Retreive all data
        //TODO: Change this so it's observe, not observeSingleEvent
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let username = snapshot.childSnapshot(forPath: "username").value as! String
            self.workouts.append(snapshot.childSnapshot(forPath: "workouts/recommended").value as! NSMutableDictionary)
        
            // Make sure no errors when retreiving custom workouts
            var selectedWorkouts : [NSMutableDictionary] = []
            if (snapshot.childSnapshot(forPath: "workouts").childrenCount > 1) {
                for child in snapshot.childSnapshot(forPath: "workouts/custom").children {
                    let workoutSnapshot = child as! DataSnapshot
                    let newWorkoutDict = workoutSnapshot.value as! NSMutableDictionary
                    selectedWorkouts.append(newWorkoutDict)
                }
            }
            for workout in selectedWorkouts {
                self.workouts.append(workout)
            }
            
            self.lbUser.text = username
            self.workoutTable.reloadData() // Reload table data for workouts
        })
        // Do any additional setup after loading the view.
    }
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workouts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let workoutCell : SelectWorkoutTableViewCell = tableView.dequeueReusableCell(withIdentifier: "workoutCell") as? SelectWorkoutTableViewCell ?? SelectWorkoutTableViewCell(style: .default, reuseIdentifier: "workoutCell")
            
        let rowData = self.workouts
        
        workoutCell.workoutTitle.text = rowData[indexPath.row]["name"] as? String
        workoutCell.workoutDesc.text = rowData[indexPath.row]["desc"] as? String
        workoutCell.workoutTime.text = "\(rowData[indexPath.row]["time"]!)min"
        
            
        return workoutCell
            
    }
    
    

}
