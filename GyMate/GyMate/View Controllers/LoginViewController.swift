//
//  ViewController.swift
//  GyMate
//
//  Created by Ben Sykes on 2019-11-07.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func rewindToLoginVC(sender: UIStoryboardSegue!) {
        // Do nothing.
    }
    
    @IBAction func performLogin(sender: UIButton!) {
        let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Check formatting and text field data
        if txtUsername.text!.isEmpty || txtPassword.text!.isEmpty {
            let errorAlert : UIAlertController = UIAlertController(title: "Error", message: "You left some fields empty!", preferredStyle: .actionSheet)
            errorAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
            self.present(errorAlert, animated: true)
        } else {
            // Perform login
            self.signInUser(email: txtUsername.text!, password: txtPassword.text!)
        }
    }
    
    func signInUser(email : String, password : String) {
        let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                // Unsuccessful login shows error in credentials
                let errorAlert : UIAlertController = UIAlertController(title: "Failed to Login", message: "\(error.localizedDescription)", preferredStyle: .actionSheet)
                    
                errorAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                self.present(errorAlert, animated: true)
            } else {
                // Login succcess
                
                // Get data for quiz completion
                var quizDone : Bool = false
                let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)
                
                // Async call to firebase realtime DB to check quiz completion
                ref.observeSingleEvent(of: .value, with: { snapshot in
                    quizDone = snapshot.childSnapshot(forPath: "quizDone").value as! Bool
                    
                    /// Check if user has completed quiz...if not, send user to quiz
                    if quizDone {
                        self.performSegue(withIdentifier: "LoginToDashboardSegue", sender: nil)
                    } else {
                        self.performSegue(withIdentifier: "LoginToQuizSegue", sender: nil)
                    }
                })
            }
        }
    }
}

