//
//  QuizViewController.swift
//  FlipDecks
//
//  Created by Sabine Kaupp on 14.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
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
    
    @IBOutlet weak var QuestionQuizLabel: UILabel!
    
    //Print question on label
    @IBAction func printQuestion() {
        strValue = deck.listOfCards[currentCardIndex].getQuestion()
        QuestionQuizLabel.text = strValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    @IBOutlet weak var ShelveQuiz: UIButton!
    
    // Shelve cards
    @IBAction func shelveCard() {
        let oldCard = deck.listOfCards[currentCardIndex]
        let newCard = Card(question: oldCard.getQuestion(), answer: oldCard.getAnswer(), correctCount: oldCard.getCorrectCount(), incorrectCount: oldCard.getIncorrectCount())
        deck.listOfCards.append(newCard)
        currentCardIndex += 1
        printQuestion()
    }
    
    @IBOutlet weak var BackQuiz: UIBarButtonItem!
    
    // Show previously played card
    @IBAction func PreviousCard() {
        if currentCardIndex > 0 {
            currentCardIndex = currentCardIndex-1
            printQuestion()
        }
    }

    //function that will be called once the app is entering into background
    func willEnterBackground(_ notification: Notification) {
        self.deck.saveToFile()
    }
    
    @IBOutlet weak var AnswerOne: UIButton!
    @IBOutlet weak var AnswerTwo: UIButton!
    @IBOutlet weak var AnswerThree: UIButton!
    @IBOutlet weak var AnswerFour: UIButton!
    
    
    
    //function that will be called once the app is terminated
    func willTerminate(_ notification: Notification) {
        self.deck.saveToFile()
    }

}
