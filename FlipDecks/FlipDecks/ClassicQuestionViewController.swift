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
    var array = [String] ()
    var strValue = ""
    var currentCardIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deck.listOfCards.shuffle()
        printQuestion()
        
        
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
        strValue = deck.listOfCards[currentCardIndex].getQuestion()
        QuestionLabel.text = strValue
        Correct.isHidden = true
        Incorrect.isHidden = true
        Shelve.isHidden = false
        Show.isHidden = false
    }
    
    //Print answer on label
    @IBAction func printAnswer() {
        strValue = deck.listOfCards[currentCardIndex].getAnswer()
        AnswerLabel.text = strValue
        Shelve.isHidden = true
        Show.isHidden = true
        Correct.isHidden = false
        Incorrect.isHidden = false
        flip()
    }
    
    // Card incorrect
    @IBAction func cardIncorrect() {
        deck.listOfCards[currentCardIndex].cardPlayed(result: "")
        shelveCard()
        currentCardIndex += 1
        printQuestion()
        self.QuestionView.isHidden = false
        self.AnswerView.isHidden = true
    }
    
    // Card correct
    @IBAction func cardCorrect() {
        deck.listOfCards[currentCardIndex].cardPlayed(result: "correct")
        currentCardIndex += 1
        printQuestion()
        self.QuestionView.isHidden = false
        self.AnswerView.isHidden = true
    }
    
    
    // Shelve cards
    @IBAction func shelveCard() {
        let oldCard = deck.listOfCards[currentCardIndex]
        let newCard = Card(question: oldCard.getQuestion(), answer: oldCard.getAnswer(), correctCount: oldCard.getCorrectCount(), incorrectCount: oldCard.getIncorrectCount())
        deck.listOfCards.append(newCard)
        currentCardIndex += 1
        printQuestion()
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

   
    // Show previously played cards
    @IBAction func PreviousCard() {
        if currentCardIndex > 0 {
            currentCardIndex = currentCardIndex-1
            printQuestion()
            self.QuestionView.isHidden = false
            self.AnswerView.isHidden = true
        }
    }
    
    // IBOutlets
    
    @IBOutlet weak var AnswerLabel: UILabel!
    @IBOutlet weak var QuestionView: UIView!
    @IBOutlet weak var AnswerView: UIView!
    
    @IBOutlet weak var Show: UIButton!
    @IBOutlet weak var Incorrect: UIButton!
    @IBOutlet weak var Shelve: UIButton!
    @IBOutlet weak var Correct: UIButton!
    
}
