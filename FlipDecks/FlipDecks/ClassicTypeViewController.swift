//
//  ClassicTypeViewController.swift
//  FlipDecks
//
//  Created by Sabine Kaupp on 12.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit


class ClassicTypeViewController: UIViewController {
    
    // current deck and language
    var deck : Deck = Deck(name: "", languageName: "", fileEnding: "")
    var language : Language = Language(name: "")
    var array = [String] ()
    var strValue = ""
    var currentCardIndex = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        deck.listOfCards.shuffle()
        printQuestion()
        
        //to determine when the Application is entering into background
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
        
        //to determine when the Application is terminated
        NotificationCenter.default.addObserver(self, selector: #selector(willTerminate), name: .UIApplicationWillTerminate, object: nil)

    }
    
    //Print question on label
    @IBAction func printQuestion() {
        if (currentCardIndex < deck.getCountOfCards()) {
        strValue = deck.listOfCards[currentCardIndex].getQuestion()
        QuestionTypeLabel.text = strValue
        NextType.isHidden = true
        ShelveType.isHidden = false
        CheckType.isHidden = false
        }
        else {
        strValue = "Congratulations!"
        QuestionTypeLabel.text = strValue
        NextType.isHidden = true
        ShelveType.isHidden = true
        CheckType.isHidden = true
        }
    }
    
    //Print answer on label
    @IBAction func printAnswer() {
        strValue = deck.listOfCards[currentCardIndex].getAnswer()
        AnswerTypeLabel.text = strValue
        ShelveType.isHidden = true
        CheckType.isHidden = true
        NextType.isHidden = false
        flip()
    }
  
    
    
    //Flip Label
    func flip() {
        let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        
        UIView.transition(with: QuestionTypeView, duration: 1.0, options: transitionOptions, animations: {
            self.QuestionTypeView.isHidden = true
        })
        
        UIView.transition(with: AnswerTypeView, duration: 1.0, options: transitionOptions, animations: {
            self.AnswerTypeView.isHidden = false
        })
    }
    
    // Shelve cards
    @IBAction func shelveCard() {
        let oldCard = deck.listOfCards[currentCardIndex]
        let newCard = Card(question: oldCard.getQuestion(), answer: oldCard.getAnswer(), correctCount: oldCard.getCorrectCount(), incorrectCount: oldCard.getIncorrectCount())
        deck.listOfCards.append(newCard)
        currentCardIndex += 1
        printQuestion()
    }
    
    // Show previously played card
    @IBAction func PreviousCard() {
        if currentCardIndex > 0 {
            currentCardIndex = currentCardIndex-1
            printQuestion()
            self.QuestionTypeView.isHidden = false
            self.AnswerTypeView.isHidden = true
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Play next card
    @IBAction func playNextCard() {
        currentCardIndex += 1
        printQuestion()
        self.QuestionTypeView.isHidden = false
        self.AnswerTypeView.isHidden = true
    }

    // Check Input
    @IBAction func checkInput() {
    let userInput = String(describing: TextFieldType.text)
        if userInput == deck.listOfCards[currentCardIndex].getQuestion() {
        deck.listOfCards[currentCardIndex].cardPlayed(result: "correct")
        }
        else {
        deck.listOfCards[currentCardIndex].cardPlayed(result: "incorrect")
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

    @IBOutlet weak var AnswerTypeView: UIView!
    @IBOutlet weak var AnswerTypeLabel: UILabel!
    @IBOutlet weak var QuestionTypeView: UIView!
    @IBOutlet weak var QuestionTypeLabel: UILabel!
    
    @IBOutlet weak var ShelveType: UIButton!
    @IBOutlet weak var CheckType: UIButton!

    @IBOutlet weak var NextType: UIButton!
    @IBOutlet weak var TextFieldType: UITextField!
}
