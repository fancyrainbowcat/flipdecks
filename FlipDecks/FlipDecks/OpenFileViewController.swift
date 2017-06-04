//
//  ViewController.swift
//  Browse
//
//  Created by Nicola Greth on 30.05.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

class OpenFileViewController: UIViewController {
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var fileNameField: UITextField!
    @IBOutlet weak var browseButton: UIButton!
    @IBOutlet weak var loadedLabel: UILabel!
    var selectedFile : String = ""
    
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
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editingChanged(_ fileNameField: UITextField) {
        if(fileNameField.text != "") {
            okButton.isEnabled = true
            okButton.layer.borderColor = UIColor.blue.cgColor
            loadedLabel.text = ""
        } else {
            okButton.isEnabled = false
            loadedLabel.text = ""
            okButton.layer.borderColor = UIColor.lightGray.cgColor
        }
        return
    }
    
    //cancel button action
    @IBAction func cancelToOpenFileViewController(segue:UIStoryboardSegue) {
        self.fileNameField.text = ""
        okButton.isEnabled = false
        okButton.layer.borderColor = UIColor.lightGray.cgColor
        loadedLabel.text = ""
    }
    
    
    //use selected file done button action
    @IBAction func useFile(segue:UIStoryboardSegue) {
        self.fileNameField.text = selectedFile
        okButton.isEnabled = true
        okButton.layer.borderColor = UIColor.blue.cgColor
    }
    
    @IBAction func readFromFile() {
        let directoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("FlipDecks", isDirectory: true)
        let filename = fileNameField.text
        var fileURL:URL = directoryURL
        var valid = false
        
        //if it is a valid txt file
        if (filename!.contains(".txt") || filename!.contains(".csv")) {
            fileURL = directoryURL.appendingPathComponent(filename!)
            valid = true
        }
        //test for invalid file format
        else if (filename!.contains(".")) {
            print("File Ending is not valid, please use .txt files")
        }
        //missing file ending
        else {
            do {
                let allFiles = try FileManager.default.contentsOfDirectory(atPath: directoryURL.path)
                for file in allFiles {
                    if file.contains(filename!) {
                        if (file.contains(".txt") || file.contains(".csv")) {
                            fileURL = directoryURL.appendingPathComponent(file)
                            valid = true
                        }
                    }
                }
            }
            catch {
                print("File does not exist")
                
            }
        }
        print("Log directoryURL: \(directoryURL)")
        
        if (valid == true) {
            var contentOfFile = ""
            do {
                contentOfFile = try String(contentsOf: fileURL)
                print("Contents of file: \(contentOfFile)")
                loadedLabel.text = "File successfully loaded"
                loadedLabel.textColor = UIColor.green
            } catch let error as NSError {
                print("Failed to read file")
                print(error)
                loadedLabel.text = "File could not be loaded"
                loadedLabel.textColor = UIColor.red
            }
        } else {
            loadedLabel.text = "File is not valid"
            loadedLabel.textColor = UIColor.red
        }
        
        fileNameField.text = ""
        okButton.isEnabled = false
        okButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
}

