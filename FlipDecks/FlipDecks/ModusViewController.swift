//
//  ModusViewController.swift
//  FlipDecks
//
//  Created by Nicola Greth on 04.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

//View Controller for all modi for one unit for one language
class ModusViewController: UIViewController {

    //current deck and language
    var deck : Deck = Deck(name: "", languageName: "", fileEnding: "")
    var language : Language = Language(name: "")
    
    //set title when view was loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(self.language.getName()) - \(self.deck.getName())"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //give language and unit to ExportStoryboardViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "modusToExport" {
            
            //since there is a navigation controller in between, I have to go through it 
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.viewControllers.first as! ExportStoryboardViewController
            controller.language = self.language
            controller.deck = self.deck
        }
        //give language and unit to ClassicQuestionViewController
        if segue.identifier == "modusToClassicQuestion" {
            
            //since there is a navigation controller in between, I have to go through it
            let controller = segue.destination as! ClassicQuestionViewController
            controller.language = self.language
            controller.deck = self.deck
        }
        //give language and unit to ClassicQuestionViewController
        if segue.identifier == "modusToClassicQuestion" {
            
            //since there is a navigation controller in between, I have to go through it
            let controller = segue.destination as! ClassicQuestionViewController
            controller.language = self.language
            controller.deck = self.deck
        }
        //give language and unit to ClassicTypeViewController
        if segue.identifier == "modusToClassicType" {
            
            //since there is a navigation controller in between, I have to go through it
            let controller = segue.destination as! ClassicTypeViewController
            controller.language = self.language
            controller.deck = self.deck
        }
        //give language and unit to QuizViewController
        if segue.identifier == "modusToQuizViewController" {
            
            //since there is a navigation controller in between, I have to go through it
            let controller = segue.destination as! QuizViewController
            controller.language = self.language
            controller.deck = self.deck
        }
        //give language and unit to QuizViewController
        if segue.identifier == "modusToMemoryGame" {
            
            //since there is a navigation controller in between, I have to go through it
            let controller = segue.destination as! MemoryGameViewController
            controller.language = self.language
            controller.deck = self.deck
        }
        
        //give language and unit to QuizViewController
        if segue.identifier == "modusToListAndSearch" {
            
            //since there is a navigation controller in between, I have to go through it
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.viewControllers.first as! ListAndSearchTableViewController
            controller.language = self.language
            controller.deck = self.deck
        }
    }
    
    //functionality for cancel button segue
    @IBAction func cancelToModusTableViewController(segue:UIStoryboardSegue) {
    self.deck.saveToFile()
    }
}
