//
//  UIAnimatedButton.swift
//  GyMate
//
//  Created by Ben Sykes on 2019-12-01.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit

class UIAnimatedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configeBtn()
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        configeBtn()
    }

    // Setup handler for animated press
    func configeBtn() {
        self.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }

    @objc func buttonPressed(_ sender:UIButton) {
        // Perform Animation
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
            }, completion: nil)
        }
    }

}
