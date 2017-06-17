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
    
    var mCards = [Card]()
    var isPlaying: Bool = false
    
    var numberOfMCards: Int {
        return mCards.count
    }
    
    func selectCard() {
    
    }
    
    func newGame() {
        isPlaying = true
    }
    
    func endGame() {
        isPlaying = false
    }
    
    func wonGame() {
        // all cards gone -> won the game
        isPlaying = false
    }
    
}
