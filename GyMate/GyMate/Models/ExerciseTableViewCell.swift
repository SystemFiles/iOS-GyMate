//
//  ExerciseTableViewCell.swift
//  GyMate
//
//  Created by Liam Stickney on 2019-11-23.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {
    
    
    @IBOutlet var exerciseName : UILabel!
    @IBOutlet var exerciseDesc : UILabel!
    @IBOutlet var exerciseReps : UILabel!
    @IBOutlet var exerciseSets : UILabel!
    @IBOutlet var exerciseRestPeriod : UILabel!
    @IBOutlet var exerciseBackgroundContainer : UIImageView!
    @IBOutlet var exerciseImage : UIImageView?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        exerciseBackgroundContainer.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
