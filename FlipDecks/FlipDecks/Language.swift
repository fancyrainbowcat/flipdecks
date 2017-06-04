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
    
    //language name and list of decks for this language
    var name = "" 
    var listOfDecks = [Deck]()
    
    //new Language
    init(name: String) {
        self.name = name
        initializeLanguage()
    }
    
    //gets all decks for this language from folder
    func initializeLanguage() {
        //URL of internal "Languages" folder where we store all data
        let directoryURL = Bundle.main.bundleURL.appendingPathComponent("Languages", isDirectory:true).appendingPathComponent(self.name, isDirectory: true)
        do {
            //loop over all files in this directory and append it as decks into listOfDecks (without fileEnding)
            let allFiles = try FileManager.default.contentsOfDirectory(atPath: directoryURL.path)
            for file in allFiles {
                //if it is really a file
                if file.contains(".") {
                    let index = file.index(file.endIndex, offsetBy: -4)
                    let fileWithoutEnding = file.substring(to: index)
                    let fileEnding = file.substring(from: index)
                    let newDeck = Deck(name: fileWithoutEnding, languageName: self.name, fileEnding: fileEnding)
                    self.listOfDecks.append(newDeck)
                }
            }
        } //should not be reached since we will create sample data
        catch {
            print("Language.swift: There are no files for this language yet")
        }
    }
    
    //returns count of all decks
    func getCountOfDecks() -> Int {
        return self.listOfDecks.count
    }
    
    //return count of all finished decks
    func getCountOfFinishedDecks() -> Int {
        var countFinishedDecks = 0
        
        //loop over all decks and count finished decks
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
        
        //loop over all decks and count unfinished decks
        for deck in self.listOfDecks {
            if deck.getFinishedStatus() == false {
                notFinishedDecks.append(deck)
            }
        }
        return notFinishedDecks
    }
    
    //returns all decks for this language
    func returnAllDecks() -> [Deck] {
        return self.listOfDecks
    }
    
    //returns name of language
    func getName() -> String {
        return self.name
    }
}
