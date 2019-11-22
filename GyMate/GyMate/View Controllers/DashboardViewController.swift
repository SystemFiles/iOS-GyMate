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
    
    
    @IBOutlet var workoutTable : UITableView!
    @IBOutlet var lbUser : UILabel!
    
    let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let username = snapshot.childSnapshot(forPath: "username").value as! String
            
            self.lbUser.text = username
        })
        // Do any additional setup after loading the view.
    }
    
    @IBAction func rewindToDashboardVC(sender: UIStoryboardSegue!) {
        // DO NOTHING
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)

        var workoutCount : Int = 1
        //NEED TO FIGURE OUT HOW TO DO THIS BEFORE VALUE IS RETURNED
        ref.observeSingleEvent(of: .value, with: { snapshot in
            workoutCount = Int(snapshot.childSnapshot(forPath: "workouts").childrenCount)
        })

        return workoutCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let workoutCell : SelectWorkoutTableViewCell = tableView.dequeueReusableCell(withIdentifier: "workoutCell") as? SelectWorkoutTableViewCell ?? SelectWorkoutTableViewCell(style: .default, reuseIdentifier: "workoutCell")
            
            let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)
            
            let row = indexPath.row
            
            ref.observeSingleEvent(of: .value, with: { snapshot in
                let bodyType = snapshot.childSnapshot(forPath: "bodyType").value as! String
                let workouts = snapshot.childSnapshot(forPath: "workouts").childSnapshot(forPath: "recommended").value as! NSDictionary
                
                    //need to know how workouts are being stored in database
                    let rowData = workouts
                    print(rowData["time"]!)
                    workoutCell.workoutTitle.text = rowData["name"] as? String
                    workoutCell.workoutDesc.text = rowData["desc"] as? String
                    workoutCell.workoutTime.text = "\(rowData["time"]!)"
            })
            
        return workoutCell
            
    }
    
    

}
