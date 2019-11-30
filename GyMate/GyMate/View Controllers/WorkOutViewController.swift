//
//  WorkOutViewController.swift
//  GyMate
//
//  Created by Malik Sheharyaar Talhat on 2019-11-29.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
import Firebase

class WorkOutViewController: UIViewController {
    //Workout Summary
    let mainDelegate : AppDelegate =
        UIApplication.shared.delegate as! AppDelegate
    var minutes = 0
    var seconds = 0
    
    @IBOutlet var lblTotalTimer: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        minutes = mainDelegate.totalTime / 60
        seconds = mainDelegate.totalTime % 60
        
        lblTotalTimer.text = "\(minutes) minutes and \(seconds) seconds"
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
