//
//  BodyTypeQuiz.swift
//  GyMate
//
//  Created by Ben Sykes on 2019-11-08.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit

class BodyTypeQuiz: NSObject {
    var questions : [Question] = []
    var numQuestions : Int = 0
    var answers : [QuizAnswer] = []
    
    func initWithData(questions : [Question], numOfQuestions : Int) {
        self.questions = questions
        self.numQuestions = numOfQuestions
    }
    
    func addAnswer(answer : QuizAnswer) {
        answers.append(answer)
    }
    
    func predictBodyType() -> QuizAnswer.AnswerType {
        var isMale : Bool = true // Maybe do something with this later
        var ectomorphPoints : Float = 0
        var endomorphPoints : Float = 0
        var mesomorphPoints : Float = 0
        
        // For each answer check type and add (1 * weight bonus)
        for answer in self.answers {
            switch answer.ansType {
            case QuizAnswer.AnswerType.MALE:
                isMale = true
            case QuizAnswer.AnswerType.FEMALE:
                isMale = false
            case QuizAnswer.AnswerType.ECTOMORPH:
                ectomorphPoints += (1 * answer.ansWeight)
            case QuizAnswer.AnswerType.ENDOMORPH:
                endomorphPoints += (1 * answer.ansWeight)
            case QuizAnswer.AnswerType.MESOMORPH:
                mesomorphPoints += (1 * answer.ansWeight)
            }
        }
        
        let aggregatePoints = [ectomorphPoints, endomorphPoints, mesomorphPoints]
        let winnerIndex = aggregatePoints.firstIndex(of: aggregatePoints.max()!)
        
        switch winnerIndex {
        case 0:
            return QuizAnswer.AnswerType.ECTOMORPH
        case 1:
            return QuizAnswer.AnswerType.ENDOMORPH
        case 2:
            return QuizAnswer.AnswerType.MESOMORPH
        case .some(_):
            return QuizAnswer.AnswerType.ECTOMORPH
        case .none:
            return QuizAnswer.AnswerType.ECTOMORPH
        }
        
    }
}
