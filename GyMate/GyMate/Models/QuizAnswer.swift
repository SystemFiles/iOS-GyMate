//
//  QuizAnswer.swift
//  GyMate
//
//  Created by Ben Sykes on 2019-11-09.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit

class QuizAnswer: NSObject {
    enum AnswerType {
        case MALE
        case FEMALE
        case ECTOMORPH
        case ENDOMORPH
        case MESOMORPH
    }
    
    var ansType : AnswerType = AnswerType.ECTOMORPH
    var ansWeight : Float = 0.0
    
    func initWithData(ansType : AnswerType, ansWeight : Float) {
        self.ansType = ansType
        self.ansWeight = ansWeight
    }
}
