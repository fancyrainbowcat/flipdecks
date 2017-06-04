//
//  UnitsTableViewController.swift
//  FlipDecks
//
//  Created by Nicola Greth on 04.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

class UnitsTableViewController: UITableViewController {

    var listOfUnits = [Deck]()
    var languageName = "TestLanguage"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getListOfUnits()
    }

    func getListOfUnits() {
        let directoryURL = Bundle.main.bundleURL.appendingPathComponent("Languages", isDirectory: true).appendingPathComponent(languageName, isDirectory:true)
        
        do {
            let allDicts = try FileManager.default.contentsOfDirectory(atPath: directoryURL.path)
            for dict in allDicts {
                let newUnit = Deck(name: dict)
                self.listOfUnits.append(newUnit)
            }
        } catch {
            print("There are no units yet")
        }
    }
    
    //show available files in tableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "unitCell", for: indexPath)
        cell.textLabel?.text = listOfUnits[indexPath.row].getName()
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
        return listOfUnits.count
    }
    
    @IBAction func cancelToUnitsTableViewController(segue:UIStoryboardSegue) {
        
    }



}
