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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //gets list of all languages = all folders in internal folder "Languages"
    func getListOfLanguages() {
        
        //URL for internal folder "Languages"
        let directoryURL = Bundle.main.bundleURL.appendingPathComponent("Languages", isDirectory: true)
        
        do {
            //get the content of folder "Languages"
            let allDicts = try FileManager.default.contentsOfDirectory(atPath: directoryURL.path)
            
            //check for all folders if any of those is a new language, that is not contained in listOfLanguages yet
            for dict in allDicts {
                let newLanguage = Language(name: dict)
                let checkLanguageExists = listOfLanguages.contains(where: { $0.getName() == newLanguage.getName() })
                
                //if it is a new language append it to listOfLanguages
                if (checkLanguageExists == false) {
                    self.listOfLanguages.append(newLanguage)
                }
            }
        } //this should never be reached: case that there are no languages yet (we will provide default languages)
        catch {
            print("LanguagesTableViewController: There are no languages yet")
        }
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
    }
}
