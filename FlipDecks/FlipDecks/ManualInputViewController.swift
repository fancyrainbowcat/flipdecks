//
//  ManualInputViewController.swift
//  FlipDecks
//
//  Created by Nicola Greth on 03.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

//View Controller for manual input
class ManualInputViewController: UIViewController {

    //IBOutlets
    @IBOutlet weak var languageNameField: UITextField!
    @IBOutlet weak var deckNameField: UITextField!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //checks if language is already existent
    func checkForLanguageExistence(languageName : String) -> String {
        //URL of internal "Languages" folder
        let allLanguagesURL = Bundle.main.bundleURL.appendingPathComponent("Languages", isDirectory: true)
        
        //loop over all folders = languages in "Languages" folder
        do {
            let allDicts = try FileManager.default.contentsOfDirectory(atPath: allLanguagesURL.path)
            for dict in allDicts {
                //if there is already a folder name that is the same as the new languageName use this name
                if dict.lowercased() == languageName.lowercased() {
                    return dict
                }
            } //should never be reached since we will provide dummy languages
        } catch {
            print("ManualInputViewController: There are no languages yet")
        }
        //if the language does not exist yet it should be a new one
        return "not found"
    }
    
    //load data from file in documents folder into internal storage
    func loadData(deckName : String, languageName : String, question: String, answer: String) {
        //add correct and incorrect count to the given input
        let newContent = "\(question);\(answer);0;0;0\n"
        
        //path for the file in internal storage
        let deckPath = Bundle.main.bundleURL.appendingPathComponent("Languages", isDirectory: true).appendingPathComponent(languageName, isDirectory: true).appendingPathComponent(deckName).appendingPathExtension("txt")
        
        //if the file for this deck does already exist append the data
        if FileManager.default.fileExists(atPath: deckPath.path) {
            do {
                let fileHandle = try FileHandle.init(forWritingTo: deckPath)
                fileHandle.seekToEndOfFile()
                let contentData = newContent.data(using: .utf8)
                fileHandle.write(contentData!)
                fileHandle.closeFile()
                
                //inform user and reset text fields
                questionTextView.text = ""
                answerTextView.text = ""
                messageLabel.text = "Card successfully imported"
                messageLabel.textColor = UIColor.green
            } catch {
                print("ManualInputViewController: Cannot open fileHandle")
            }
        } //if the file does not exist create it and write into it
        else {
            let contentData = newContent.data(using: .utf8)
            FileManager.default.createFile(atPath: deckPath.path, contents: contentData, attributes: nil)
            
            //inform user and reset text fields
            questionTextView.text = ""
            answerTextView.text = ""
            messageLabel.text = "Card successfully imported"
            messageLabel.textColor = UIColor.green
        }
    }
    
    //save the input into internal file
    @IBAction func saveInput(_ sender: Any) {
        //button can only be pressed if all fields are filled
        if(languageNameField.text != "" && deckNameField.text != "" && questionTextView.text != "" && answerTextView.text != "") {
            let languageName = languageNameField.text
            let deckName = deckNameField.text
            let question = questionTextView.text
            let answer = answerTextView.text
            
            //path of internal languages folder
            let allLanguagesURL = Bundle.main.bundleURL.appendingPathComponent("Languages", isDirectory: true).appendingPathComponent(languageName!, isDirectory: true)
            
            //check if languages is existend currently
            let checkResult = checkForLanguageExistence(languageName: languageName!)
            
            //if language does exist load data
            if (checkResult != "not found") {
                loadData(deckName: deckName!, languageName: checkResult, question: question!, answer: answer!)
            } //if language odes not exist create a folder for the new language
            else {
                do {
                    try FileManager.default.createDirectory(atPath: allLanguagesURL.path, withIntermediateDirectories: true, attributes: nil)
                    loadData(deckName: deckName!, languageName: languageName!, question: question!, answer: answer!)
                } // should never be reached, there was problem with folder creationg
                catch  {
                    print("ManualInputViewController: Could not create directory")
                }
            }
        } //user is informed to fill all fields
        else {
            messageLabel.text = "Please enter information into all fields"
            messageLabel.textColor = UIColor.red
        }
    }
    
   
}
