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
    var timeMode = false 

        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listOfCards = self.deck.returnAllCards().sorted(by: {$0.getQuestion() < $1.getQuestion()})
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
            cell.correctLabel?.text = "Correct: \(self.filteredCards[indexPath.row].getCorrectCount())"
            cell.incorrectLabel?.text = "Incorrect: \(self.filteredCards[indexPath.row].getIncorrectCount())"
            if(timeMode == true) {
                let seconds = self.filteredCards[indexPath.row].getTimeSpentOnCard()
                let (secondsStr, minutesStr, hoursStr) = splitSeconds(secondsCount : seconds)
                cell.timeSpentLabel?.text = "\(hoursStr):\(minutesStr):\(secondsStr)"
            } else {
                cell.timeSpentLabel.isHidden = true
            }
        } else {
            cell.QuestionLabel?.text = self.listOfCards[indexPath.row].getQuestion()
            cell.AnswerLabel?.text = self.listOfCards[indexPath.row].getAnswer()
            cell.correctLabel?.text = "Correct: \(self.listOfCards[indexPath.row].getCorrectCount())"
            cell.incorrectLabel?.text = "Incorrect: \(self.listOfCards[indexPath.row].getIncorrectCount())"
            if(timeMode == true) {
                let seconds = self.listOfCards[indexPath.row].getTimeSpentOnCard()
                let (secondsStr, minutesStr, hoursStr) = splitSeconds(secondsCount : seconds)
                cell.timeSpentLabel?.text = "\(hoursStr):\(minutesStr):\(secondsStr)"
            } else {
                cell.timeSpentLabel.isHidden = true
            }
        }
        return cell
    }
    
    //transforms counts to double-digit number
    func transformToTime(count : Int) -> String {
        var countStr = ""
        
        if (count < 10) {
            countStr = "0\(count)"
        } else {
            countStr = String(count)
        }
        return countStr
    }
    
    //splits seconds into hours:minutes:seconds format
    func splitSeconds(secondsCount : Int) -> (String, String, String) {
        var minutes = 0
        var seconds = 0
        var hours = 0
        
        //calculates minutes out of seconds
        if (secondsCount >= 60) {
            minutes = secondsCount / 60
            seconds = secondsCount % 60
        } else {
            seconds = secondsCount
        }
        
        //calculates hours out of minutes
        if (minutes >= 60) {
            hours = minutes / 60
            minutes = minutes % 60
        }
        
        //transforms to string
        let secondsStr = transformToTime(count : seconds)
        let minutesStr = transformToTime(count : minutes)
        let hoursStr = transformToTime(count : hours)
        
        return (secondsStr, minutesStr, hoursStr)
    }
}
