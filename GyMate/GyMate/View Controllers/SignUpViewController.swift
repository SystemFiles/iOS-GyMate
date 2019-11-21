//
//  SignUpViewController.swift
//  GyMate
//
//  Created by Ben Sykes on 2019-11-07.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtEmail : UITextField!
    @IBOutlet var txtPassword : UITextField!
    @IBOutlet var txtConfirmPassword : UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func userWantsSignUp(sender: UIButton!) {
        if txtUsername.text!.isEmpty || txtEmail.text!.isEmpty || txtPassword.text!.isEmpty || txtConfirmPassword.text!.isEmpty {
            // error: field missing
            let alertSheet : UIAlertController = UIAlertController(title: "Error", message: "oops! We found a missing field...", preferredStyle: .actionSheet)
            
            alertSheet.addAction(UIAlertAction(title: "Oops", style: .default, handler: nil))
            
            self.present(alertSheet, animated: true) // Show error message
        } else {
            if txtPassword.text == txtConfirmPassword.text {
                // Perform auth sign up
                self.createUser(email: txtEmail.text!, password: txtPassword.text!, username: txtUsername.text!)
            } else {
                // error: passwords don't match
                let alertSheet : UIAlertController = UIAlertController(title: "Error", message: "Passwords entered don't match...", preferredStyle: .actionSheet)
                
                alertSheet.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                
                self.present(alertSheet, animated: true) // Show error message
            }
        }
    }
    
    /**
        function for creating firebase auth user account for GyMate
     */
    func createUser(email : String, password : String, username: String) {
        let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil {
                Auth.auth().signIn(withEmail: email, password: password)
                
                // Create username data
                mainDelegate.userRef.child(Auth.auth().currentUser!.uid).child("username").setValue(username)
                mainDelegate.userRef.child(Auth.auth().currentUser!.uid).child("quizDone").setValue(false)
                
                self.performSegue(withIdentifier: "SignUpToQuizSegue", sender: nil)
            } else {
                // Error: User already exists
                let alertSheet : UIAlertController = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: .actionSheet)
                
                alertSheet.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                
                self.present(alertSheet, animated: true) // Show error message
            }
        }
    }

}
