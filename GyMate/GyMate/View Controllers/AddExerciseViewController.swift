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
    
    let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func addExerciseToWorkout() {
        
        //TODO: change restperiod to some sort of multiplication between reps and sets
        let exercise : Exercise = Exercise(id: mainDelegate.exerciseID, name: txtName.text!, desc: txtDesc.text!, imgBodyDiagram: "", sets: Int(txtReps.text!)!, reps: Int(txtSets.text!)!, restPeriod: 20.0)
        
        //check if there's a better way of doing this
        mainDelegate.exerciseID += 1
        
        mainDelegate.progressExerciseList.append(exercise)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
