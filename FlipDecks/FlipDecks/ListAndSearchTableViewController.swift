//
//  ListAndSearchTableViewController.swift
//  FlipDecks
//
//  Created by Nicola Greth on 14.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

class ListAndSearchTableViewController: UITableViewController {

    // current deck and language
    var deck : Deck = Deck(name: "", languageName: "", fileEnding: "")
    var language : Language = Language(name: "")
    var listOfCards = [Card]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listOfCards = self.deck.returnAllCards()
    }
    
    func editingChanged(_ SearchBar: UISearchBar) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deck.getCountOfCards()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ListAndSearchTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListEntryCell", for: indexPath) as! ListAndSearchTableViewCell
        cell.QuestionLabel?.text = self.listOfCards[indexPath.row].getQuestion()
        cell.AnswerLabel?.text = self.listOfCards[indexPath.row].getQuestion()
        return cell
    }
}
