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
    var cardsShown:[MemoryCard] = [MemoryCard]()

    
    var cell = MemoryViewCell()
    
    static var defaultCardStrings:[String] = [
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
        "10"
        
    ];
    
    var numberOfMCards: Int {
        return mCards.count
    }
    
    func selectCard(cell : MemoryViewCell, mCard: MemoryCard) {
        let firstCard = cardsShown.last
        
        if twoCardsShown() {
            // aufgedeckte karte mit zuvor aufgedeckter vergleichen
            if mCard.equals(firstCard!) { // mcard.equals(firstCard)
                cardsShown.append(mCard)
            } else {
                
                cardsShown.removeLast()
                
                let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    cell.showCard(false, animated: true)
                    self.cell.showCard(false, animated: true)
                    
                }
               
            }
        } else {
            cardsShown.append(mCard)
            self.cell = cell
        }
        
        if threeCardsShown() {
            
        }

    }
    
    func newGame(cardsData: [String]) {
        isPlaying = true
        cell = MemoryViewCell()
        
 //       let cardsData = randomCards(cardsData)
 //       for n in mCards {
 //       cell.setCard(mCard: cell, cellText: cardsData[n])
 //       }
    }
    
    func endGame() {
        isPlaying = false
        
        // save deck?
    }
    
    func wonGame() {
        // all cards gone -> won the game
        isPlaying = false
        print("Yay You Won")
    }
    func unpairedCard() -> MemoryCard? {
        let unpairedCard = cardsShown.last
        return unpairedCard
    }
    func twoCardsShown() -> Bool {
        return cardsShown.count % 2 != 0
    }
    func threeCardsShown() -> Bool {
        return cardsShown.count % 3 != 0
    }

    func indexForCard(_ card: MemoryCard) -> Int? {
        for index in 0...mCards.count-1 {
            if card === mCards[index] {
                return index
            }
        }
        return nil
    }
    
    
}
