//
//  ListAndSearchTableViewController.swift
//  FlipDecks
//
//  Created by Nicola Greth on 14.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

extension ListAndSearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

class ListAndSearchTableViewController: UITableViewController {

    // current deck and language
    var deck : Deck = Deck(name: "", languageName: "", fileEnding: "")
    var language : Language = Language(name: "")
    var listOfCards = [Card]()
    var filteredCards = [Card]()
    let searchController = UISearchController(searchResultsController: nil)

        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listOfCards = self.deck.returnAllCards()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
    }

    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredCards = listOfCards.filter { $0.getQuestion().lowercased().contains(searchText.lowercased()) || $0.getAnswer().lowercased().contains(searchText.lowercased())}
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return self.filteredCards.count
        }
        return self.listOfCards.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ListAndSearchTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListAndSearchTableViewCell
        
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.QuestionLabel?.text = self.filteredCards[indexPath.row].getQuestion()
            cell.AnswerLabel?.text = self.filteredCards[indexPath.row].getAnswer()
        } else {
            cell.QuestionLabel?.text = self.listOfCards[indexPath.row].getQuestion()
            cell.AnswerLabel?.text = self.listOfCards[indexPath.row].getAnswer()
        }
        return cell
    }
}
