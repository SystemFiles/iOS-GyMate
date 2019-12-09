//
//  WorkOutViewController.swift
//  GyMate
//
//  Created by Malik Sheharyaar Talhat on 2019-11-29.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
import Firebase
///Display  a workout summary showing the time taken to complete the workout
class WorkOutViewController: UIViewController {
    //Workout Summary
    let mainDelegate : AppDelegate =
        UIApplication.shared.delegate as! AppDelegate
    var minutes = 0
    var seconds = 0
    
    @IBAction func dissmissView(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    //Outlet to display workout completion time
    @IBOutlet var lblTotalTimer: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        minutes = mainDelegate.totalTime / 60
        seconds = mainDelegate.totalTime % 60
        
        lblTotalTimer.text = "\(minutes) minutes and \(seconds) seconds"
        
    }

}
