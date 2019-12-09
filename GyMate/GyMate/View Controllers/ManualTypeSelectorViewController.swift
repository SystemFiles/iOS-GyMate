//
//  ManualTypeSelectorViewController.swift
//  GyMate
//
//  Created by Ben Sykes on 2019-11-13.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
import Firebase

/// Created for manually selecting body type
class ManualTypeSelectorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // The types that are available
    let typeData : [String] = ["ECTOMORPH", "MESOMORPH", "ENDOMORPH"]
    var selected : Int = 0 // Keep track of index selected in pickerview
    
    // Dismiss the view
    @IBAction func dissmissView(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    // Store the new body type in datastore
    @IBAction func confirmSelection(sender: UIButton!) {
        let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Set body type manually
        mainDelegate.userRef.child(Auth.auth().currentUser!.uid).child("bodyType").setValue(typeData[selected])
    }
    
    /// BELOW IS REQUIRED METHODS FOR PICKERVIEW
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: typeData[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selected = row
    }

}
