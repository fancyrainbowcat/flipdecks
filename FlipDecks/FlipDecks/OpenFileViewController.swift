//
//  ViewController.swift
//  Browse
//
//  Created by Nicola Greth on 30.05.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

//View Controller for the opening of a file
class OpenFileViewController: UIViewController {
    
    //all IBOutlets
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var fileNameField: UITextField!
    @IBOutlet weak var browseButton: UIButton!
    @IBOutlet weak var loadedLabel: UILabel!
    @IBOutlet weak var languageNameField: UITextField!
    
    //contains the currently selected file
    var selectedFile : String = ""
    
    //change buttons and add event listener
    override func viewDidLoad() {
        super.viewDidLoad()
        okButton.isEnabled = false
        okButton.layer.borderWidth = 2
        okButton.layer.borderColor = UIColor.lightGray.cgColor
        browseButton.layer.borderWidth = 2
        browseButton.layer.borderColor = UIColor.blue.cgColor
        fileNameField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //function for event listener on fileNameField
    @IBAction func editingChanged(_ fileNameField: UITextField) {
        //when the field is not empty okButton should be enabled
        if(fileNameField.text != "") {
            okButton.isEnabled = true
            okButton.layer.borderColor = UIColor.blue.cgColor
            loadedLabel.text = ""
        } //when the field is empty okButton should be disabled
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
        self.fileNameField.text = selectedFile
        okButton.isEnabled = true
        okButton.layer.borderColor = UIColor.blue.cgColor
    }
    
    //checks if language is already existent
    func checkForLanguageExistence(languageName : String) -> String {
        //URL of internal "Languages" folder
        let allLanguagesURL = Bundle.main.bundleURL.appendingPathComponent("Languages", isDirectory: true)
        
        do {
            //loop over all folders = languages in "Languages" folder
            let allDicts = try FileManager.default.contentsOfDirectory(atPath: allLanguagesURL.path)
            for dict in allDicts {
                //if there is already a folder name that is the same as the new languageName use this name
                if dict.lowercased() == languageName.lowercased() {
                    return dict
                }
            }
        } //should never be reached since we will provide dummy languages
        catch {
            print("OpenFileViewController: There are no languages yet")
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
        var fileWithoutEnding = ""
        
        //this will remove the file ending but only if there is a fileEnding
        if (filename.contains(".")) {
            let index = filename.index(filename.endIndex, offsetBy: -4)
            fileWithoutEnding = filename.substring(to: index)
        } else {
            fileWithoutEnding = filename
        }
            
        //path to internal file "Languages/languageName/fileName.txt" > internal files will always be .txt files
        let deckPath = Bundle.main.bundleURL.appendingPathComponent("Languages", isDirectory: true).appendingPathComponent(languageName, isDirectory: true).appendingPathComponent(fileWithoutEnding).appendingPathExtension("txt")
        
        /*for logging purposes, this is where your deck is stored internally
         if you want to access this folder copy the URL and open a command window
         remove filename from URL
         type: cd URL e.g. cd /Users/nicolagreth/Library/Developer/CoreSimulator/Devices/DD4410EE-83B0-45B9-9584-9CC740FDE3B7/data/Containers/Bundle/Application/A5BFFC58-6E29-4A11-954E-68D7F7C05B6F/FlipDecks.app/Languages/test/
         then type: open .
         this will open the finder so you can open the files with any program of your choice */
        print("OpenFileViewController: Log deckPath at \(deckPath)")
        
        do {
            //split content of original file into lines
            contentOfFile = try String(contentsOf: fileURL)
            let lines = contentOfFile.components(separatedBy: NSCharacterSet.newlines)
            
            //loop over lines and split into elements by file separator ";"
            for line in lines {
                if line != "" {
                    var newLine = line
                    newLine = newLine.appending(";0;0\n")
                    newContent.append(newLine)
                }
            }
            //convert content string into data
            let contentData = newContent.data(using: .utf8)
            
            //create internal file and write into it
            FileManager.default.createFile(atPath: deckPath.path, contents: contentData, attributes: nil)
            
            //send message
            loadedLabel.text = "File successfully loaded"
            loadedLabel.textColor = UIColor.green
        } catch {
            //send message if file could not be loaded e.g. incorrect format
            loadedLabel.text = "File could not be loaded"
            loadedLabel.textColor = UIColor.red
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
            //URL of folder "Documents/Flipdecks"
            let directoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("FlipDecks", isDirectory: true)
            
            //check if FlipDecks directory exists at this point
            if (!FileManager.default.fileExists(atPath: directoryURL.path)) {
                do {
                    try FileManager.default.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: true, attributes: nil)
                } catch let error as NSError {
                    print(error.localizedDescription);
                }
            }
            
            //name of file
            let filename = fileNameField.text
            
            //URL of file, here it is only initialized with the directory URL, it will be changed later
            var fileURL:URL = directoryURL
            
            //name of the target language
            let languageName = languageNameField.text
            
            //check if the file it in a valid format e.g. .txt or .csv
            var valid = false
        
            //if the given filename is a valid .txt/.csv file create fileURL
            if (filename!.contains(".txt") || filename!.contains(".csv")) {
                fileURL = directoryURL.appendingPathComponent(filename!)
                valid = true
            } //test for invalid file format e.g. everything with a fileEnding indicated by "." but not txt or csv
            else if (filename!.contains(".")) {
                print("OpenFileViewController: File Ending is not valid, please use .txt files")
            } //missing file ending - we have to add the correct ending e.g. .txt or .csv
            else {
                do {
                    //loop over all files in directory and find the one with our filename, then add the correct fileEnding
                    let allFiles = try FileManager.default.contentsOfDirectory(atPath: directoryURL.path)
                    for file in allFiles {
                        if file.contains(filename!) {
                            if (file.contains(".txt") || file.contains(".csv")) {
                                fileURL = directoryURL.appendingPathComponent(file)
                                valid = true
                            }
                        }
                    }
                } //if this is printed then the file is not existent and has to be created yet
                catch {
                    print("OpenFileViewController: File does not exist")
                
                }
            }
            
            //internal target directory "Languages"
            let allLanguagesURL = Bundle.main.bundleURL.appendingPathComponent("Languages", isDirectory: true).appendingPathComponent(languageName!, isDirectory: true)
        
            //if the file is valid (in the checks above)
            if (valid == true) {
                //check if the language exists currently
                let checkResult = checkForLanguageExistence(languageName: languageName!)
                
                //if the language does exist, use the correct language name (upper/lowercase) and write into the language folder
                if (checkResult != "not found") {
                    loadData(filename: filename!, languageName: checkResult, fileURL: fileURL)
                } else { //if the language does not exist, load the data and create the language folder
                    do {
                        try FileManager.default.createDirectory(atPath: allLanguagesURL.path, withIntermediateDirectories: true, attributes: nil)
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
        }
    }
    

}

