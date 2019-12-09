//
//  BodyTypeQuiz.swift
//  GyMate
//
//  Created by Ben Sykes on 2019-11-08.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
import Firebase

class BodyTypeQuiz: NSObject {
    var questions : [Question] = [] // A list of all the questions in the quiz
    var numQuestions : Int = 0 // Keep track of the number of questions
    var answers : [QuizAnswer] = [] // A list of all current responses/answers by user
    
    // Initialize the model
    func initWithData(questions : [Question], numOfQuestions : Int) {
        self.questions = questions
        self.numQuestions = numOfQuestions
    }
    
    /// Add a user answer to the model
    func addAnswer(answer : QuizAnswer) {
        answers.append(answer)
    }
    
    /// Using data within the model, predict a body type that best fits the users responses to questions
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
                ectomorphPoints += (answer.ansWeight)
            case QuizAnswer.AnswerType.ENDOMORPH:
                endomorphPoints += (answer.ansWeight)
            case QuizAnswer.AnswerType.MESOMORPH:
                mesomorphPoints += (answer.ansWeight)
            }
        }
        // Aggregate everything in an array so that we can determine with most confidence the users body type
        let aggregatePoints = [ectomorphPoints, endomorphPoints, mesomorphPoints]
        let winnerIndex = aggregatePoints.firstIndex(of: aggregatePoints.max()!)
        
        // Before determining body type, store gender of user (might use for workout recommendations in the future)
        let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        mainDelegate.userRef.child(Auth.auth().currentUser!.uid).child("gender").setValue(isMale ? "Male" : "Female")
        
        // Make decision
        switch winnerIndex {
        case 0:
            return QuizAnswer.AnswerType.ECTOMORPH
        case 1:
            return QuizAnswer.AnswerType.ENDOMORPH
        case 2:
            return QuizAnswer.AnswerType.MESOMORPH
        case .some(_):
            return QuizAnswer.AnswerType.MESOMORPH
        case .none:
            return QuizAnswer.AnswerType.MESOMORPH
        }
        
    }
}
