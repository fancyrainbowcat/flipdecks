//
//  ManualInputViewController.swift
//  FlipDecks
//
//  Created by Nicola Greth on 03.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

//View Controller for manual input
class ManualInputViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UITextFieldDelegate {

    // current deck and language (filled via segue)
    var deck : Deck = Deck(name: "", languageName: "", fileEnding: "")
    var language : Language = Language(name: "")
    
    //input for pickerViews
    var listOfLanguages = [Language]()
    var listOfDecks = [Deck]()
    var listOfLanguagesPV = ["<new>"]
    var listOfDecksPV = ["<new>"]
    
    //path for languages folder in internal storage
    var languagesFolderPath = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.appendingPathComponent("Languages", isDirectory: true)

    //IBOutlets
    @IBOutlet weak var languageNameField: UITextField!
    @IBOutlet weak var deckNameField: UITextField!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var languagePickerView: UIPickerView!
    @IBOutlet weak var deckPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.languageNameField.delegate = self
        self.deckNameField.delegate = self
        
        languagePickerView.delegate = self
        deckPickerView.delegate = self
        questionTextView.delegate = self
        answerTextView.delegate = self
        okButton.isUserInteractionEnabled = false
        okButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
        
        //set list of languages for picker view
        listOfLanguagesPV = ["<new>"]
        
        for language in self.listOfLanguages {
            listOfLanguagesPV.append(language.getName())
        }
        
        //set list of decks for picker view
        listOfDecksPV = ["<new>"]
        
        for deck in self.listOfDecks {
            listOfDecksPV.append(deck.getName())
        }
        
        //pre-set deck and language if given 
        if (self.deck.getName() != "") {
            self.deckNameField.text = self.deck.getName()
            deckPickerView.isHidden = true
        }
        
