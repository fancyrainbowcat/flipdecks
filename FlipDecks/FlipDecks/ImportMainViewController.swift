//
//  ImportMainViewController.swift
//  FlipDecks
//
//  Created by Nicola Greth on 03.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

//View Controller for main import options
class ImportMainViewController: UIViewController {

    // current deck and language (filled via segue)
    var deck : Deck = Deck(name: "", languageName: "", fileEnding: "")
    var language : Language = Language(name: "")
    var listOfLanguages = [Language]()
    
    @IBOutlet weak var toUnitButton: UIBarButtonItem!
    
    //you can only exit to unit if you came from a unit -> deckname should be filled
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.deck.getName() == "") {
            toUnitButton.isEnabled = false
            toUnitButton.title = ""
        } else {
            toUnitButton.isEnabled = true
            toUnitButton.title = "To Unit"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    //cancel button action
    @IBAction func cancelToImportMainViewController(segue:UIStoryboardSegue) {
    }
    
    //give deck and language to next controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "importToFile" {
            //since there is a navigation controller in between, I have to go through it
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.viewControllers.first as! OpenFileViewController
            controller.listOfLanguages = self.listOfLanguages
            controller.language = self.language
            controller.deck = self.deck
        }
        
        if segue.identifier == "importToManual" {
            //since there is a navigation controller in between, I have to go through it
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.viewControllers.first as! ManualInputViewController
            controller.listOfLanguages = self.listOfLanguages
            controller.language = self.language
            controller.deck = self.deck
        }
    }
}
