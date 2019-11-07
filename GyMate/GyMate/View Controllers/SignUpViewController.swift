//
//  SignUpViewController.swift
//  GyMate
//
//  Created by Ben Sykes on 2019-11-07.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var txtUsername : UITextField!
    @IBOutlet var txtEmail : UITextField!
    @IBOutlet var txtPassword : UITextField!
    @IBOutlet var txtConfirmPassword : UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func userWantsSignUp(sender: UIButton!) {
        let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if txtUsername.text!.isEmpty || txtEmail.text!.isEmpty || txtPassword.text!.isEmpty || txtConfirmPassword.text!.isEmpty {
            // error: field missing
            let alertSheet : UIAlertController = UIAlertController(title: "Error", message: "we found a missing field...", preferredStyle: .actionSheet)
            
            alertSheet.addAction(UIAlertAction(title: "Oops", style: .default, handler: nil))
            
            self.present(alertSheet, animated: true) // Show error message
        } else {
            if txtPassword.text == txtConfirmPassword.text {
                // Perform auth sign up
                mainDelegate.createUser(email: txtEmail.text!, password: txtPassword.text!, username: txtUsername.text!)
                
                self.performSegue(withIdentifier: "SignUpToQuizSegue", sender: nil)
            } else {
                // error: passwords don't match
                let alertSheet : UIAlertController = UIAlertController(title: "Error", message: "Passwords entered don't match...", preferredStyle: .actionSheet)
                
                alertSheet.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                
                self.present(alertSheet, animated: true) // Show error message
            }
        }
    }

}
