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
    
    //time mode status
    var timeMode : Bool = false

    //All IBOutlets
    @IBOutlet weak var timeModeButton: UIButton!
    @IBOutlet weak var resetUnitButton: UIButton!
    
    //set title + reset button when view was loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //enable reset button
        self.resetUnitButton.isUserInteractionEnabled = true
        self.resetUnitButton.setTitleColor(UIColor.orange, for: UIControlState.normal)
        
        //set title to Language - Deck
        self.title = "\(self.language.getName()) - \(self.deck.getName())"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //enable reset button
        self.resetUnitButton.isUserInteractionEnabled = true
        self.resetUnitButton.setTitleColor(UIColor.orange, for: UIControlState.normal)
    }
    
    //turn time mode on and off
    @IBAction func timeModeChanged(_ sender: Any) {
        //switch current status for time modus by click on button
        if (self.timeMode == true) {
            self.timeMode = false
            self.timeModeButton.setTitle("Time Mode: off", for: UIControlState.normal)
            self.timeModeButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        } else {
            self.timeMode = true
            self.timeModeButton.setTitle("Time Mode: on", for: UIControlState.normal)
            self.timeModeButton.setTitleColor(UIColor.green, for: UIControlState.normal)
        }
    }
    
    //security pop up for reset button
    @IBAction func showAlert() {
        let alert = UIAlertController (title: "Are you sure?", message: "This resets everything to zero!", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Cancel", style: .default,
                                   handler: nil)
        
        let cancel = UIAlertAction (title: "Yes", style: .default) { UIAlertAction in self.resetUnit(sender: (Any).self)}
        
        //possible actions
        alert.addAction(action)
        alert.addAction(cancel)
        
        //present pop up
        present(alert, animated: true, completion: nil)
    }
    
    //resets the unit
    @IBAction func resetUnit(_ sender: Any) {
        //set all counts to zero for all cards of current deck
        self.deck.resetAllCards()
        
        //disable reset button
        self.resetUnitButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
        self.resetUnitButton.isUserInteractionEnabled = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //give language and unit to the different modus controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //give language and unit to export controller
        if segue.identifier == "modusToExport" {
            //since there is a navigation controller in between, I have to go through it 
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.viewControllers.first as! ExportStoryboardViewController
            controller.language = self.language
            controller.deck = self.deck
        }
        //give language and unit to ClassicQuestionViewController
        if segue.identifier == "modusToClassicQuestion" {
            let controller = segue.destination as! ClassicQuestionViewController
            controller.language = self.language
            controller.deck = self.deck
            controller.timeMode = self.timeMode
        }
        //give language and unit to ClassicTypeViewController
        if segue.identifier == "modusToClassicType" {
            let controller = segue.destination as! ClassicTypeViewController
            controller.language = self.language
            controller.deck = self.deck
            controller.timeMode = self.timeMode
        }
        //give language and unit to QuizViewController
        if segue.identifier == "modusToQuizViewController" {
            let controller = segue.destination as! QuizViewController
            controller.language = self.language
            controller.deck = self.deck
            controller.timeMode = self.timeMode
        }
        //give language and unit to QuizViewController
        if segue.identifier == "modusToMemoryGame" {
            let controller = segue.destination as! MemoryGameViewController
            controller.language = self.language
            controller.deck = self.deck
            controller.timeMode = self.timeMode
        }
        
        //give language and unit to QuizViewController
        if segue.identifier == "modusToListAndSearch" {
            let controller = segue.destination as! ListAndSearchViewController
            controller.language = self.language
            controller.deck = self.deck
            controller.timeMode = self.timeMode 
        }
        
        //give language and unit to QuizViewController
        if segue.identifier == "modusToImport" {
            //since there is a navigation controller in between, I have to go through it
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.viewControllers.first as! ImportMainViewController
            controller.deck = self.deck
            controller.language = self.language

        }
        //give language and unit to PieChartViewController
        if segue.identifier == "StatisticsPerUnit" {
            //since there is a navigation controller in between, I have to go through it
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.viewControllers.first as! PieChartViewController
            controller.deck = self.deck
            controller.language = self.language
            
        }
        //give language and unit to BarChartViewController
        if segue.identifier == "StatisticsPerLanguage" {
            //since there is a navigation controller in between, I have to go through it
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.viewControllers.first as! BarChartViewController1
            controller.deck = self.deck
            controller.language = self.language
        }
    }
    
    //functionality for cancel button segue to modus view controller
    @IBAction func cancelToModusTableViewController(segue:UIStoryboardSegue) {
        //all data will be saved to file when a modus is cancelled 
        self.deck.saveToFile()
    }
}
