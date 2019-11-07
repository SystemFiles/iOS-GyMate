//
//  ViewController.swift
//  GyMate
//
//  Created by Ben Sykes on 2019-11-07.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtPassword : UITextField!
    
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
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                // Unsuccessful login shows error in credentials
                let errorAlert : UIAlertController = UIAlertController(title: "Failed to Login", message: "\(error.localizedDescription)", preferredStyle: .actionSheet)
                    
                errorAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                self.present(errorAlert, animated: true)
            } else {
                // Login succcess
                self.performSegue(withIdentifier: "LoginToDashboardSegue", sender: nil)
            }
        }
    }
}

