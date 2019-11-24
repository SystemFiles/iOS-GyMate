//
//  AddWorkoutViewController.swift
//  GyMate
//
//  Created by Liam Stickney on 2019-11-21.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
import Firebase

class AddWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var exerciseTable : UITableView!
    @IBOutlet var txtName : UITextField!
    @IBOutlet var txtDesc : UITextField!
    @IBOutlet var btnAdd : UIButton!
    
    let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.progressExerciseList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let exerciseCell : ExerciseTableViewCell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell") as? ExerciseTableViewCell ?? ExerciseTableViewCell(style: .default, reuseIdentifier: "exerciseCell")
        
        let rowData = mainDelegate.progressExerciseList
        
        exerciseCell.exerciseName.text = rowData![indexPath.row].name as! String
        
        // TO BE CONTINUED...
        return exerciseCell
    }
    

}
