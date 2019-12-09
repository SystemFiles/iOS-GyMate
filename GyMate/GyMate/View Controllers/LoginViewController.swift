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
    // View outlets
    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    
    var stayLoggedIn : Bool = false // Control whether the user wants to stay signed-in using Auto-Login feature
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// HANDLE AUTO-LOGIN AND FORWARD USER WITH AUTO-LOGIN TO PROPER VIEW
        let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        if mainDelegate.userDefault.bool(forKey: "usersignedin") {
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
    
    @IBAction func rewindToLoginVC(sender: UIStoryboardSegue!) {
        // clear inputs for return from rewind
        txtUsername.text = ""
        txtPassword.text = ""
    }
    
    /// For animating the check box and modifying the stayLoggedIn flag
    @IBAction func checkMarkTapped(_ sender: UIButton) {
        // Handle animation of button check
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
            }, completion: nil)
        }
        
        // Toggle stay logged in state
        self.stayLoggedIn = !self.stayLoggedIn
    }
    
    // Perform the login for the user
    @IBAction func performLogin(sender: UIButton!) {
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
    
    /// Support method for authorizing users in GyMate
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
                
                // Check if user wants to stay logged in
                if self.stayLoggedIn {
                    mainDelegate.userDefault.set(true, forKey: "usersignedin")
                    mainDelegate.userDefault.synchronize()
                }
                
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

