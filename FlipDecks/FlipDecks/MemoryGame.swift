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
        let unpaired = unpairedCard()
        
        
        
        if unpairedCardShown() {
            print("here ucs")
            // aufgedeckte karte mit zuvor aufgedeckter vergleichen
            if mCard.equals() { // mcard.equals(firstCard)
            
            } else {
                
                let unpairedCard = cardsShown.removeLast()
                
                let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    print("here timedelay")
                    cell.hideCards([mCard, unpaired!])
                }
               
            }
        } else {
        cardsShown.append(mCard)
        }
        
      /*  if unpairedCardShown() {
            let unpaired = unpairedCard()!
            if mCard.equals() /* (unpaired) */ {
                cardsShown.append(mCard)
            } else {
                let unpairedCard = cardsShown.removeLast()
                
                let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    
         
                    
                }
            }
        } else {
            cardsShown.append(mCard)
        }
        
        if cardsShown.count == mCards.count {
            wonGame()
        } */

    }
    
    func newGame(cardsData: [String]) {
        isPlaying = true
        let cardsData = randomCards(cardsData)
  //      MemoryViewCell.setCard(cardsData)
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
    func unpairedCardShown() -> Bool {
        return cardsShown.count % 2 != 0
    }

    func indexForCard(_ card: MemoryCard) -> Int? {
        for index in 0...mCards.count-1 {
            if card === mCards[index] {
                return index
            }
        }
        return nil
    }
    func randomCards(_ cardsData:[String]) -> [String]{
    // here shuffle or split etc
        let cardsData = cardsData.choose(6)
        
        return cardsData
    }
    
    
}
