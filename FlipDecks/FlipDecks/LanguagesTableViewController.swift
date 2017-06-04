//
//  LanguagesTableViewController.swift
//  FlipDecks
//
//  Created by Nicola Greth on 04.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

class LanguagesTableViewController: UITableViewController {

    var listOfLanguages = [Language]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func getListOfLanguages() {
        let directoryURL = Bundle.main.bundleURL.appendingPathComponent("Languages", isDirectory: true)
        
        do {
            let allDicts = try FileManager.default.contentsOfDirectory(atPath: directoryURL.path)
            for dict in allDicts {
                let newLanguage = Language(name: dict)
                let checkLanguageExists = listOfLanguages.contains(where: { $0.getName() == newLanguage.getName() })
                if (checkLanguageExists == false) {
                    self.listOfLanguages.append(newLanguage)
                }
            }
        } catch {
            print("There are no languages yet")
        }
    }
    
    //refresh data when view is appearing
    override func viewWillAppear(_ animated: Bool) {
        getListOfLanguages()
        self.tableView.reloadData()
    }
    
    //show available files in tableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath)
        cell.textLabel?.text = listOfLanguages[indexPath.row].getName()
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfLanguages.count
    }


    @IBAction func cancelToLanguageTableViewController(segue:UIStoryboardSegue) {
    
    }
    
    //give language to UnitsTableViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "languageToUnit" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPath(for:cell)!
            let selectedLanguage = listOfLanguages[indexPath.row]
            
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.viewControllers.first as! UnitsTableViewController
            controller.languageName = selectedLanguage.getName()
        }
    }
}
