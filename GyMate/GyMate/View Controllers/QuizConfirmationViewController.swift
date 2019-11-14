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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirmQuizResults() {
        // Change quiz completion to done for user
        let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        mainDelegate.userRef.child(Auth.auth().currentUser!.uid).child("quizDone").setValue(true)
        
        self.performSegue(withIdentifier: "QuizToDashboardSegue", sender: nil)
    }
}
