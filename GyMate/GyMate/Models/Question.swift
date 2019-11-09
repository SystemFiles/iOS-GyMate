//
//  Question.swift
//  GyMate
//
//  Created by Ben Sykes on 2019-11-08.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit

class Question: NSObject {
    var question : String = ""
    var answers : [String] = []
    
    func initWithData(question: String, answers : [String]) {
        self.question = question
        self.answers = answers
    }
}
