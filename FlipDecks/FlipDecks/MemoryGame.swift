//
//  MemoryGame.swift
//  FlipDecks
//
//  Created by Bea Sax on 17.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import Foundation
import UIKit

class MemoryGame {
    
    var mCards = [MemoryCard]()
    var isPlaying: Bool = false
    var isWon : Bool = false 
    var cardsShown:[MemoryCard] = [MemoryCard]()
    var countCalled = 0
    var cell = MemoryViewCell()
    
    //store times for time mode
    var times = [0]
    
    var numberOfMCards: Int {
        return mCards.count
    }
    
    func selectCard(cell : MemoryViewCell, mCard: MemoryCard, time: Int, timeMode : Bool) {
        countCalled += 1
        let firstCard = cardsShown.last
        
        if twoCardsShown() {
            // compare selected card with first picked card
            if mCard.equals(firstCard!) {
                cardsShown.append(mCard)
                
                //if time mode is activated store times for memory cards in times list + store result and time per card
                if (timeMode) {
                    if (timeMode) {
                        times.append(time)
                    }
                    //Seconds on this card 
                    let secondsSpent = times[times.count-1] - times[times.count-2]
                    mCard.id.cardPlayed(result: "correct", seconds: secondsSpent)
                } //if time mode is not activated store only result
                else {
                    mCard.id.cardPlayed(result: "correct")
                }
                countCalled = 0
            } else {
                cardsShown.removeLast()
                let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    cell.showCard(false, animated: true)
                    self.cell.showCard(false, animated: true)
                    self.countCalled = 0
                    
                    //if time mode is activated store times for memory cards in times list + store result and time per card
                    if (timeMode) {
                        if (timeMode) {
                            self.times.append(time)
                        }
                        //Seconds on this card
                        let secondsSpent = self.times[self.times.count-1] - self.times[self.times.count-2]
                        firstCard?.id.cardPlayed(result: "incorrect", seconds: secondsSpent)
                    } //if time mode is not activated store only result
                    else {
                        firstCard?.id.cardPlayed(result: "incorrect")
                    }
                }
            }
        } else {
            cardsShown.append(mCard)
            self.cell = cell
        }
        
        if cardsShown.count == 12 {
            wonGame()
        }
    }
    
    func newGame(cardsData: [String]) {
        isPlaying = true
        cell = MemoryViewCell()
        
    }
    
    func wonGame() {
        // all cards gone -> won the game
        isPlaying = false
        isWon = true
    }
    
    func gameWon() -> Bool {
        return isWon
    }
    
    func unpairedCard() -> MemoryCard? {
        let unpairedCard = cardsShown.last
        return unpairedCard
    }
    func twoCardsShown() -> Bool {
        return cardsShown.count % 2 != 0
    }
    
    func getCountCalled() -> Int {
        return countCalled
    }
    
    
}
