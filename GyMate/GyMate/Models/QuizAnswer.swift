//
//  QuizAnswer.swift
//  GyMate
//
//  Created by Ben Sykes on 2019-11-09.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit

class QuizAnswer: NSObject {
    // All the possible answer stereotypes for questions in body type quiz
    enum AnswerType : String {
        case MALE
        case FEMALE
        case ECTOMORPH
        case ENDOMORPH
        case MESOMORPH
    }
    
    // Let answer type be the answertype for this answer
    var ansType : AnswerType = AnswerType.ECTOMORPH
    var ansWeight : Float = 0.0 // The weight for this answer as used in confidence calculation
    
    /// Initialize the QuizAnswer instance
    init(ansType : AnswerType, ansWeight : Float) {
        self.ansType = ansType
        self.ansWeight = ansWeight
    }
}
