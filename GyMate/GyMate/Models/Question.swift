//
//  Question.swift
//  GyMate
//
//  Created by Ben Sykes on 2019-11-08.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit

// The question class used in quiz
class Question: NSObject {
    var question : String = "" // The question text (ie: "What is your gender?")
    var answers : [String] = [] // A list of possible answers to the question in text form (FOR DISPLAY)
    var answerData : [QuizAnswer] = [] // The Answer data as used by the program
    
    // Initailize the Question
    init(question : String, answers : [String], answerData : [QuizAnswer]) {
        self.question = question
        self.answers = answers
        self.answerData = answerData
    }
}
