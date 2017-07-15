//
//  ViewController.swift
//  Browse
//
//  Created by Nicola Greth on 30.05.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

//View Controller for the opening of a file
class OpenFileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // current deck and language (will be filled via segue)
    var deck : Deck = Deck(name: "", languageName: "", fileEnding: "")
    var language : Language = Language(name: "")
    
    //list of languages for PickerView
    var listOfLanguages = [Language]()
    var listOfLanguagesPV = ["<new>"]
    
    //internal storage path
    var languagesFolderPath = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.appendingPathComponent("Languages", isDirectory: true)
    
    //all IBOutlets
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var fileNameField: UITextField!
    @IBOutlet weak var browseButton: UIButton!
    @IBOutlet weak var loadedLabel: UILabel!
    @IBOutlet weak var languageNameField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    //contains the currently selected file (will be filled via segue)
    var selectedFile : String = ""
    
    //change buttons and add event listener
    override func viewDidLoad() {
        super.viewDidLoad()
        okButton.isEnabled = false
        okButton.layer.borderWidth = 2
        okButton.layer.borderColor = UIColor.lightGray.cgColor
        browseButton.layer.borderWidth = 2
        browseButton.layer.borderColor = UIColor.blue.cgColor
        
        // DESIGN - Background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        
        //add event listener for textfields to enable load button
        fileNameField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        languageNameField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        pickerView.delegate = self

        //pre-set language if given through segue
        if (self.language.getName() != "") {
            self.languageNameField.text = self.language.getName()
            pickerView.isHidden = true
        } else {
            //set entries for UI Picker View
            listOfLanguagesPV = ["<new>"]
            
            for language in self.listOfLanguages {
                self.listOfLanguagesPV.append(language.getName())
            }
            pickerView.isHidden = false 
        }

        //to cancel keyboard when screen is tapped
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //closes keyboard when screen is tapped anywhere
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //count of components
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    //count of language suggestions
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return self.listOfLanguagesPV.count
    }
    
    //change font size of pickerView
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = listOfLanguagesPV[row]
        pickerLabel.font = UIFont(name: "System", size: 17)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    //select row of dropdown menu and hide pickerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.listOfLanguagesPV[row] != "<new>" {
            self.languageNameField.text = self.listOfLanguagesPV[row]
            editingChanged(self.languageNameField)
            self.pickerView.isHidden = true
        } else {
            self.languageNameField.text = ""
            editingChanged(self.languageNameField)
            self.pickerView.isHidden = true
        }
    }
    
    //start editing text field will remove dropdown menu
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //stop suggestions when editing is starting
        if textField == self.languageNameField {
            self.pickerView.isHidden = false
            textField.endEditing(true)
        }
    }
    
    //keyboard should be removed on press of return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //function for event listener on fileNameField and languageNameField
    @IBAction func editingChanged(_ fileNameField: UITextField) {
        //when the fields are not empty okButton should be enabled
        if(self.fileNameField.text != "" && languageNameField.text != "") {
            okButton.isEnabled = true
            okButton.layer.borderColor = UIColor.blue.cgColor
            loadedLabel.text = ""
        } //when the fields are empty okButton should be disabled
        else {
            okButton.isEnabled = false
            loadedLabel.text = ""
            okButton.layer.borderColor = UIColor.lightGray.cgColor
        }
        return
    }
    
    //cancel button action > go back to openFileViewController
    @IBAction func cancelToOpenFileViewController(segue:UIStoryboardSegue) {
        self.fileNameField.text = ""
        okButton.isEnabled = false
        okButton.layer.borderColor = UIColor.lightGray.cgColor
        loadedLabel.text = ""
    }
    
    //sets selectedFile and enables button
    @IBAction func useFile(segue:UIStoryboardSegue) {
        if (selectedFile != "") {
            self.fileNameField.text = selectedFile
            
            if(self.languageNameField.text != "") {
                okButton.isEnabled = true
                okButton.layer.borderColor = UIColor.blue.cgColor
            }
        }
    }
    
    //checks if language is already existent
    func checkForLanguageExistence(languageName : String) -> String {
        //loop over all folders = languages in "Languages" folder
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
    func loadData(filename : String, languageName : String, fileURL : URL) {
        //content of file to be loaded
        var contentOfFile = ""
        
        //content that will be written into internal storage
        var newContent = ""
            
        let currentLanguageFolderPath = languagesFolderPath?.appendingPathComponent(languageName, isDirectory: true)
        
        let deckFolderPath = currentLanguageFolderPath?.appendingPathComponent(filename)
        
        do {
            //split content of original file into lines
            contentOfFile = try String(contentsOf: fileURL)
            let lines = contentOfFile.components(separatedBy: NSCharacterSet.newlines)
            
            //loop over lines and split into elements by file separator ";"
            for line in lines {
                if line != "" {
                    var newLine = line
                    newLine = newLine.appending(";0;0;0\n")
                    newContent.append(newLine)
                }
            }
            //convert content string into data
            let contentData = newContent.data(using: .utf8)
            
            //create internal file and write into it
            FileManager.default.createFile(atPath: (deckFolderPath?.path)!, contents: contentData, attributes: nil)
            
            //send message
            loadedLabel.text = "File successfully loaded"
            loadedLabel.textColor = UIColor.green
            self.viewDidLoad()
        } catch {
            //send message if file could not be loaded e.g. incorrect format
            loadedLabel.text = "File could not be loaded"
            loadedLabel.textColor = UIColor.red
            self.pickerView.isHidden = false
            self.viewDidLoad()
        }
    }
    
    //read from file
    @IBAction func readFromFile() {
        //if there is no language given user is informed to enter language name
        if(languageNameField.text == "") {
            loadedLabel.text = "Please enter language name"
            loadedLabel.textColor = UIColor.red
        } //if language is valid
        else {
            do {
                //path to source Folder documents
                let documentsPath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)

                //name of given file
                var filename = fileNameField.text
            
                //URL of file, initalized with documentsPath
                var fileURL:URL = documentsPath
            
                //name of the given language
                let languageName = languageNameField.text
            
                //check if the file it in a valid format e.g. .txt or .csv
                var valid = false
        
                //if the given filename is a valid .txt file create fileURL
                if (filename!.contains(".txt")) {
                    fileURL = fileURL.appendingPathComponent(filename!)
                    valid = true
                } //test for invalid file format e.g. everything with a fileEnding indicated by "." but not txt
                else if (filename!.contains(".")) {
                    print("OpenFileViewController: File Ending is not valid, please use .txt files")
                } //missing file ending - we have to add the correct .txt ending
                else {
                    do {
                        //loop over all files and check if the given fileName is valid
                        let allFiles = try FileManager.default.contentsOfDirectory(atPath: documentsPath.path)
                        for file in allFiles {
                            if (file.contains(filename!)) {
                                filename = file
                                fileURL = fileURL.appendingPathComponent(file)
                                valid = true
                            }
                        }
                    } catch {
                        print("No files in documents folder")
                    }
                }
            
                //if the file is valid (in the checks above)
                if (valid == true) {
                    //check if the language exists currently
                    let checkResult = checkForLanguageExistence(languageName: languageName!)
                
                    //if the language does exist, use the correct language name (upper/lowercase) and write into the language folder
                    if (checkResult != "not found") {
                        loadData(filename: filename!, languageName: checkResult, fileURL: fileURL)
                    } else { //if the language does not exist, load the data and create the language folder
                        do {
                            let currentLanguageFolderPath = languagesFolderPath?.appendingPathComponent(languageName!, isDirectory: true)
                            
                            try FileManager.default.createDirectory(atPath: (currentLanguageFolderPath?.path)!, withIntermediateDirectories: true, attributes: nil)
                            
                            loadData(filename: filename!, languageName: languageName!, fileURL: fileURL)
                        } catch  { //should not happen, there was an error with creating the directory
                            print("OpenFileViewController: Could not create directory")
                        }
                    }
                } else { //if ths file is not valid the user is informed
                    loadedLabel.text = "File is not valid"
                    loadedLabel.textColor = UIColor.red
                }
        
                //after the load action all input should be resetted
                fileNameField.text = ""
                languageNameField.text = ""
                okButton.isEnabled = false
                okButton.layer.borderColor = UIColor.lightGray.cgColor
            } catch {
                print("OpenFileViewController: Documents Folder does not exist")
            }
        }
    }
}

