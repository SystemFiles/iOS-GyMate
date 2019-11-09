//
//  QuizViewController.swift
//  GyMate
//
//  Created by Ben Sykes on 2019-11-07.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    @IBOutlet var lbQuestion : UILabel!
    @IBOutlet var btnOptOne : UIButton!
    @IBOutlet var btnOptTwo : UIButton!
    @IBOutlet var btnOptThree : UIButton!
    @IBOutlet var btnOptFour : UIButton!
    
    // Extras
    var quizObj : BodyTypeQuiz = BodyTypeQuiz()
    var options : [UIButton] = []
    var currentQuestion : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        options = [btnOptOne, btnOptTwo, btnOptThree, btnOptFour]
        // Setup quiz
        
        // Setup and start quiz
        self.setupQuiz()
        self.startQuiz()
    }
    
    @IBAction func optionSelected(sender: UIButton!) {
        
    }
    
    func setupQuiz() {
        let questions : [Question] = [Question(question: "Are you", answers: ["Male", "Female"], answerData: [QuizAnswer(ansType: .ECTOMORPH, ansWeight: 0), QuizAnswer(ansType: .ECTOMORPH, ansWeight: 0)]),
                                      Question(question: "My shoulders are: ", answers: ["Wider than my hips", "The same width as my hips", "Narrower than my hips"], answerData: [QuizAnswer(ansType: .ENDOMORPH, ansWeight: 1.2),
                                                                                                                                                                                   QuizAnswer(ansType: .MESOMORPH, ansWeight: 1.2),
                                                                                                                                                                                   QuizAnswer(ansType: .ECTOMORPH, ansWeight: 1.2)]),
                                      Question(question: "A pair of relaxed-fit jeans fit me", answers: ["Tight around my glutes", "Perfect around my glutes", "Loose around my glutes"], answerData: [QuizAnswer(ansType: .ENDOMORPH, ansWeight: 1),
                                                                                                                                                                                                       QuizAnswer(ansType: .MESOMORPH, ansWeight: 1)]),
                                      Question(question: "My forearms look", answers: ["Big", "Average", "Small"], answerData: [QuizAnswer(ansType: .ENDOMORPH, ansWeight: 2),
                                                                                                                                QuizAnswer(ansType: .MESOMORPH, ansWeight: 2),
                                                                                                                                QuizAnswer(ansType: .ECTOMORPH, ansWeight: 2)]),
                                      Question(question: "My body tends to", answers: ["Carry fat", "Stay lean, yet muscular", "Stay skinny"], answerData: [QuizAnswer(ansType: .ENDOMORPH, ansWeight: 2),
                                                                                                                                                            QuizAnswer(ansType: .MESOMORPH, ansWeight: 2),
                                                                                                                                                            QuizAnswer(ansType: .ECTOMORPH, ansWeight: 2)]),
                                      Question(question: "My body looks", answers: ["Round and soft", "Square and rugged", "Long and Narrow"], answerData: [QuizAnswer(ansType: .ENDOMORPH, ansWeight: 1), QuizAnswer(ansType: .MESOMORPH, ansWeight: 1), QuizAnswer(ansType: .ECTOMORPH, ansWeight: 1)]),
                                      Question(question: "If I encircle my wrist with my other hand's middle finger and thumb", answers: ["The middle finger and thumb do not touch", "The middle finger and thumb just touch", "The middle finger and thumb overlap"], answerData: [QuizAnswer(ansType: .ENDOMORPH, ansWeight: 0.5),
                                                                                                                                                                                                                                                                                     QuizAnswer(ansType: .MESOMORPH, ansWeight: 0.5), QuizAnswer(ansType: .ECTOMORPH, ansWeight: 0.5)]),
                                      Question(question: "Concerning my weight, I", answers: ["Gain weight easily, but find it hard to lose", "I gain and lose weight easily", "I have trouble gaining weight"], answerData: [QuizAnswer(ansType: .ENDOMORPH, ansWeight: 1), QuizAnswer(ansType: .MESOMORPH, ansWeight: 1), QuizAnswer(ansType: .ECTOMORPH, ansWeight: 1)]),
                                      Question(question: "Which range best describes your chest measurements", answers: ["43 inches or more", "37-43 inches", "37 inches or less"], answerData: [QuizAnswer(ansType: .ENDOMORPH, ansWeight: 0.75), QuizAnswer(ansType: .MESOMORPH, ansWeight: 0.75), QuizAnswer(ansType: .ECTOMORPH, ansWeight: 0.75)])]
        quizObj.initWithData(questions: questions, numOfQuestions: questions.count)
    }
    
    func startQuiz() {
        while currentQuestion < quizObj.numQuestions {
            
        }
    }
}
