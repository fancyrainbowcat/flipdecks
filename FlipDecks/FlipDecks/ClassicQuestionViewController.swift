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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //only not finished cards are relevant
        currentCards = self.deck.returnAllNotFinishedCards()
        currentCards.shuffle()
        Continue.isHidden = true
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
        }
        else {
            strValue = "Congratulations!"
            QuestionLabel.text = strValue
            Correct.isHidden = true
            Incorrect.isHidden = true
            Shelve.isHidden = true
            Show.isHidden = true
            self.AnswerView.isHidden = true
        }
    }
    
    //Print answer on label
    @IBAction func printAnswer() {
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
        currentCards[currentCardIndex].cardPlayed(result: "incorrect")
        
        appendCard()
        currentCardIndex += 1
        printQuestion()
        self.QuestionView.isHidden = false
        self.AnswerView.isHidden = true
    }
    
    // Card correct
    @IBAction func cardCorrect() {
        currentCards[currentCardIndex].cardPlayed(result: "correct")

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
