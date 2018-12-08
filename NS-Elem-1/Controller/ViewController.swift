//
//  ViewController.swift
//  NS-Elem-1
//
//  Created by Eric Hernandez on 12/2/18.
//  Copyright © 2018 Eric Hernandez. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerTxt: UITextField!
    @IBOutlet weak var chkBtn: UIButton!
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var questionNumberLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!
    
    let allQuestions = QuestionList()
    var questionNumber: Int = 0
    var randomPick: Int = 0
    var correctAnswers: Int = 0
    var numberAttempts: Int = 0
    var numberFailed: Int = 0
    
    var totalNumberOfQuestions: Int = 0
    var markedQuestionsCount: Int = 0
    var isTesting: Bool = true
    var isLoadedTrackedQuestions: Bool = false
    
    
    var timer = Timer()
    var counter = 0.0
    var isRunning = false
    
    var markedQuestions = [Question]()
    
    let congratulateArray = ["Great Job", "Excellent", "Way to go", "Alright", "Right on", "Correct", "Well done", "Awesome","Give me a high five"]
    let retryArray = ["Try again","Oooops"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        questionNumber = 0
        
        timerLbl.text = "\(counter)"
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        
        // Get a count of number of questions
        let numberOfQuestions = allQuestions.list
        // Get the size of the array
        totalNumberOfQuestions = numberOfQuestions.count
        //print(totalNumberOfQuestions)
        
        //answerTxt.isFirstResponder = true
        answerTxt.becomeFirstResponder()
        

    }

    @IBOutlet weak var checkBtn: UILabel!
    
    @objc func updateTimer(){
        counter += 0.1
        timerLbl.text = String(format:"%.1f",counter)
    }
    
    @IBAction func chkBtn(_ sender: Any) {
        
        let correctAnswer = allQuestions.list[questionNumber].answer
        
        if answerTxt.text == String(correctAnswer){
            //congratulate
            randomPositiveFeedback()
            
            //next Question
            nextQuestion()
            correctAnswers += 1
            numberAttempts += 1
            updateProgress()
            numberFailed = 0

        }
        else {
            numberFailed += 1
            readMe(myText: "Try again")
            answerTxt.text = ""
            numberAttempts += 1
            updateProgress()
        }
    }
   
    func readMe( myText: String) {
        let utterance = AVSpeechUtterance(string: myText )
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    func randomPositiveFeedback(){
        randomPick = Int(arc4random_uniform(9))
        readMe(myText: congratulateArray[randomPick])
        
    }
    
    func nextQuestion(){
        chkBtn .isEnabled = true
        answerTxt.text = ""
        answerTxt.textColor = (UIColor.black)
        questionNumber += 1
        
        if questionNumber <= totalNumberOfQuestions - 1  {
            //print(totalNumberOfQuestions)
            questionLbl.text = allQuestions.list[questionNumber].question
            questionNumberLbl.text = "Question #\(questionNumber + 1)"
            
        }
        else {
            isTesting = false
            timer.invalidate()
            readMe(myText: "Let us review")
            
            questionNumber = 0
            questionLbl.text = markedQuestions[questionNumber].question
            questionLbl.textColor = (UIColor.red)
            answerTxt.text = ""
            answerTxt.textColor = (UIColor.red)
            questionNumberLbl.text = ""
            
            
            
            
        }
    }
    
    func nextQuestionIsTesting(){
        chkBtn .isEnabled = true
        answerTxt.text = ""
        answerTxt.textColor = (UIColor.black)
        questionNumber += 1
        
        if questionNumber <= totalNumberOfQuestions - 1  {
            //print(totalNumberOfQuestions)
            questionLbl.text = allQuestions.list[questionNumber].question
            questionNumberLbl.text = "Question #\(questionNumber + 1)"

        }
        else {
            chkBtn .isEnabled = false
            let alert = UIAlertController(title: "Awesome", message: "You've finished all the questions, do you want to start over again?", preferredStyle: .alert)
            
            let restartAction = UIAlertAction(title: "Restart", style: .default, handler: { (UIAlertAction) in
                self.startOver()
                
            })
            
            alert.addAction(restartAction)
            present(alert, animated: true, completion: nil)

        }
    }

    
    func startOver(){
        
        isTesting = true
        
        questionNumber = 0
        questionNumberLbl.text = "Question #\(questionNumber + 1)"
        let firstAnswer = allQuestions.list[0].answer
        questionLbl.text = firstAnswer
        
        counter = 0
        timerLbl.text = "\(counter)"
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        
        
        // Get a count of number of questions
        let numberOfQuestions = allQuestions.list
        // Get the size of the array
        totalNumberOfQuestions = numberOfQuestions.count
        //print(totalNumberOfQuestions)
        
        answerTxt.textColor = (UIColor.black)
        questionLbl.textColor = (UIColor.black)
        correctAnswers = 0
        numberAttempts = 0
        updateProgress()
        
        chkBtn .isEnabled = true
        
    }

    func updateProgress(){
        progressLbl.text = "\(correctAnswers) / \(numberAttempts)"
    }
}

