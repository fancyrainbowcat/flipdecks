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
        
        // DESIGN - Background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //exports the given list of cards
    func export(listOfCards : [Card], modus: String) {
        //Directory Documents
        let documentsFolderURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        //check if export directory exists at this point
        if (!FileManager.default.fileExists(atPath: documentsFolderURL.path)) {
            do {
                try FileManager.default.createDirectory(atPath: documentsFolderURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        }
        
        //file name is always deckName_modus e.g. Unit1_All or Unit1_Intense
        let fileURL = documentsFolderURL.appendingPathComponent("\(self.deck.getName())_\(modus)").appendingPathExtension("txt")
        
        //writes all cards into content
        var content = ""
        
        //loop through all cards and append question and answer
        for card in listOfCards.sorted(by: {$0.getQuestion() < $1.getQuestion()}) {
            content = content.appending("\(card.getQuestion());\(card.getAnswer())\n")
        }
        
        //convert content string to data
        let contentData = content.data(using: .utf8)
        
        //create the file and export content
        FileManager.default.createFile(atPath: fileURL.path, contents: contentData, attributes: nil)
        
        //send message that export was successful
        messageLabel.text = "Export created successfully"
        messageLabel.textColor = UIColor.green
    }
    
    //export all cards in deck
    @IBAction func exportAllCards(_ sender: Any) {
        let listOfCards = self.deck.returnAllCards()
        export(listOfCards: listOfCards, modus: "All")
    }
    
    //export only most intense cards in deck
    @IBAction func exportMostIntenseCards(_ sender: Any) {
        let listOfCards = self.deck.returnMostIntenseCards()
        
        //if the listOfCards is empty there are no most intense cards yet 
        if listOfCards.isEmpty {
            messageLabel.text = "There are no most intense cards yet"
            messageLabel.textColor = UIColor.red
        } else {
            export(listOfCards: listOfCards, modus: "Intense")
        }
    }
}
