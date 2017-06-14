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
   
        printQuestion()
        
    }
    
    //Print question on label
    @IBAction func printQuestion() {
        strValue = deck.listOfCards[currentCardIndex].getQuestion()
        QuestionTypeLabel.text = strValue
        NextType.isHidden = true
        ShelveType.isHidden = false
        CheckType.isHidden = false
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
    }
    
    // Show previously played cards
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


    @IBOutlet weak var AnswerTypeView: UIView!
    @IBOutlet weak var AnswerTypeLabel: UILabel!
    @IBOutlet weak var QuestionTypeView: UIView!
    @IBOutlet weak var QuestionTypeLabel: UILabel!
    
    @IBOutlet weak var ShelveType: UIButton!
    @IBOutlet weak var CheckType: UIButton!

    @IBOutlet weak var NextType: UIButton!
    @IBOutlet weak var TextFieldType: UITextField!
}
