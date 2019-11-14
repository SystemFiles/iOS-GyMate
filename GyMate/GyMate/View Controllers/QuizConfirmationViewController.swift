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
        
        // Move to dashboard
        self.performSegue(withIdentifier: "QuizToDashboardSegue", sender: nil)
    }
    
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
