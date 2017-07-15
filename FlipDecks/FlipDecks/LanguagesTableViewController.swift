//
//  LanguagesTableViewController.swift
//  FlipDecks
//
//  Created by Nicola Greth on 04.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

//View Controller for all available languages
class LanguagesTableViewController: UITableViewController {

    //contains all languages
    var listOfLanguages = [Language]()
    var languagesFolderPath = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.appendingPathComponent("Languages", isDirectory: true)
    
    override func viewDidLoad() {
        getListOfLanguages()
        super.viewDidLoad()
    }

    //gets list of all languages = all folders in internal folder "Languages"
    func getListOfLanguages() {
        do {
            //get the content of folder "Languages"
            let allDicts = try FileManager.default.contentsOfDirectory(atPath: (languagesFolderPath?.path)!)
            
            //check for all folders if any of those is a new language, that is not contained in listOfLanguages yet
            for dict in allDicts {
                //for safety reasons, take only folders (no file ending)
                if (dict != "" && !(dict.contains("."))) {
                    let newLanguage = Language(name: dict)
                    let checkLanguageExists = listOfLanguages.contains(where: { $0.getName() == newLanguage.getName() })
                
                    //if it is a new language append it to listOfLanguages
                    if (checkLanguageExists == false) {
                        self.listOfLanguages.append(newLanguage)
                    }
                }
            }
            
        } //if there are no languages yet, this is the first start of our app and we have to copy our prepared languages. This should only be reached once.
        catch {
            let pathToPreparedLections = Bundle.main.bundleURL.appendingPathComponent("Languages", isDirectory: true)
            
            do {
                //get contents of the project folder
                let allLanguageFiles = try FileManager.default.contentsOfDirectory(atPath: (pathToPreparedLections.path))
                
                for languageFile in allLanguageFiles {
                    //create language subfolder
                    let currentLanguageFolderPath = languagesFolderPath?.appendingPathComponent(languageFile, isDirectory: true)
                    try FileManager.default.createDirectory(atPath: (currentLanguageFolderPath?.path)!, withIntermediateDirectories: true, attributes: nil)
                    
                    //get all available decks
                    let previousLanguageFolderPath = pathToPreparedLections.appendingPathComponent(languageFile, isDirectory: true)
                    do {
                        let allDictFiles = try FileManager.default.contentsOfDirectory(atPath: (previousLanguageFolderPath.path))
                    
                        for dictFile in allDictFiles {
                            //copy deck file
                            let deckFolderPath = currentLanguageFolderPath?.appendingPathComponent(dictFile)
                            let previousDeckFolderPath = previousLanguageFolderPath.appendingPathComponent(dictFile)
                        
                            do {
                                try FileManager.default.copyItem(at: previousDeckFolderPath, to:    deckFolderPath!)
                            }
                            catch let error as NSError {
                                print("LanguagesTableViewController, first import: \(error)")
                            }
                        }
                    } catch {
                        print("Error: no dicts")
                    }
                }

            } catch {
                print("Could not read contents of languagesFolderPath")
            }
        }
        self.tableView.reloadData()
    }
    
    //refresh data when view is appearing
    override func viewWillAppear(_ animated: Bool) {
        getListOfLanguages()
        self.tableView.reloadData()
    }
    
    //show available languages in tableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> LanguagesTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath) as! LanguagesTableViewCell
        let progress = Float(listOfLanguages[indexPath.row].getCountOfFinishedDecks()) / Float(listOfLanguages[indexPath.row].getCountOfDecks())
        cell.Label?.text = listOfLanguages[indexPath.row].getName()
        cell.ProgressBar?.progress = progress
        cell.ProgressBar?.progressTintColor = cell.returnColor()
        if progress == 0 {
            cell.ProgressBar.isHidden = true
        } else {
            cell.ProgressBar.isHidden = false
        }
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //count of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfLanguages.count
    }

    //functionality for cancel button segue
    @IBAction func cancelToLanguageTableViewController(segue:UIStoryboardSegue) {
    
    }
    
    //give language to UnitsTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "languageToUnit" {
            
            //get the selected language 
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPath(for:cell)!
            let selectedLanguage = listOfLanguages[indexPath.row]
            
            //since there is a navigation controller in between, I have to go through it
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.viewControllers.first as! UnitsTableViewController
            controller.language = selectedLanguage
        }
        
        if segue.identifier == "languageToImport" {
            //since there is a navigation controller in between, I have to go through it
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.viewControllers.first as! ImportMainViewController
            controller.listOfLanguages = self.listOfLanguages
        }
    }
}
