//
//  PasswordResetViewController.swift
//  GyMate
//
//  Created by Ben Sykes on 2019-11-07.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
import Firebase

class PasswordResetViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var txtEmail : UITextField!
    
    // Make sure text field returns so it does not block reset button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    /// HANDLE PASSWORD RESET (using firebase methods)
    @IBAction func sendPasswordReset(sender: UIButton!) {
        // Check email field
        if txtEmail != nil && !txtEmail.text!.isEmpty {
            Auth.auth().sendPasswordReset(withEmail: txtEmail.text!) { error in
                // Handle reset
                if let error = error {
                    let errorAlert : UIAlertController = UIAlertController(title: "Error", message: "There was a problem sending your request. \(error.localizedDescription)", preferredStyle: .actionSheet)
                    
                    errorAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(errorAlert, animated: true)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            let errorAlert : UIAlertController = UIAlertController(title: "Error", message: "Missing email...", preferredStyle: .actionSheet)
            
            errorAlert.addAction(UIAlertAction(title: "Oops :/", style: .default, handler: nil))
            self.present(errorAlert, animated: true)
        }
    }
    
}
