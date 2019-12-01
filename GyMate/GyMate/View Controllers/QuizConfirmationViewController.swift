//
//  QuizConfirmationViewController.swift
//  GyMate
//
//  Created by Ben Sykes on 2019-11-13.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
import Firebase

class QuizConfirmationViewController: UIViewController {
    @IBOutlet var lbBodyType : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateBodyTypeLabelFromDB()
    }
    
    @IBAction func rewindToQuizConfirmationVC(sender : UIStoryboardSegue!) {
        updateBodyTypeLabelFromDB()
    }
    
    @IBAction func confirmQuizResults() {
        // Change quiz completion to done for user
        let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        mainDelegate.userRef.child(Auth.auth().currentUser!.uid).child("quizDone").setValue(true)
        let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)
        
        // Assign a pre-built workout to the user
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let bodyType : String = snapshot.childSnapshot(forPath: "bodyType").value as! String
            
            /// Based on body type, set recommended workout
            switch bodyType {
            case "ECTOMORPH":
                ref.child("workouts").child("recommended").setValue(mainDelegate.predefinedWorkouts[0].getFBSerializedFormat())
            case "MESOMORPH":
                ref.child("workouts").child("recommended").setValue(mainDelegate.predefinedWorkouts[1].getFBSerializedFormat())
            case "ENDOMORPH":
                ref.child("workouts").child("recommended").setValue(mainDelegate.predefinedWorkouts[2].getFBSerializedFormat())
            default :
                print("Error: Had trouble assigning workout to user...ignoring it :/")
            }
            
            /// Move to dashboard (!Important that this is after setting recommended workout!)
            self.performSegue(withIdentifier: "QuizToDashboardSegue", sender: nil)
        })
        
        return // If any errors simply return to sender
    }
    
    /// Update label for body type if user decides to manually select their known body type instead of the auto generated quiz method
    func updateBodyTypeLabelFromDB() {
        /// Load data into label
        let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)
        
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let bodyType : String = snapshot.childSnapshot(forPath: "bodyType").value as! String
            self.lbBodyType.text = bodyType
        })
    }
}
