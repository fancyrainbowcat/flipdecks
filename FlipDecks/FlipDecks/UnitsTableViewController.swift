//
//  UnitsTableViewController.swift
//  FlipDecks
//
//  Created by Nicola Greth on 04.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

//TableViewController that contains all units for one language
class UnitsTableViewController: UITableViewController {

    var currentLanguage : Language?
    var listOfUnits = [Deck]()
    var languageName = ""
    
    //set title of ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = languageName
    }

    //get all Units for ViewController
    func getListOfUnits() {
        if (self.languageName != "") {
            currentLanguage = Language(name: languageName)
            self.listOfUnits = (currentLanguage?.returnAllDecks())!
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
    }

    //refresh data when view is appearing
    override func viewWillAppear(_ animated: Bool) {
        getListOfUnits()
        self.tableView.reloadData()
    }

    //number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfUnits.count
    }
    
    //functionality for cancel button segue
    @IBAction func cancelToUnitsTableViewController(segue:UIStoryboardSegue) {
        
    }
    
    //give language and unit to ModusViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unitToModus" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPath(for:cell)!
            let selectedUnit = listOfUnits[indexPath.row]
            
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.viewControllers.first as! ModusViewController
            controller.unitName = selectedUnit.getName()
            controller.languageName = self.languageName
        }
    }

}
