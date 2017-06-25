//
//  ClassicQuestionViewController.swift
//  FlipDecks
//
//  Created by Sabine Kaupp on 06.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit


class ClassicQuestionViewController: UIViewController {
    
    // current deck and language
    var deck : Deck = Deck(name: "", languageName: "", fileEnding: "")
    var language : Language = Language(name: "")
    var strValue = ""
    var currentCardIndex = 0
    var currentCards = [Card]()
    
    //timer functionality
    var timeMode = false
    var timer : Timer?
    var secondsCount = 0
    var previousSecondsCount = 0
    
    @IBOutlet weak var timeSpentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //only not finished cards are relevant
        currentCards = self.deck.returnAllNotFinishedCards()
        currentCards.shuffle()
        Continue.isHidden = true
        self.timeSpentLabel.isHidden = true
        
        if(timeMode == false) {
            timeLabel.isHidden = true
        } else {
            timeLabel.isHidden = false
            timeLabel.text = "00:00:00"
        }
        
        printQuestion()
        
        //to determine when the Application is entering into background
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
        
        //to determine when the Application is terminated
        NotificationCenter.default.addObserver(self, selector: #selector(willTerminate), name: .UIApplicationWillTerminate, object: nil)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    @IBOutlet weak var QuestionLabel: UILabel!
    
    //Print question on label
    @IBAction func printQuestion() {
        if (currentCardIndex < currentCards.count) {
            strValue = currentCards[currentCardIndex].getQuestion()
            QuestionLabel.text = strValue
            Correct.isHidden = true
            Incorrect.isHidden = true
            Shelve.isHidden = false
            Show.isHidden = false
            self.AnswerView.isHidden = true
            
            //starts timer
            if (timeMode == true) {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            }
        }
        else {
            //time mode functionality 
            if (timeMode == true) {
                let (secondsStr, minutesStr, hoursStr) = splitSeconds(secondsCount: secondsCount)
                self.timeSpentLabel.text = "Time spent in modus: \(hoursStr):\(minutesStr):\(secondsStr)"
                self.timeSpentLabel.isHidden = false
            }
            self.timeLabel.isHidden = true
            strValue = "Congratulations!"
            QuestionLabel.text = strValue
            Correct.isHidden = true
            Incorrect.isHidden = true
            Shelve.isHidden = true
            Show.isHidden = true
            self.AnswerView.isHidden = true
        }
    }
    
    //transforms counts to double-digit number
    func transformToTime(count : Int) -> String {
        var countStr = ""
        
        if (count < 10) {
            countStr = "0\(count)"
        } else {
            countStr = String(count)
        }
        return countStr
    }
    
    //splits seconds into hours:minutes:seconds format
    func splitSeconds(secondsCount : Int) -> (String, String, String) {
        var minutes = 0
        var seconds = 0
        var hours = 0
        
        //calculates minutes out of seconds
        if (secondsCount >= 60) {
            minutes = secondsCount / 60
            seconds = secondsCount % 60
        } else {
            seconds = secondsCount
        }
    
        //calculates hours out of minutes
        if (minutes >= 60) {
            hours = minutes / 60
            minutes = minutes % 60
        }
    
        //transforms to string
        let secondsStr = transformToTime(count : seconds)
        let minutesStr = transformToTime(count : minutes)
        let hoursStr = transformToTime(count : hours)
    
        return (secondsStr, minutesStr, hoursStr)
    }
    
    //counts seconds per card
    func updateCounter() {
        secondsCount += 1
        
        let (secondsStr, minutesStr, hoursStr) = splitSeconds(secondsCount: secondsCount)
    
        //updates time Label
        self.timeLabel.text = "\(hoursStr):\(minutesStr):\(secondsStr)"
    }
    
    //Print answer on label
    @IBAction func printAnswer() {
        if (timeMode == true) {
            timer?.invalidate()
        }
        
        strValue = currentCards[currentCardIndex].getAnswer()
        AnswerLabel.text = strValue
        Shelve.isHidden = true
        Show.isHidden = true
        Correct.isHidden = false
        Incorrect.isHidden = false
        flip()
        if (Continue.isHidden == false) {
        Correct.isHidden = true
        Incorrect.isHidden = true
        Continue.tintColor = UIColor.blue
        }
    }
    
    // Card incorrect
    @IBAction func cardIncorrect() {
        if (timeMode == true) {
            let newSecondsCount = secondsCount - previousSecondsCount
            previousSecondsCount = secondsCount
            currentCards[currentCardIndex].cardPlayed(result: "incorrect", seconds: newSecondsCount)
        } else {
            currentCards[currentCardIndex].cardPlayed(result: "incorrect")
        }
        
        appendCard()
        currentCardIndex += 1
        printQuestion()
        self.QuestionView.isHidden = false
        self.AnswerView.isHidden = true
    }
    
    // Card correct
    @IBAction func cardCorrect() {
        if (timeMode == true) {
            let newSecondsCount = secondsCount - previousSecondsCount
            previousSecondsCount = secondsCount
            currentCards[currentCardIndex].cardPlayed(result: "correct", seconds: newSecondsCount)
        } else {
            currentCards[currentCardIndex].cardPlayed(result: "correct")
        }

        if (currentCards[currentCardIndex].getCorrectCount() < 3) {
            appendCard()
        }
        currentCardIndex += 1
        printQuestion()
        self.QuestionView.isHidden = false
        self.AnswerView.isHidden = true
    }
    
    
    // Shelve cards
    @IBAction func shelveCard() {
        if (timeMode == true) {
            timer?.invalidate()
        }
        appendCard()
        currentCardIndex += 1
        printQuestion()
    }
    
    // Append current card to retry later
    @IBAction func appendCard() {
        currentCards.append(currentCards[currentCardIndex])
    }
    
    //Flip Label
    func flip() {
        let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        
        UIView.transition(with: QuestionView, duration: 1.0, options: transitionOptions, animations: {
            self.QuestionView.isHidden = true
        })
        
        UIView.transition(with: AnswerView, duration: 1.0, options: transitionOptions, animations: {
            self.AnswerView.isHidden = false
        })
    }
    
    @IBOutlet weak var BackLabel: UIBarButtonItem!
    
    @IBOutlet weak var QuitLabel: UIBarButtonItem!

   
    // Show previously played card
    @IBAction func PreviousCard() {
        if (timeMode == true) {
            timer?.invalidate()
        }
        if currentCardIndex > 0 {
            currentCardIndex = currentCardIndex-1
            printQuestion()
            self.QuestionView.isHidden = false
            self.AnswerView.isHidden = true
            Incorrect.isHidden = true
            Correct.isHidden = true
            Continue.isHidden = false
            Continue.tintColor = UIColor.white
            Shelve.isHidden = true
        }
    }
    
    //function that will be called once the app is entering into background
    func willEnterBackground(_ notification: Notification) {
        self.deck.saveToFile()
    }
    
    //function that will be called once the app is terminated
    func willTerminate(_ notification: Notification) {
        self.deck.saveToFile()
    }
    
    // Continue after looking at previous card
    @IBAction func continueLecture() {
    currentCardIndex += 1
    printQuestion()
    Continue.isHidden = true
    Shelve.isHidden = false
    self.QuestionView.isHidden = false
    self.AnswerView.isHidden = true
    }
    
    // IBOutlets
    
    @IBOutlet weak var Continue: UIButton!
    
    @IBOutlet weak var AnswerLabel: UILabel!
    @IBOutlet weak var QuestionView: UIView!
    @IBOutlet weak var AnswerView: UIView!
    
    @IBOutlet weak var Show: UIButton!
    @IBOutlet weak var Incorrect: UIButton!
    @IBOutlet weak var Shelve: UIButton!
    @IBOutlet weak var Correct: UIButton!
    
}
