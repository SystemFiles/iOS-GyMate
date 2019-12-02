//
//  AddExerciseViewController.swift
//  GyMate
//
//  Created by Liam Stickney on 2019-11-23.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit

class AddExerciseViewController: UIViewController {
    
    @IBOutlet var txtName : UITextField!
    @IBOutlet var txtDesc : UITextField!
    @IBOutlet var txtReps : UITextField!
    @IBOutlet var txtSets : UITextField!
    @IBOutlet var sldRestPeriod : UISlider!
    @IBOutlet var lbRestPeriod : UILabel!
    @IBOutlet var btnAddExercise : UIButton!
    
    let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func textChanged(sender: UITextField!) {
        if !txtName.text!.isEmpty && !txtDesc.text!.isEmpty && !txtSets.text!.isEmpty && !txtReps.text!.isEmpty {
            btnAddExercise.isEnabled = true
        } else {
            btnAddExercise.isEnabled = false
        }
    }
    
    @IBAction func restPeriodChanged(sender: UISlider!) {
        lbRestPeriod.text = "\(Int(sender.value)) seconds"
    }
    
    @IBAction func addExerciseToWorkout() {
        
        if txtName.text == "" || txtDesc.text == "" || txtReps.text == "" || txtSets.text == "" {
            let errorAlert : UIAlertController = UIAlertController(title: "Error", message: "Missing required fields!", preferredStyle: .actionSheet)
            errorAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(errorAlert, animated: true)
        } else {
            let exercise : Exercise = Exercise(id: mainDelegate.exerciseID, name: txtName.text!, desc: txtDesc.text!, imgBodyDiagram: "", sets: Int(txtReps.text!)!, reps: Int(txtSets.text!)!, restPeriod: Double(Int(self.sldRestPeriod!.value)))

            mainDelegate.exerciseID += 1
            mainDelegate.progressExerciseList.append(exercise)
        }
    }

}
