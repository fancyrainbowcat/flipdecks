//
//  ExportStoryboardViewController.swift
//  FlipDecks
//
//  Created by Nicola Greth on 04.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

//View Controller for exporting
class ExportStoryboardViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var allCardsButton: UIButton!
    @IBOutlet weak var mostIntenseCardsButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    //current deck and language 
    var deck : Deck = Deck(name: "", languageName: "", fileEnding: "")
    var language : Language = Language(name: "")
    
    //set title
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Export - \(self.deck.getName())"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //exports the given list of cards
    func export(listOfCards : [Card], modus: String) {
        //Directory Documents/FlipDecks/Export/...
        let exportDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("FlipDecks", isDirectory: true).appendingPathComponent("Export", isDirectory: true)
        
        //file name is always deckName_modus e.g. Unit1_All or Unit1_Intense
        let fileURL = exportDirURL.appendingPathComponent("\(self.deck.getName())_\(modus)").appendingPathExtension("csv")
        
        do {
            //this is only to test if directory exists
            try FileManager.default.contentsOfDirectory(atPath: exportDirURL.path)
            
            //writes all cards into content
            var content = ""
            
            //loop through all cards and append question and answer
            for card in listOfCards {
                content = content.appending("\(card.getQuestion());\(card.getAnswer())\n")
            }

            //convert content string to data
            let contentData = content.data(using: .utf8)
            
            //create the file and export content
            FileManager.default.createFile(atPath: fileURL.path, contents: contentData, attributes: nil)
            
            //send message that export was successful
            messageLabel.text = "Export for modus \(modus) created successfully"
            messageLabel.textColor = UIColor.green
            
            /*for logging purposes, this is where the export will be created at
            if you want to access this folder copy the URL and open a command window
            type: cd URL e.g. cd /Users/nicolagreth/Library/Developer/CoreSimulator/Devices/DD4410EE-83B0-45B9-9584-9CC740FDE3B7/data/Containers/Data/Application/9D101CBE-B59F-485A-BEEE-86D135B006E4/Documents/FlipDecks/Export/
            then type: open .
            this will open the finder so you can open the files with any program of your choice */
            print("ExportStoryboardViewController: Export created at \(exportDirURL)")
            
        } //in catch case the directory will be created because it only gets here if this does not exist
        catch {
            do {
                try FileManager.default.createDirectory(atPath: fileURL.path, withIntermediateDirectories: true, attributes: nil)
                
                //then call export function recursively to get into the do case
                export(listOfCards : listOfCards, modus : modus)
            } catch {
            }
        }
    }
    
    //export all cards in deck
    @IBAction func exportAllCards(_ sender: Any) {
        let listOfCards = deck.returnAllCards()
        export(listOfCards: listOfCards, modus: "All")
    }
    
    //export only most intense cards in deck
    @IBAction func exportMostIntenseCards(_ sender: Any) {
        let listOfCards = deck.returnMostIntenseCards()
        
        //if the listOfCards is empty there are no most intense cards yet 
        if listOfCards.isEmpty {
            messageLabel.text = "There are no most intense cards yet"
            messageLabel.textColor = UIColor.red
        } else {
            export(listOfCards: listOfCards, modus: "Intense")
        }
    }
}
