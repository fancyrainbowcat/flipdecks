//
//  MemoryGameViewController.swift
//  FlipDecks
//
//  Created by Bea Sax on 14.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    // Returns an array containing this sequence shuffled
    var shuffled: Array {
        var elements = self
        return elements.shuffle()
    }
   // Shuffles this sequence in place
    @discardableResult
    mutating func shuffle() -> Array {
        indices.dropLast().forEach {
            guard case let index = Int(arc4random_uniform(UInt32(count - $0))) + $0, index != $0 else { return }
            swap(&self[$0], &self[index])
        }
        return self
    }
    var chooseOne: Element { return self[Int(arc4random_uniform(UInt32(count)))] }
    func choose(_ n: Int) -> Array { return Array(shuffled.prefix(n)) }
}



class MemoryGameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var deck : Deck = Deck(name: "", languageName: "", fileEnding: "")
    var language : Language = Language(name: "")
    var backImage = ["mCardBack"]
    var answers: [MemoryCard] = [MemoryCard]()
    var questions: [MemoryCard] = [MemoryCard]()
    
    var finalMemoryCards = [MemoryCard]()
    
    
    
    let gameController = MemoryGame()

    
    //timer functionality
    var timeMode = false
    var timer : Timer?
    var secondsCount = 0
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeSpentLabel: UILabel!
    @IBOutlet weak var finishedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MemoryCollectionView.delegate = self
        self.MemoryCollectionView.dataSource = self
        self.finishedLabel.isHidden = true
        
        setupNewCards()
        
        //starts timer
        self.timeSpentLabel.isHidden = true

        if (timeMode == true && self.finalMemoryCards.count > 0) {
            //save overall seconds and start counter again
            self.secondsCount = 0
            self.timeLabel.text = "00:00:00"
            timeLabel.isHidden = false
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        } else {
            timeLabel.isHidden = true
        }
        
        //to determine when the Application is entering into background
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
        
        //to determine when the Application is terminated
        NotificationCenter.default.addObserver(self, selector: #selector(willTerminate), name: .UIApplicationWillTerminate, object: nil)

    }
    
    //function that will be called once the app is entering into background
    func willEnterBackground(_ notification: Notification) {
        self.deck.saveToFile()
    }
    
    //function that will be called once the app is terminated
    func willTerminate(_ notification: Notification) {
        self.deck.saveToFile()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return finalMemoryCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mcell = collectionView.dequeueReusableCell(withReuseIdentifier: "mCell", for: indexPath) as! MemoryViewCell

       
        //set Labels to cells
        startCards(finalMemoryCards[indexPath.row], mcell as MemoryViewCell)
        // set back image to cells
        mcell.cellImageView.image = UIImage(named: backImage[0]) // or if different images named: backImage[indexPath.row]
        
        mcell.showCard(false, animated: false)
        return mcell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MemoryViewCell
        
        if cell.shown { return }
        
        if (gameController.getCountCalled() < 2) {
            cell.showCard(true, animated: true)
            gameController.selectCard(cell : cell, mCard: cell.mCard!, time: self.secondsCount, timeMode: timeMode)
        }
        collectionView.deselectItem(at: indexPath, animated:true)
        
        if (gameController.gameWon()) {
            if (timeMode == true) {
                timer?.invalidate()
            }
            //time mode functionality
            if (timeMode == true) {
                let (secondsStr, minutesStr, hoursStr) = splitSeconds(secondsCount: secondsCount)
                self.timeSpentLabel.text = "Time spent in modus: \(hoursStr):\(minutesStr):\(secondsStr)"
                self.timeSpentLabel.isHidden = false
            }
            self.MemoryCollectionView.isHidden = true
            self.finishedLabel.isHidden = false
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

    
    // TODO: Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let numberOfColumns:Int = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
        
        let itemWidth: CGFloat = collectionView.frame.width / 3.0 - 15.0 //numberOfColumns as CGFloat - 10 //- (minimumInteritemSpacing * numberOfColumns))
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    

    
    func setupNewCards() {
        let notFinishedCards = self.deck.returnAllNotFinishedCards()
        if (notFinishedCards.count >= 6) {
            let mCards = notFinishedCards.choose(6)
            self.finalMemoryCards = divideCards(cards: mCards)
        } else if (notFinishedCards.count > 1) {
            self.MemoryCollectionView.isHidden = true
            self.finishedLabel.text = "More than \(notFinishedCards.count) cards needed"
            self.finishedLabel.isHidden = false
        } else {
            self.MemoryCollectionView.isHidden = true
            self.finishedLabel.text = "More than 1 card needed"
            self.finishedLabel.isHidden = false
        }
    }
    
    func divideCards(cards:[Card]) -> [MemoryCard] {
       // split dat array in questions and answers!
        for card in cards {
            let answer = card.getAnswer()
            let question = card.getQuestion()
            
            answers.append(MemoryCard(cellText: answer, id: card))
            questions.append(MemoryCard(cellText: question, id: card))
        }
        // shuffle both of the arrays
        questions.shuffle()
        answers.shuffle()
        
        // combine them to one wonderful Array
        var finalMemoryCards = questions + answers
        // shuffle it again - MAXIMUM SHUFFLE
        finalMemoryCards.shuffle()
        
    
        return finalMemoryCards
    }
    
    func startCards (_ mCard: MemoryCard, _ cell: MemoryViewCell) {
        cell.setCard(mCell:cell, cellText: mCard.frontCellText, mCard: mCard)
    }

    // IBOutlets
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var MemoryCollectionView: UICollectionView!

}

