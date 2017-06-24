//
//  Card.swift
//  FlipDecks
//
//  Created by Nicola Greth on 04.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import Foundation

//Class Card (part of Deck)
class Card {
    var question = ""
    var answer = ""
    var correctCount = 0
    var incorrectCount = 0
    var secondsSpentOnCard = 0
    
    //new card
    init(question: String, answer: String, correctCount : Int, incorrectCount : Int, secondsSpentOnCard : Int) {
        self.question = question
        self.answer = answer
        self.correctCount = correctCount
        self.incorrectCount = incorrectCount
        self.secondsSpentOnCard = secondsSpentOnCard
    }
    
    //returns question of card
    func getQuestion() -> String {
        return self.question
    }
    
    //returns answer of card
    func getAnswer() -> String {
        return self.answer
    }
    
    //stores result of card being played (not for time mode)
    func cardPlayed(result : String) {
        //increment either correct or incorrectCount
        if result == "correct" {
            self.correctCount += 1
        } else {
            self.incorrectCount += 1
        }
    }
    
    //stores result of card being played for time mode
    func cardPlayed(result : String, seconds : Int) {
        //increment either correct or incorrectCount
        if result == "correct" {
            self.correctCount += 1
        } else {
            self.incorrectCount += 1
        }
        self.secondsSpentOnCard = self.secondsSpentOnCard + seconds
    }
    
    //returns status of card (true if card has been correct at least 3 times, else false)
    func getFinishedStatus() -> Bool {
        if (self.correctCount >= 3 ) {
            return true
        }
        return false
    }
    
    //returns incorrect count of card
    func getIncorrectCount() -> Int {
        return self.incorrectCount
    }
    
    //returns correct count of card
    func getCorrectCount() -> Int {
        return self.correctCount
    }
    
    //resets counts for this card
    func resetCounts() {
        self.correctCount = 0
        self.incorrectCount = 0
        self.secondsSpentOnCard = 0
    }
    
    //returns the seconds spent on this card
    func getTimeSpentOnCard() -> Int {
        return self.secondsSpentOnCard
    }
}