        if (self.language.getName() != "" ) {
            self.languageNameField.text = self.language.getName()
            languagePickerView.isHidden = true
            //don't show deckPickerView if there is already a name entered
            if (self.deckNameField.text != "") {
                deckPickerView.isHidden = true
            } //show deckPickerView if there is no name entered yet
            else {
                deckPickerView.isHidden = false
            }
        } else {
            deckPickerView.isHidden = true
        }
        
        
        //to cancel keyboard when screen is tapped
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //closes keyboard when screen is tapped anywhere
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    //count of language/deck suggestions
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if (pickerView.tag == 0) {
            return self.listOfLanguagesPV.count
        } else  {
            return self.listOfDecksPV.count
        }
    }
    
    //keyboard should be removed on press of return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //keyboard should be removed on press of return button 
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //change font size and content of both pickerViews
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.font = UIFont(name: "System", size: 17)
        pickerLabel.textAlignment = NSTextAlignment.center
        
        if (pickerView.tag == 0) {
            pickerLabel.text = self.listOfLanguagesPV[row]
        } else if (pickerView.tag == 1) {
            pickerLabel.text = self.listOfDecksPV[row]
        }
        return pickerLabel
    }
    
    //select row of dropdown menu
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //language is set, and listOfDecks can be replaced and deckPickerView will be enabled
        if (pickerView.tag == 0) {
            if (self.listOfLanguagesPV[row] != "<new>") { //if the user chose a valid language
                self.languageNameField.text = self.listOfLanguagesPV[row]
                self.language = self.listOfLanguages[row-1] //because of the <new> it is the row after this
                pickerView.isHidden = true
                self.listOfDecks = self.listOfLanguages[row-1].returnAllDecks()
                self.viewDidLoad()
                changeOKButtonState()
            } else { //user wants to enter new value
                self.languageNameField.text = ""
                pickerView.isHidden = true
                changeOKButtonState()
            }
        } //deck is set as well
        else if (pickerView.tag == 1) {
            if (self.language.getName() != "") { //if the user chose a valid language
                if (self.listOfDecksPV[row] != "<new>") {
                    self.deckNameField.text = self.listOfDecksPV[row]
                    self.deck = self.listOfDecks[row-1] //because of the <new> it is the row after this
                    pickerView.isHidden = true
                    changeOKButtonState()
                } else { //user wants to enter new value
                    self.deckNameField.text = ""
                    pickerView.isHidden = true
                    changeOKButtonState()
                }
            }
        }
    }
    
    
    @IBAction func languageNameFieldEditingChanged(_ sender: Any) {
        self.languagePickerView.isHidden = true
        self.deckPickerView.isHidden = true
        
        self.messageLabel.text = ""
        
        //reset language
        self.language = Language(name: "")
        changeOKButtonState()
    }
    
    @IBAction func deckNameFieldEditingChanged(_ sender: Any) {
        self.deckPickerView.isHidden = true
        
        self.messageLabel.text = ""
        
        //reset deck
        self.deck = Deck(name: "", languageName: "", fileEnding: "")
        changeOKButtonState()
    }
    
    //active buton if all fields are filled
    func changeOKButtonState() {
        //activate ok button if all fields are filled
        if (self.languageNameField.text != "" && self.deckNameField.text != "" && self.questionTextView.text != "" && self.answerTextView.text != "") {
            okButton.isUserInteractionEnabled = true
            okButton.setTitleColor(UIColor.cyan, for: UIControlState.normal)
        } else {
            okButton.isUserInteractionEnabled = false
            okButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
        }
    }
    
    //if user is beginning to enter a new card, the message text will be deleted
    func textViewDidChange(_ textView: UITextView) {
        self.messageLabel.text = ""
        changeOKButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //checks if language is already existent
    func checkForLanguageExistence(languageName : String) -> String {
        //loop over all folders = languages
        do {
            let allDicts = try FileManager.default.contentsOfDirectory(atPath: (languagesFolderPath?.path)!)
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
        let newCard = Card(question: question, answer: answer, correctCount: 0, incorrectCount: 0, secondsSpentOnCard: 0)
    
        //set language name if necessary
        if (self.language.getName() == "") {
            for language in self.listOfLanguages {
                if languageName == language.getName() {
                    self.language = language
                }
            }
        }

        let currentLanguageFolderPath = languagesFolderPath?.appendingPathComponent(languageName, isDirectory: true)
        
        let deckFolderPath = currentLanguageFolderPath?.appendingPathComponent("\(deckName).txt")

        //if the file for this deck does already exist append the data
        if FileManager.default.fileExists(atPath: (deckFolderPath?.path)!) {
            
            //set deck if necessary
            if (self.deck.getName() == "") {
                for deck in self.listOfDecks {
                    if deckName == deck.getName() {
                        self.deck = deck
                    }
                }
            }
            
            //append card to the current deck
            if (self.deck.appendCard(card : newCard)) {
                //inform user and reset text fields
                questionTextView.text = ""
                answerTextView.text = ""
                messageLabel.text = "Card successfully imported"
                messageLabel.textColor = UIColor.green
                changeOKButtonState()
            } else {
                //inform user and reset text fields
                questionTextView.text = ""
                answerTextView.text = ""
                messageLabel.text = "Card does already exist"
                messageLabel.textColor = UIColor.red
                changeOKButtonState()
            }

        } //if the file does not exist create it and write into it
        else {
            //write current data into content string
            let content = "\(question);\(answer);0;0;0\n"

            //convert content string to data
            let contentData = content.data(using: .utf8)
            
            //recreate deck with current values
            if (FileManager.default.createFile(atPath: (deckFolderPath?.path)!, contents: contentData, attributes: nil)) {

                //inform user and reset file 
                questionTextView.text = ""
                answerTextView.text = ""
                messageLabel.text = "Card successfully imported"
                messageLabel.textColor = UIColor.green
                changeOKButtonState()
            }
            else {
                messageLabel.text = "Error"
                messageLabel.textColor = UIColor.red
                changeOKButtonState()
            }
        }
    }
    
    //save the input into internal file
    @IBAction func saveInput(_ sender: Any) {
        //button can only be pressed if all fields are filled
        if(languageNameField.text != "" &&  deckNameField.text != "" && questionTextView.text != "" && answerTextView.text != "") {
            let languageName = self.languageNameField.text
            let deckName = self.deckNameField.text
            let question = self.questionTextView.text
            let answer = self.answerTextView.text
            
            //check if languages is existend currently
            let checkResult = checkForLanguageExistence(languageName: languageName!)
            
            //if language does exist load data
            if (checkResult != "not found" && checkResult != "") {
                loadData(deckName: deckName!, languageName: checkResult, question: question!, answer: answer!)
            } //if language does not exist create a folder for the new language
            else {
                do {
                    let currentLanguageFolderPath = languagesFolderPath?.appendingPathComponent(languageName!, isDirectory: true)
                    
                    try FileManager.default.createDirectory(atPath: (currentLanguageFolderPath?.path)!, withIntermediateDirectories: true, attributes: nil)
                    loadData(deckName: deckName!, languageName: languageName!, question: question!, answer: answer!)
                } // should never be reached, there was problem with folder creationg
                catch  {
                    print("ManualInputViewController: Could not create directory")
                }
            }
        } //user is informed to fill all fields, should never be reached since ok button is disabled
        else {
            messageLabel.text = "Please enter information into all fields"
            messageLabel.textColor = UIColor.red
        }
    }
}
