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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
