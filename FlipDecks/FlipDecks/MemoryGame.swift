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
    
    static var defaultCardLabels:[UILabel] = [
        UILabel()
    ];
    
    var numberOfMCards: Int {
        return mCards.count
    }
    
    func selectCard(mCard: MemoryCard) {
       
        
        if unpairedCardShown() {
            let unpaired = unpairedCard()!
            if mCard.equals() /* (unpaired) */ {
                cardsShown.append(mCard)
            } else {
                let unpairedCard = cardsShown.removeLast()
                
                let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    
                // hide both cards
                    
                }
            }
        } else {
            cardsShown.append(mCard)
        }
        
        if cardsShown.count == mCards.count {
            wonGame()
        }

    }
    
    func newGame(_ cardsData:[UILabel] ) {
        isPlaying = true
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
    func randomCards(_ cardsData:[UILabel]){
    // here shuffle or split etc
    }
    
    
}
