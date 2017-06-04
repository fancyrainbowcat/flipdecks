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
        getListOfLanguages()
    }

    func getListOfLanguages() {
        let directoryURL = Bundle.main.bundleURL.appendingPathComponent("Languages", isDirectory: true)
        
        do {
            let allDicts = try FileManager.default.contentsOfDirectory(atPath: directoryURL.path)
            for dict in allDicts {
                let newLanguage = Language(name: dict)
                self.listOfLanguages.append(newLanguage)
            }
        } catch {
            print("There are no languages yet")
        }
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

}
