//
//  AddWorkoutViewController.swift
//  GyMate
//
//  Created by Liam Stickney on 2019-11-21.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
import Firebase

class AddWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var exerciseTable : UITableView!
    @IBOutlet var txtName : UITextField!
    @IBOutlet var txtDesc : UITextField!
    @IBOutlet var btnAdd : UIButton!
    
    let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        exerciseTable.reloadData()
        super.viewDidLoad()
    }

    @IBAction func textChanged(sender : UITextField!) {
        self.checkValidWorkout()
    }
    
    @IBAction func rewindToAddWorkoutVC(sender: UIStoryboardSegue!) {
        exerciseTable.reloadData()
        self.checkValidWorkout()
    }
    @IBAction func dissmissView(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addWorkoutToDatabase() {
        
        let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)
        let newWorkout : Workout = Workout(ID: mainDelegate.workoutCurrentID + 1, name: txtName.text!, desc: txtDesc.text!, time: Double(mainDelegate.progressExerciseList.count * 10), exercises: mainDelegate.progressExerciseList)
        
        mainDelegate.progressExerciseList = [] //reset the workout exercises
    
        let workoutRef = ref.child("workouts/custom").child(newWorkout.name) //add the workout to DB
        
        workoutRef.setValue(newWorkout.getFBSerializedFormat())
        
        mainDelegate.exerciseID = 0
    }
    
    func checkValidWorkout() {
        if !txtName.text!.isEmpty && !txtDesc.text!.isEmpty && mainDelegate.progressExerciseList.count > 0 {
            self.btnAdd.isEnabled = true
        } else {
            self.btnAdd.isEnabled = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.progressExerciseList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// Custom Action Method for deleting exercises from this workout creation
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "DELETE", handler: {_,_,_ in
            // Delete exercise from this list in progress
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            mainDelegate.progressExerciseList.remove(at: indexPath.row)
            
            // Reset button if needed
            self.checkValidWorkout()
            
            // Update table
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        })
        
        action.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0)
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let exerciseCell : ExerciseTableViewCell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell") as? ExerciseTableViewCell ?? ExerciseTableViewCell(style: .default, reuseIdentifier: "exerciseCell")
        
        let rowData = mainDelegate.progressExerciseList
        
        exerciseCell.exerciseName.text = rowData![indexPath.row].name
        exerciseCell.exerciseDesc.text = rowData![indexPath.row].desc
        exerciseCell.exerciseReps.text = "\(rowData![indexPath.row].reps)"
        exerciseCell.exerciseSets.text = "\(rowData![indexPath.row].sets)"
        exerciseCell.exerciseRestPeriod.text = "\(rowData![indexPath.row].restPeriod) seconds"
        
        return exerciseCell
    }
    

}
