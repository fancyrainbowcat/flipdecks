//
//  UnitsTableViewController.swift
//  FlipDecks
//
//  Created by Nicola Greth on 04.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

class UnitsTableViewController: UITableViewController {

    var currentLanguage : Language?
    var listOfUnits = [Deck]()
    var languageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = languageName
    }

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
        // Dispose of any resources that can be recreated.
    }

    //refresh data when view is appearing
    override func viewWillAppear(_ animated: Bool) {
        getListOfUnits()
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfUnits.count
    }
    
    @IBAction func cancelToUnitsTableViewController(segue:UIStoryboardSegue) {
        
    }
    
    //give language to UnitsTableViewController
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
