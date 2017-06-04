//
//  Card.swift
//  FlipDecks
//
//  Created by Nicola Greth on 04.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import Foundation

class Card {
    var question = ""
    var answer = ""
    var correctCount = 0
    var incorrectCount = 0
    
    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
        self.correctCount = 0
        self.incorrectCount = 0
    }
    
    //returns question of card
    func getQuestion() -> String {
        return self.question
    }
    
    //returns answer of card
    func getAnswer() -> String {
        return self.answer
    }
    
    //stores result of card being played
    func cardPlayed(result : String) {
        if result == "correct" {
            self.correctCount += 1
        } else {
            self.incorrectCount += 1
        }
    }
    
    //returns status of card (true if card has been correct 3 times, else false)
    func getFinishedStatus() -> Bool {
        if (self.correctCount >= 3 ) {
            return true
        }
        return false
    }
}
