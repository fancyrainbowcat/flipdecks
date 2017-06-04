//
//  Deck.swift
//  FlipDecks
//
//  Created by Nicola Greth on 04.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import Foundation

class Deck {
    var name = ""
    var listOfCards = [Card]()
    
    init(name: String) {
        self.name = name
        initializeDeck()
    }
    
    //initializes the deck with information from given file (only txt files are valid)
    func initializeDeck() {
        if let filePath = Bundle.main.path(forResource: self.name, ofType: "txt")
        {
            do
            {
                let contents = try String(contentsOfFile: filePath)
                let lines = contents.components(separatedBy: "\n")
                
                for line in lines {
                    let elements = line.components(separatedBy: ";")
                    let newCard = Card(question: elements[0], answer: elements[1])
                    print("Deck.swift: Added new card: \(newCard.getQuestion) with answer \(newCard.getAnswer)")
                    self.listOfCards.append(newCard)
                }
            }
            catch
            {
                print("Deck.swift: Contents could not be loaded")
            }
        }
        else
        {
            print("Deck.swift: File not found")
        }
    }
    
    //returns count of all cards
    func getCountOfCards() -> Int {
        return listOfCards.count
    }
    
    //return count of all finished cards (finished card = 3x correct)
    func getCountOfFinishedCards() -> Int {
        var countFinishedCards = 0
        
        for card in self.listOfCards {
            if card.getFinishedStatus() == true {
                countFinishedCards += 1
            }
        }
        
        return countFinishedCards
    }
    
    //returns true if Deck is finished, false if not
    func getFinishedStatus() -> Bool {
        if self.getCountOfFinishedCards() == self.getCountOfCards() {
            return true
        }
        return false
    }
    
    //returns all not-finished cards 
    func returnAllNotFinishedCards() -> [Card] {
        var notFinishedCards = [Card]()
        for card in self.listOfCards {
            if card.getFinishedStatus() == false {
                notFinishedCards.append(card)
            }
        }
        return notFinishedCards
    }
    
    func getName() -> String {
        return self.name
    }
}
