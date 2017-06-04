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
        //set fileName and filePath
        let fileName = self.name + fileEnding
        let filePath = Bundle.main.bundleURL.appendingPathComponent("Languages", isDirectory: true).appendingPathComponent(self.languageName, isDirectory: true).appendingPathComponent(fileName)
    
        do
        {
            //get content of file and split it in lines
            let contents = try String(contentsOfFile: filePath.path)
            let lines = contents.components(separatedBy: "\n")
            
            //loop over lines and split into elements
            for line in lines {
                if line != "" {
                    let elements = line.components(separatedBy: ";")
                    
                    //create a new card and append it to this deck
                    let newCard = Card(question: elements[0], answer: elements[1], correctCount: Int(elements[2])!, incorrectCount: Int(elements[3])!)
                    self.listOfCards.append(newCard)
                }
            }
        }
        catch
        {
        
        }
        
    }
    
    //returns count of all cards
    func getCountOfCards() -> Int {
        return listOfCards.count
    }
    
    //return count of all finished cards (finished card = 3x correct)
    func getCountOfFinishedCards() -> Int {
        var countFinishedCards = 0
        
        //if status of card is finished append it
        for card in self.listOfCards {
            if card.getFinishedStatus() == true {
                countFinishedCards += 1
            }
        }
        return countFinishedCards
    }
    
    //returns true if whole Deck is finished, false if not
    func getFinishedStatus() -> Bool {
        if self.getCountOfFinishedCards() == self.getCountOfCards() {
            return true
        }
        return false
    }
    
    //returns all not-finished cards 
    func returnAllNotFinishedCards() -> [Card] {
        var notFinishedCards = [Card]()
        //if status of card is not finished append it
        for card in self.listOfCards {
            if card.getFinishedStatus() == false {
                notFinishedCards.append(card)
            }
        }
        return notFinishedCards
    }
    
    //returns all cards
    func returnAllCards() -> [Card] {
        return self.listOfCards
    }
    
    //returns name of deck/ unit
    func getName() -> String {
        return self.name
    }
    
    //returns most intense cards in deck 
    func returnMostIntenseCards() -> [Card] {
        var mostIntenseCards = [Card]()
        for card in self.listOfCards {
            //card is intense when it has been incorrect for at least 3 times
            if card.getIncorrectCount() >= 3 {
                mostIntenseCards.append(card)
            }
        }
        return mostIntenseCards
    }
}
