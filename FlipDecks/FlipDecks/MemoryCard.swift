//
//  MemoryCard.swift
//  FlipDecks
//
//  Created by Bea Sax on 19.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import Foundation
import UIKit

class MemoryCard {
    
    var frontCellText = ""
    var id = Card(question: "", answer: "", correctCount: 0, incorrectCount: 0)
    
    
    init(cellText: String, id: Card){
        self.frontCellText = cellText
        self.id = id
    }

    
    func equals(_ mCard: MemoryCard) -> Bool {
        return false
        // if id.mcard.answer/question = id.firstCard -> equal
    }
}
