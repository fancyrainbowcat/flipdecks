//
//  Language.swift
//  FlipDecks
//
//  Created by Nicola Greth on 04.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import Foundation

//Class Language -> part of list of languages in LanguagesTablesViewController
class Language {
    var name = "" 
    var listOfDecks = [Deck]()
    
    //new Language
    init(name: String) {
        self.name = name
        initializeLanguage()
    }
    
    //gets all decks for this language from folder
    func initializeLanguage() {
        let directoryURL = Bundle.main.bundleURL.appendingPathComponent("Languages", isDirectory:true).appendingPathComponent(self.name, isDirectory: true)
        do {
            let allFiles = try FileManager.default.contentsOfDirectory(atPath: directoryURL.path)
            for file in allFiles {
                let index = file.index(file.endIndex, offsetBy: -4)
                let fileWithoutEnding = file.substring(to: index)
                let fileEnding = file.substring(from: index)
                let newDeck = Deck(name: fileWithoutEnding, languageName: self.name, fileEnding: fileEnding)
                self.listOfDecks.append(newDeck)
            }
        } catch {
            print("Language.swift: There are no files for this language yet")
        }
    }
    
    //returns count of all decks
    func getCountOfDecks() -> Int {
        return listOfDecks.count
    }
    
    //return count of all finished decks
    func getCountOfFinishedDecks() -> Int {
        var countFinishedDecks = 0
        
        for deck in self.listOfDecks {
            if deck.getFinishedStatus() == true {
                countFinishedDecks += 1
            }
        }
        return countFinishedDecks
    }
    
    //returns all not-finished decks
    func returnAllNotFinishedDecks() -> [Deck] {
        var notFinishedDecks = [Deck]()
        for deck in self.listOfDecks {
            if deck.getFinishedStatus() == false {
                notFinishedDecks.append(deck)
            }
        }
        return notFinishedDecks
    }
    
    //returns all decks for this language
    func returnAllDecks() -> [Deck] {
        return listOfDecks
    }
    
    //returns name of language
    func getName() -> String {
        return self.name
    }
}
