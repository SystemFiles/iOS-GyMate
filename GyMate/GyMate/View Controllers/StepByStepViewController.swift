//
//  StepByStepViewController.swift
//  GyMate
//
//  Created by Malik Sheharyaar Talhat on 2019-11-29.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
import Firebase
import SpriteKit

class StepByStepViewController: UIViewController {
    
    var seconds = 30
    var count = -1
    var setCount = 0
    var totalSets = 0
    var timer = Timer()
    
    @IBOutlet var sceneView: SKView!
    var scene:SpriteScene?
    @IBOutlet var lblTimer: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var lblSets: UILabel!
    @IBOutlet var lblExerciseTitle: UILabel!
    @IBOutlet var lblCount: UILabel!
    @IBOutlet var startOutlet: UIButton!
    @IBOutlet var stopOutlet: UIButton!
    @IBOutlet var nextOutlet: UIButton!
    
    @IBAction func start (sender: Any){

        self.count = 0
        self.setCount = self.totalSets
        updateFromDB()
        self.lblTimer.text = " "
        nextOutlet.isHidden = false
        stopOutlet.isHidden = true
        startOutlet.isHidden = true
    }
    @objc func counter()
    {
        seconds -= 1
        lblTimer.text = String(seconds) + " Seconds"
        
        if (seconds == 0)
        {
            timer.invalidate()
            stopOutlet.isHidden = true
            startOutlet.isHidden = true
            nextOutlet.isHidden = false
        }
        if let scene = self.scene {
            scene.starScene()
    
        }
    }
    
    @IBAction func stop (sender: Any){
        
        timer.invalidate()
        seconds = 30
        self.lblTimer.text = ""
        stopOutlet.isHidden = true
        startOutlet.isHidden = true
        nextOutlet.isHidden = false
    }
    @IBAction func next (sender: Any){
        
        nextOutlet.isHidden = true
        startOutlet.isHidden = true
        lblTimer.text = "Loading..."
        let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)
        
        if setCount < 0{
            if count < 5 {
                count += 1
                ref.child("workouts/recommended").observeSingleEvent(of: .value, with: { snapshot in
                    
                    let name = snapshot.childSnapshot(forPath: "exercises/\(self.count)/name").value  as! String
                    self.lblExerciseTitle.text = name
                    
                    let sets = snapshot.childSnapshot(forPath: "exercises/\(self.count)/sets").value  as! Int
                    self.totalSets = sets
                    self.setCount = self.totalSets
                    self.setCount -= 1
                    self.lblSets.text = String(self.setCount+1)
                    
                    
                    let desc = snapshot.childSnapshot(forPath: "exercises/\(self.count)/desc").value  as! String
                    
                    self.lblDesc.text = desc
                    
                    let restPeriod = snapshot.childSnapshot(forPath: "exercises/\(self.count)/restPeriod").value  as! Int
                    self.seconds = restPeriod
                    
                })
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StepByStepViewController.counter), userInfo: nil, repeats: true)
                lblCount.text = String(count+1)
                
            }else
            {
                //Controller dissmissed until workout summary is implemented
                presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }else{
            updateFromDB()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(StepByStepViewController.counter), userInfo: nil, repeats: true)
            lblCount.text = String(count+1)
        }
        stopOutlet.isHidden = false

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextOutlet.isHidden = true
        stopOutlet.isHidden = true
       
        let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)
        ref.child("workouts/recommended").observeSingleEvent(of: .value, with: { snapshot in
            
            if self.count == -1 {
                let name = snapshot.childSnapshot(forPath: "name").value  as! String
                 self.lblExerciseTitle.text = name
                 
                 let sets = snapshot.childSnapshot(forPath: "exercises/0/sets").value  as! Int
                 self.totalSets = sets
                 self.lblSets.text = String(self.totalSets)
                 let totalTime = snapshot.childSnapshot(forPath: "time").value  as! Int
                 self.lblTimer.text = String(totalTime) + "minutes"

                 let desc = snapshot.childSnapshot(forPath: "desc").value  as! String

                self.lblDesc.text = desc
            }

        })
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.scene = SpriteScene(size: CGSize(width: self.sceneView.frame.size.width, height: self.sceneView.frame.size.height))
        self.sceneView.presentScene(scene)
        
    }
    
    func updateFromDB() {
        /// Load data into label
        let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let ref = mainDelegate.userRef.child(Auth.auth().currentUser!.uid)
        

        ref.child("workouts/recommended").observeSingleEvent(of: .value, with: { snapshot in

            let name = snapshot.childSnapshot(forPath: "exercises/\(self.count)/name").value  as! String
            self.lblExerciseTitle.text = name
            
            self.setCount -= 1
            self.lblSets.text = String(self.setCount+1)
            
            
            let desc = snapshot.childSnapshot(forPath: "exercises/\(self.count)/desc").value  as! String

            self.lblDesc.text = desc

            
            let restPeriod = snapshot.childSnapshot(forPath: "exercises/\(self.count)/restPeriod").value  as! Int
            self.seconds = restPeriod

        })
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
