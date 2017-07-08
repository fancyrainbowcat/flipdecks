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

        PopUpViewQuiz.isHidden = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // DESIGN - Background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundDark.jpg")!)
        self.QuizAnswerView.backgroundColor = UIColor(patternImage: UIImage(named: "indexCard.jpg")!)
        self.QuizQuestionView.backgroundColor = UIColor(patternImage: UIImage(named: "indexCard.jpg")!)
        self.PopUpViewQuiz.backgroundColor = UIColor(patternImage: UIImage(named: "buttonBLight.png")!)
        
        
        //only not finished cards are relevant
        currentCards = self.deck.returnAllNotFinishedCards()
        currentCards.shuffle()
        ShelveQuiz.isHidden = false
        NextQuiz.isHidden = true
        QuizAnswerView.isHidden = true
        QuizQuestionView.isHidden = false
        ShowQuiz.isHidden = true
        ContinueQuiz.isHidden = true
        
        self.timeSpentLabel.isHidden = true
        
        if(timeMode == false) {
            timeLabel.isHidden = true
        } else {
            self.timeLabel.text = "00:00:00"
            timeLabel.isHidden = false
        }
        
        //this mode is only possible with more than 3 cards
        if (currentCards.count > 3) {
            printQuestion()
        } else  {
            QuestionQuizLabel.text = "4 cards needed for this modus"
            QuizAnswerView.isHidden = true
            QuizQuestionView.isHidden = false
            AnswerOne.isHidden = true
            AnswerTwo.isHidden = true
            AnswerThree.isHidden = true
            AnswerFour.isHidden = true
            ShelveQuiz.isHidden = true
            timeLabel.isHidden = true
        }
        
        //to determine when the Application is entering into background
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
        
        //to determine when the Application is terminated
        NotificationCenter.default.addObserver(self, selector: #selector(willTerminate), name: .UIApplicationWillTerminate, object: nil)
        
    }
    
    //Print question on label
    @IBAction func printQuestion() {
        if (currentCardIndex < currentCards.count) {
            strValue = currentCards[currentCardIndex].getQuestion()
            QuestionQuizLabel.text = strValue
            if (timeMode == true) {
                //starts timer
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            }
            pickRandomAnswer()
        }
        else {
            //time mode functionality
            if (timeMode == true) {
                let (secondsStr, minutesStr, hoursStr) = splitSeconds(secondsCount: secondsCount)
                self.timeSpentLabel.text = "Time spent in modus: \(hoursStr):\(minutesStr):\(secondsStr)"
                self.timeSpentLabel.isHidden = false
            }
            timeLabel.isHidden = true
            strValue = "Congratulations!"
            QuestionQuizLabel.text = strValue
            NextQuiz.isHidden = true
            AnswerOne.isHidden = true
            AnswerTwo.isHidden = true
            AnswerThree.isHidden = true
            AnswerFour.isHidden = true
            ShelveQuiz.isHidden = true
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Print answer on label
    @IBAction func printAnswer() {
        if (timeMode == true) {
            timer?.invalidate()
        }
        strValue = currentCards[currentCardIndex].getAnswer()
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
        AnswerOne.isHidden = false
        AnswerTwo.isHidden = false
        AnswerThree.isHidden = false
        AnswerFour.isHidden = false
        NextQuiz.isHidden = true
        ShelveQuiz.isHidden = false
        PopUpViewQuiz.isHidden = true
        printQuestion()
    }
    
    
    // pick random answers
    func pickRandomAnswer() {
        //use all cards to make sure that there are always more than 4 cards
        var interrimArray = [Card]()
        let allCards = self.deck.returnAllCards()
        
        for card in allCards {
            if (card.getQuestion() != currentCards[currentCardIndex].getQuestion() && card.getAnswer() != currentCards[currentCardIndex].getAnswer()) {
                interrimArray.append(card)
            }
        }
        
        var randomAnswerArray = interrimArray.choose(3)
        randomAnswerArray.append(currentCards[currentCardIndex])
        randomAnswerArray.shuffle()
    
        
        strValueOne = randomAnswerArray[0].getAnswer()
        AnswerOne.setTitle(strValueOne, for: .normal)
        strValueTwo = randomAnswerArray[1].getAnswer()
        AnswerTwo.setTitle(strValueTwo, for: .normal)
        strValueThree = randomAnswerArray[2].getAnswer()
        AnswerThree.setTitle(strValueThree, for: .normal)
        strValueFour = randomAnswerArray[3].getAnswer()
        AnswerFour.setTitle(strValueFour, for: .normal)
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
        if (currentCards[currentCardIndex].getAnswer() == strValueOne) {
            PopUpViewQuiz.isHidden = false
            PopUpCorrectLabelQuiz.isHidden = false
            PopUpIncorrectLabelQuiz.isHidden = true
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
        }
        else {
            PopUpViewQuiz.isHidden = false
            PopUpCorrectLabelQuiz.isHidden = true
            PopUpIncorrectLabelQuiz.isHidden = false
            if (timeMode == true) {
                let newSecondsCount = secondsCount - previousSecondsCount
                previousSecondsCount = secondsCount
                currentCards[currentCardIndex].cardPlayed(result: "incorrect", seconds: newSecondsCount)
            } else {
                currentCards[currentCardIndex].cardPlayed(result: "incorrect")
            }
            appendCard()
        }
        printAnswer()
        AnswerOne.isHidden = true
        AnswerTwo.isHidden = true
        AnswerThree.isHidden = true
        AnswerFour.isHidden = true
   }
    
    // Check Card Two
    @IBAction func checkCardTwo() {
        if (currentCards[currentCardIndex].getAnswer() == strValueTwo) {
            PopUpViewQuiz.isHidden = false
            PopUpCorrectLabelQuiz.isHidden = false
            PopUpIncorrectLabelQuiz.isHidden = true
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
        }
        else {
            PopUpViewQuiz.isHidden = false
            PopUpCorrectLabelQuiz.isHidden = true
            PopUpIncorrectLabelQuiz.isHidden = false
            if (timeMode == true) {
                let newSecondsCount = secondsCount - previousSecondsCount
                previousSecondsCount = secondsCount
                currentCards[currentCardIndex].cardPlayed(result: "incorrect", seconds: newSecondsCount)
            } else {
                currentCards[currentCardIndex].cardPlayed(result: "incorrect")
            }
            appendCard()
        }
        printAnswer()
        AnswerOne.isHidden = true
        AnswerTwo.isHidden = true
        AnswerThree.isHidden = true
        AnswerFour.isHidden = true
    }
    
    
    // Check Card Three
    @IBAction func checkCardThree() {
        if (currentCards[currentCardIndex].getAnswer() == strValueThree) {
            PopUpViewQuiz.isHidden = false
            PopUpCorrectLabelQuiz.isHidden = false
            PopUpIncorrectLabelQuiz.isHidden = true
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
        }
        else {
            PopUpViewQuiz.isHidden = false
            PopUpCorrectLabelQuiz.isHidden = true
            PopUpIncorrectLabelQuiz.isHidden = false
            if (timeMode == true) {
                let newSecondsCount = secondsCount - previousSecondsCount
                previousSecondsCount = secondsCount
                currentCards[currentCardIndex].cardPlayed(result: "incorrect", seconds: newSecondsCount)
            } else {
                currentCards[currentCardIndex].cardPlayed(result: "incorrect")
            }
            appendCard()
        }
        printAnswer()
        AnswerOne.isHidden = true
        AnswerTwo.isHidden = true
        AnswerThree.isHidden = true
        AnswerFour.isHidden = true
    }
    
    // Check Card Four
    @IBAction func checkCardFour() {
        if (currentCards[currentCardIndex].getAnswer() == strValueFour) {
            PopUpViewQuiz.isHidden = false
            PopUpCorrectLabelQuiz.isHidden = false
            PopUpIncorrectLabelQuiz.isHidden = true
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
        }
        else {
            PopUpViewQuiz.isHidden = false
            PopUpCorrectLabelQuiz.isHidden = true
            PopUpIncorrectLabelQuiz.isHidden = false
            if (timeMode == true) {
                let newSecondsCount = secondsCount - previousSecondsCount
                previousSecondsCount = secondsCount
                currentCards[currentCardIndex].cardPlayed(result: "incorrect", seconds: newSecondsCount)
            } else {
                currentCards[currentCardIndex].cardPlayed(result: "incorrect")
            }
            appendCard()
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
        if (timeMode == true) {
            timer?.invalidate()
        }
        appendCard()
        currentCards.remove(at:currentCardIndex)
        printQuestion()
    }
    
    @IBOutlet weak var BackQuiz: UIBarButtonItem!
    
    // Show previously played card
    @IBAction func PreviousCard() {
        if (timeMode == true) {
            timer?.invalidate()
        }
        if ShelveQuiz.isHidden == false {
            if currentCardIndex > 0 {
                currentCardIndex = currentCardIndex-1
                printQuestion()
                ShowQuiz.isHidden = false
                AnswerOne.isHidden = true
                AnswerTwo.isHidden = true
                AnswerThree.isHidden = true
                AnswerFour.isHidden = true
                NextQuiz.isHidden = true
                ShelveQuiz.isHidden = true
            }
        }
    }
    
    // Show Answer when Previous Card was played
    @IBAction func showAnswerForPreviousCard() {
        printAnswer()
        ShowQuiz.isHidden = true
        ContinueQuiz.isHidden = false
        NextQuiz.isHidden = true
    }
    
    //Continue Lecture
    @IBAction func continueLecture() {
        currentCardIndex += 1
        printQuestion()
        ShowQuiz.isHidden = true
        ContinueQuiz.isHidden = true
        AnswerOne.isHidden = false
        AnswerTwo.isHidden = false
        AnswerThree.isHidden = false
        AnswerFour.isHidden = false
        self.QuizAnswerView.isHidden = true
        self.QuizQuestionView.isHidden = false
        ShelveQuiz.isHidden = false
    }

    // Append current card to retry later
    @IBAction func appendCard() {
        currentCards.append(currentCards[currentCardIndex])
    }
    
    //function that will be called once the app is entering into background
    func willEnterBackground(_ notification: Notification) {
        self.deck.saveToFile()
    }
    
    @IBOutlet weak var PopUpIncorrectLabelQuiz: UILabel!
    @IBOutlet weak var PopUpCorrectLabelQuiz: UILabel!
    @IBOutlet weak var PopUpViewQuiz: UIView!
    @IBOutlet weak var ContinueQuiz: UIButton!
    @IBOutlet weak var ShowQuiz: UIButton!

    @IBOutlet weak var AnswerOne: UIButton!
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
