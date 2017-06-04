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
        let allLanguagesURL = Bundle.main.bundleURL.appendingPathComponent("Languages", isDirectory: true)
        
        do {
            let allDicts = try FileManager.default.contentsOfDirectory(atPath: allLanguagesURL.path)
            for dict in allDicts {
                if dict.lowercased() == languageName.lowercased() {
                    return dict
                }
            }
        } catch {
            print("There are no languages yet")
        }
        
        return "not found"
    }
    
    //load data from file in documents folder into internal storage
    func loadData(deckName : String, languageName : String, question: String, answer: String) {
        let newContent = "\(question);\(answer);0;0\n"
        let deckPath = Bundle.main.bundleURL.appendingPathComponent("Languages", isDirectory: true).appendingPathComponent(languageName, isDirectory: true).appendingPathComponent(deckName).appendingPathExtension("txt")
        
        if FileManager.default.fileExists(atPath: deckPath.path) {
            do {
                let fileHandle = try FileHandle.init(forWritingTo: deckPath)
                fileHandle.seekToEndOfFile()
                let contentData = newContent.data(using: .utf8)
                fileHandle.write(contentData!)
                fileHandle.closeFile()
                questionTextView.text = ""
                answerTextView.text = ""
                messageLabel.text = "Card successfully imported"
                messageLabel.textColor = UIColor.green
            } catch {
                print("Cannot open fileHandle")
            }
        } else {
            let contentData = newContent.data(using: .utf8)
            FileManager.default.createFile(atPath: deckPath.path, contents: contentData, attributes: nil)
            questionTextView.text = ""
            answerTextView.text = ""
            messageLabel.text = "Card successfully imported"
            messageLabel.textColor = UIColor.green
        }
    }
    
    //save the input into internal file
    @IBAction func saveInput(_ sender: Any) {
        if(languageNameField.text != "" && deckNameField.text != "" && questionTextView.text != "" && answerTextView.text != "") {
            let languageName = languageNameField.text
            let deckName = deckNameField.text
            let question = questionTextView.text
            let answer = answerTextView.text
            let allLanguagesURL = Bundle.main.bundleURL.appendingPathComponent("Languages", isDirectory: true).appendingPathComponent(languageName!, isDirectory: true)
            let checkResult = checkForLanguageExistence(languageName: languageName!)
            
            if (checkResult != "not found") {
                loadData(deckName: deckName!, languageName: checkResult, question: question!, answer: answer!)
            } else {
                do {
                    try FileManager.default.createDirectory(atPath: allLanguagesURL.path, withIntermediateDirectories: true, attributes: nil)
                    loadData(deckName: deckName!, languageName: languageName!, question: question!, answer: answer!)
                } catch  {
                    print("Could not create directory")
                }
            }
        } else {
            messageLabel.text = "Please enter information into all fields"
            messageLabel.textColor = UIColor.red
        }
    }
    
   
}
