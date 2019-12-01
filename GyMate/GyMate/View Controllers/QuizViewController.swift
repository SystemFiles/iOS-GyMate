//
//  QuizViewController.swift
//  GyMate
//
//  Created by Ben Sykes on 2019-11-07.
//  Copyright © 2019 The Burrito Boys. All rights reserved.
//

import UIKit
import Firebase

class QuizViewController: UIViewController {

    @IBOutlet var lbQuestion : UILabel!
    @IBOutlet var btnOptOne : UIButton!
    @IBOutlet var btnOptTwo : UIButton!
    @IBOutlet var btnOptThree : UIButton!
    
    // Extras
    var quizObj : BodyTypeQuiz = BodyTypeQuiz()
    var currentQuestion : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup and start quiz
        self.setupQuiz()
        self.startQuiz()
    }
    
    @IBAction func optionSelected(sender: UIButton!) {
        
        // Make sure valid entry for first question (Since it is the only question with only 2 responses)
        if self.currentQuestion == 0 && sender.tag > 1 {
            return
        }
        
        // Animate Selection
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
                sender.transform = .identity
            }, completion: nil)
        }
        
        // Add answer to quiz obj
        self.quizObj.addAnswer(answer: self.quizObj.questions[self.currentQuestion].answerData[sender.tag])
        
        // Load next question unless end of quiz
        if (self.currentQuestion < (self.quizObj.questions.count - 1)) {
            loadNextQuestion()
        } else {
            // Finished answering the last question
            let mainDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            // Predict body type given question answers
            let bodyType : QuizAnswer.AnswerType = self.quizObj.predictBodyType()
            
            // Then store body type in data store
            mainDelegate.userRef.child(Auth.auth().currentUser!.uid).child("bodyType").setValue(bodyType.rawValue)
            
            // Take user to confirmation page
            self.performSegue(withIdentifier: "QuizConfirmationSegue", sender: nil)
        }
    }
    
    @IBAction func restartQuiz(sender: UIButton!) {
        self.resetQuizToStart()
    }
    
    @IBAction func rewindToQuizVC(sender: UIStoryboardSegue!) {
        self.resetQuizToStart()
    }
    
    func setupQuiz() {
        let questions : [Question] = [Question(question: "Are you", answers: ["Male", "Female"], answerData: [QuizAnswer(ansType: .ECTOMORPH, ansWeight: 0), QuizAnswer(ansType: .ECTOMORPH, ansWeight: 0)]),
                                      Question(question: "My shoulders are: ", answers: ["Wider than my hips", "The same width as my hips", "Narrower than my hips"], answerData: [QuizAnswer(ansType: .ENDOMORPH, ansWeight: 1.2),
                                                                                                                                                                                   QuizAnswer(ansType: .MESOMORPH, ansWeight: 1.2),
                                                                                                                                                                                   QuizAnswer(ansType: .ECTOMORPH, ansWeight: 1.2)]),
                                      Question(question: "A pair of relaxed-fit jeans fit me", answers: ["Tight around my glutes", "Perfect around my glutes", "Loose around my glutes"], answerData: [QuizAnswer(ansType: .ENDOMORPH, ansWeight: 1),
                                                                                                                                                                                                       QuizAnswer(ansType: .MESOMORPH, ansWeight: 1), QuizAnswer(ansType: .ECTOMORPH, ansWeight: 1)]),
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
        // Basically just load in the first question set
        lbQuestion.text = quizObj.questions[self.currentQuestion].question
        btnOptOne.setTitle(quizObj.questions[self.currentQuestion].answers[0], for: .normal)
        btnOptTwo.setTitle(quizObj.questions[self.currentQuestion].answers[1], for: .normal)
        btnOptThree.setTitle("", for: .normal)
    }
    
    func resetQuizToStart() {
        // Reset everything
        self.quizObj = BodyTypeQuiz()
        self.currentQuestion = 0
        setupQuiz()
        startQuiz()
    }
    
    func loadNextQuestion() {
        self.currentQuestion += 1
        
        // Load question
        lbQuestion.text = quizObj.questions[self.currentQuestion].question
        btnOptOne.setTitle(quizObj.questions[self.currentQuestion].answers[0], for: .normal)
        btnOptTwo.setTitle(quizObj.questions[self.currentQuestion].answers[1], for: .normal)
        btnOptThree.setTitle(quizObj.questions[self.currentQuestion].answers[2], for: .normal)
    }
}
