//
//  Deck.swift
//  FlipDecks
//
//  Created by Nicola Greth on 04.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import Foundation

//Class Deck/unit -> part of Language
class Deck {
    var name = ""
    var fileEnding = ""
    var listOfCards = [Card]()
    var languageName = ""
    
    //new Deck
    init(name: String, languageName: String, fileEnding: String) {
        self.name = name
        self.fileEnding = fileEnding
        self.languageName = languageName
        initializeDeck()
    }
    
    //initializes the deck with information from given file (only txt files are valid)
    func initializeDeck() {
        let fileName = self.name + fileEnding
        let filePath = Bundle.main.bundleURL.appendingPathComponent("Languages", isDirectory: true).appendingPathComponent(self.languageName, isDirectory: true).appendingPathComponent(fileName)
    
        do
        {
            let contents = try String(contentsOfFile: filePath.path)
            let lines = contents.components(separatedBy: "\n")
            
            for line in lines {
                if line != "" {
                    let elements = line.components(separatedBy: ";")
                    let newCard = Card(question: elements[0], answer: elements[1], correctCount: Int(elements[2])!, incorrectCount: Int(elements[3])!)
                    print("Deck.swift: Added new card: \(newCard.getQuestion()) with answer \(newCard.getAnswer())")
                    self.listOfCards.append(newCard)
                }
            }
        }
        catch
        {
            print("Deck.swift: Contents could not be loaded")
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
    
    //returns name of deck/ unit
    func getName() -> String {
        return self.name
    }
}
