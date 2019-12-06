//
//  CompletedWorkoutTableViewCell.swift
//  GyMate
//
//  Created by Liam Stickney on 2019-12-06.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit

class CompletedWorkoutTableViewCell: UITableViewCell {
    
    @IBOutlet var lbTime : UILabel!
    @IBOutlet var lbName : UILabel!
    @IBOutlet var workoutBackgroundContainer : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        workoutBackgroundContainer.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
