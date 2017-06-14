//
//  Deck.swift
//  FlipDecks
//
//  Created by Nicola Greth on 04.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import Foundation

extension MutableCollection where Indices.Iterator.Element == Index {
    
    // Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

//Class Deck/unit -> part of Language
class Deck {
    var name = ""
    var fileEnding = ""
    var listOfCards = [Card]()
    var languageName = ""
    var fileName = ""
    var filePath = URL(string:"")
    
    //new Deck
    init(name: String, languageName: String, fileEnding: String) {
        self.name = name
        self.fileEnding = fileEnding
        self.languageName = languageName
        refreshDeck()
    }
    
    //initializes the deck with information from given file (only txt files are valid)
    func refreshDeck() {
        //set fileName and filePath
        fileName = self.name + fileEnding
        
        if (fileName != "") {
            filePath = Bundle.main.bundleURL.appendingPathComponent("Languages", isDirectory: true).appendingPathComponent(self.languageName, isDirectory: true).appendingPathComponent(fileName)
    
            do
            {
                //get content of file and split it in lines
                let contents = try String(contentsOfFile: (filePath?.path)!)
                let lines = contents.components(separatedBy: "\n")
            
                //loop over lines and split into elements
                for line in lines {
                    if line != "" {
                        let elements = line.components(separatedBy: ";")
                    
                        //create a new card and append it to this deck
                        let newCard = Card(question: elements[0], answer: elements[1], correctCount: Int(elements[2])!, incorrectCount: Int(elements[3])!)
                    
                        //check if card is already in list
                        let checkCardExists = listOfCards.contains(where: { $0.getQuestion() == newCard.getQuestion() && $0.getAnswer() == newCard.getAnswer() })
                    
                        if(checkCardExists == false) {
                            self.listOfCards.append(newCard)
                        }
                    }
                }
            }
            catch
            {
                print("Deck.swift: Could not read content of file")
            }
        }
    }
    
    //returns count of all cards
    func getCountOfCards() -> Int {
        refreshDeck()
        return listOfCards.count
    }
    
    //return count of all finished cards (finished card = 3x correct)
    func getCountOfFinishedCards() -> Int {
        refreshDeck()
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
        refreshDeck()
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
        refreshDeck()
        return self.listOfCards
    }
    
    //returns name of deck/ unit
    func getName() -> String {
        return self.name
    }
    
    //returns most intense cards in deck 
    func returnMostIntenseCards() -> [Card] {
        refreshDeck()
        var mostIntenseCards = [Card]()
        for card in self.listOfCards {
            //card is intense when it has been incorrect for at least 3 times
            if card.getIncorrectCount() >= 3 {
                mostIntenseCards.append(card)
            }
        }
        return mostIntenseCards
    }
    
    //saves the current status in file 
    func saveToFile() {
        //remove deck
        do {
            try FileManager.default.removeItem(atPath: (filePath?.path)!)
        }
        catch let error as NSError {
            print("\(error)")
        }
        
        //write current data into content string
        var content = ""
        for card in listOfCards {
            content = content.appending("\(card.getQuestion());\(card.getAnswer());\(card.getCorrectCount());\(card.getIncorrectCount())\n")
        }
        //convert content string to data
        let contentData = content.data(using: .utf8)
        
        //recreate deck with current values
        FileManager.default.createFile(atPath: (filePath?.path)!, contents: contentData, attributes: nil)
    }
}
