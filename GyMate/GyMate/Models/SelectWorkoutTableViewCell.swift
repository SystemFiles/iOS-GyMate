//
//  SelectWorkoutTableViewCell.swift
//  GyMate
//
//  Created by Liam Stickney on 2019-11-22.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit

class SelectWorkoutTableViewCell: UITableViewCell {
    
    @IBOutlet var workoutTitle : UILabel!
    @IBOutlet var workoutDesc : UILabel!
    @IBOutlet var workoutTime : UILabel!
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
