//
//  SelectWorkoutTableViewCell.swift
//  GyMate
//
//  Created by Liam Stickney on 2019-11-22.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit

class SelectWorkoutTableViewCell: UITableViewCell {
    //Workout title
    @IBOutlet var workoutTitle : UILabel!
    //Workout description
    @IBOutlet var workoutDesc : UILabel!
    //Workout time
    @IBOutlet var workoutTime : UILabel!
    //Workout cell background
    @IBOutlet var workoutBackgroundContainer : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Style the background to have shadows
        workoutBackgroundContainer.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
