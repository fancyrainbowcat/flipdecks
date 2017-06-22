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
    var strValueOne = ""
    var strValueTwo = ""
    var strValueThree = ""
    var strValueFour = ""
    var currentCardIndex = 0


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        deck.listOfCards.shuffle()
        printQuestion()
        ShelveQuiz.isHidden = false
        NextQuiz.isHidden = true
        QuizAnswerView.isHidden = true
        QuizQuestionView.isHidden = false
        
        //to determine when the Application is entering into background
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
        
        //to determine when the Application is terminated
        NotificationCenter.default.addObserver(self, selector: #selector(willTerminate), name: .UIApplicationWillTerminate, object: nil)
        
    }
    
    //Print question on label
    @IBAction func printQuestion() {
        if (currentCardIndex < deck.getCountOfCards()) {
            strValue = deck.listOfCards[currentCardIndex].getQuestion()
            QuestionQuizLabel.text = strValue
            pickRandomAnswer()
            }
        else {
            strValue = "Congratulations!"
            QuestionQuizLabel.text = strValue
            AnswerOneLabel.isHidden = true
            AnswerTwoLabel.isHidden = true
            AnswerThreeLabel.isHidden = true
            AnswerFourLabel.isHidden = true
            NextQuiz.isHidden = true
            AnswerOne.isHidden = true
            AnswerTwo.isHidden = true
            AnswerThree.isHidden = true
            AnswerFour.isHidden = true
            }
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Print answer on label
    @IBAction func printAnswer() {
        strValue = deck.listOfCards[currentCardIndex].getAnswer()
        AnswerQuizLabel.text = strValue
        ShelveQuiz.isHidden = true
        NextQuiz.isHidden = false
        flip()
    }

    // Play next Card
    @IBAction func playNextCard() {
        currentCardIndex += 1
        QuizQuestionView.isHidden = false
        QuizAnswerView.isHidden = true
        printQuestion()
        AnswerOne.isHidden = false
        AnswerTwo.isHidden = false
        AnswerThree.isHidden = false
        AnswerFour.isHidden = false
    }
    
    
    // pick random answers
    func pickRandomAnswer() {
    var interrimArray = deck.listOfCards
        interrimArray.remove(at: currentCardIndex)
    var randomAnswerArray = interrimArray.choose(3)
    randomAnswerArray.append(deck.listOfCards[currentCardIndex])
    randomAnswerArray.shuffle()
    strValueOne = randomAnswerArray[0].getAnswer()
    AnswerOneLabel.text = strValueOne
    strValueTwo = randomAnswerArray[1].getAnswer()
    AnswerTwoLabel.text = strValueTwo
    strValueThree = randomAnswerArray[2].getAnswer()
    AnswerThreeLabel.text = strValueThree
    strValueFour = randomAnswerArray[3].getAnswer()
    AnswerFourLabel.text = strValueFour
    }

    /*/ Select Answers
    func selectAnswer() {
        let tapOne = UITapGestureRecognizer(target: self, action: #selector(checkCardOne))
    AnswerOneLabel.isUserInteractionEnabled = true
    AnswerOneLabel.addGestureRecognizer(tapOne)
    AnswerTwoLabel.isUserInteractionEnabled = true
    AnswerThreeLabel.isUserInteractionEnabled = true
    AnswerFourLabel.isUserInteractionEnabled = true
    }
 */
    
    // Check Card One
    @IBAction func checkCardOne() {
        if (deck.listOfCards[currentCardIndex].getAnswer() == AnswerOneLabel.text) {
        deck.listOfCards[currentCardIndex].cardPlayed(result: "correct")
        }
        else {
        deck.listOfCards[currentCardIndex].cardPlayed(result: "")
        }
        printAnswer()
        AnswerOne.isHidden = true
        AnswerTwo.isHidden = true
        AnswerThree.isHidden = true
        AnswerFour.isHidden = true
   }
    
    // Check Card Two
    @IBAction func checkCardTwo() {
        if (deck.listOfCards[currentCardIndex].getAnswer() == AnswerTwoLabel.text) {
            deck.listOfCards[currentCardIndex].cardPlayed(result: "correct")
        }
        else {
            deck.listOfCards[currentCardIndex].cardPlayed(result: "")
        }
        printAnswer()
        AnswerOne.isHidden = true
        AnswerTwo.isHidden = true
        AnswerThree.isHidden = true
        AnswerFour.isHidden = true
    }
    
    
    // Check Card Three
    @IBAction func checkCardThree() {
        if (deck.listOfCards[currentCardIndex].getAnswer() == AnswerThreeLabel.text) {
            deck.listOfCards[currentCardIndex].cardPlayed(result: "correct")
        }
        else {
            deck.listOfCards[currentCardIndex].cardPlayed(result: "")
        }
        printAnswer()
        AnswerOne.isHidden = true
        AnswerTwo.isHidden = true
        AnswerThree.isHidden = true
        AnswerFour.isHidden = true
    }
    
    // Check Card Four
    @IBAction func checkCardFour() {
        if (deck.listOfCards[currentCardIndex].getAnswer() == AnswerFourLabel.text) {
            deck.listOfCards[currentCardIndex].cardPlayed(result: "correct")
        }
        else {
            deck.listOfCards[currentCardIndex].cardPlayed(result: "")
        }
        printAnswer()
        AnswerOne.isHidden = true
        AnswerTwo.isHidden = true
        AnswerThree.isHidden = true
        AnswerFour.isHidden = true
    }
    
    
    //Flip Label
    func flip() {
        let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        
        UIView.transition(with: QuizQuestionView, duration: 1.0, options: transitionOptions, animations: {
            self.QuizQuestionView.isHidden = true
        })
        
        UIView.transition(with: QuizAnswerView, duration: 1.0, options: transitionOptions, animations: {
            self.QuizAnswerView.isHidden = false
        })
        ShelveQuiz.isHidden = true
        NextQuiz.isHidden = false
    }
    
    
    
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
    
    @IBOutlet weak var AnswerOneLabel: UILabel!
    @IBOutlet weak var AnswerTwoLabel: UILabel!
    @IBOutlet weak var AnswerOne: UIButton!
    @IBOutlet weak var AnswerThreeLabel: UILabel!
    @IBOutlet weak var AnswerFourLabel: UILabel!
    @IBOutlet weak var AnswerTwo: UIButton!
    @IBOutlet weak var AnswerThree: UIButton!
    @IBOutlet weak var AnswerFour: UIButton!
    
    @IBOutlet weak var QuizAnswerView: UIView!
    @IBOutlet weak var QuizQuestionView: UIView!
    
    @IBOutlet weak var NextQuiz: UIButton!
    
    @IBOutlet weak var AnswerQuizLabel: UILabel!
    
    @IBOutlet weak var QuestionQuizLabel: UILabel!
    
    //function that will be called once the app is terminated
    func willTerminate(_ notification: Notification) {
        self.deck.saveToFile()
    }

}
