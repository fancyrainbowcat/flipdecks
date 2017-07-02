//
//  ListAndSearchViewController.swift
//  FlipDecks
//
//  Created by Nicola Greth on 25.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

class ListAndSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    // current deck and language
    var deck : Deck = Deck(name: "", languageName: "", fileEnding: "")
    var language : Language = Language(name: "")
    var listOfCards = [Card]()
    var filteredCards = [Card]()
    var timeMode = false
    var searchActive : Bool = false
    
    @IBOutlet weak var listAndSearchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //sorting functionality 
    var sortingCriterium = "Question"
    var sortingOrder = "asc"
    
    @IBOutlet weak var sortByQuestionButton: UIBarButtonItem!
    @IBOutlet weak var sortByAnswerButton: UIBarButtonItem!
    @IBOutlet weak var sortByCorrectButton: UIBarButtonItem!
    @IBOutlet weak var sortByIncorrectButton: UIBarButtonItem!
    @IBOutlet weak var sortByTimeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listAndSearchTableView.delegate = self as UITableViewDelegate
        listAndSearchTableView.dataSource = self as UITableViewDataSource
        searchBar.delegate = self
        self.listOfCards = sortArrayOfCards(oldListOfCards: self.deck.returnAllCards())
        
        if(timeMode == false) {
            sortByTimeButton.isEnabled = false
            sortByTimeButton.title = ""
        } else {
            sortByTimeButton.isEnabled = true
        }
        
        //to cancel keyboard when screen is tapped
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //closes keyboard when screen is tapped anywhere
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //function that will be called when there is input in the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //filters cards on question and answer (lowercased)
        filteredCards = listOfCards.filter { $0.getQuestion().lowercased().contains(searchText.lowercased()) || $0.getAnswer().lowercased().contains(searchText.lowercased())}

        //search is active when the searchtext is not empty
        if (searchText == "") {
            searchActive = false
        } else {
            searchActive = true
        }
        
        //data has to be reloaded after search
        self.listAndSearchTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //rows of table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchActive) {
            return self.filteredCards.count
        }
        return self.listOfCards.count
    }
    
    //sorts array of cards 
    func sortArrayOfCards(oldListOfCards : [Card]) -> [Card] {
        var newListOfCards = [Card]()
    
        if (self.sortingCriterium == "Question" && self.sortingOrder == "asc") {
            newListOfCards = oldListOfCards.sorted(by: {$0.getQuestion() < $1.getQuestion()})
        } else if (self.sortingCriterium == "Answer" && self.sortingOrder == "asc") {
            newListOfCards = oldListOfCards.sorted(by: {$0.getAnswer() < $1.getAnswer()})
        } else if (self.sortingCriterium == "Correct" && self.sortingOrder == "asc") {
            newListOfCards = oldListOfCards.sorted(by: {$0.getCorrectCount() < $1.getCorrectCount()})
        } else if (self.sortingCriterium == "Incorrect" && self.sortingOrder == "asc") {
            newListOfCards = oldListOfCards.sorted(by: {$0.getIncorrectCount() < $1.getIncorrectCount()})
        } else if (self.sortingCriterium == "Time" && self.sortingOrder == "asc"){
            newListOfCards = oldListOfCards.sorted(by: {$0.getTimeSpentOnCard() < $1.getTimeSpentOnCard()})
        } else if (self.sortingCriterium == "Question" && self.sortingOrder == "desc") {
            newListOfCards = oldListOfCards.sorted(by: {$0.getQuestion() > $1.getQuestion()})
        } else if (self.sortingCriterium == "Answer" && self.sortingOrder == "desc") {
            newListOfCards = oldListOfCards.sorted(by: {$0.getAnswer() > $1.getAnswer()})
        } else if (self.sortingCriterium == "Correct" && self.sortingOrder == "desc") {
            newListOfCards = oldListOfCards.sorted(by: {$0.getCorrectCount() > $1.getCorrectCount()})
        } else if (self.sortingCriterium == "Incorrect" && self.sortingOrder == "desc") {
            newListOfCards = oldListOfCards.sorted(by: {$0.getIncorrectCount() > $1.getIncorrectCount()})
        } else if (self.sortingCriterium == "Time" && self.sortingOrder == "desc"){
            newListOfCards = oldListOfCards.sorted(by: {$0.getTimeSpentOnCard() > $1.getTimeSpentOnCard()})
        }
        
        return newListOfCards
    }
    
    //content of table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListAndSearchTableViewCell
        
        //cells cannot be selected
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        //search mode
        if (searchActive) {
            self.filteredCards = sortArrayOfCards(oldListOfCards: self.filteredCards)
            cell.QuestionLabel?.text = self.filteredCards[indexPath.row].getQuestion()
            cell.AnswerLabel?.text = self.filteredCards[indexPath.row].getAnswer()
            cell.correctLabel?.text = "Correct: \(self.filteredCards[indexPath.row].getCorrectCount())"
            cell.incorrectLabel?.text = "Incorrect: \(self.filteredCards[indexPath.row].getIncorrectCount())"
            
            //times will be shown when timemode is active
            if(timeMode == true) {
                let seconds = self.filteredCards[indexPath.row].getTimeSpentOnCard()
                let (secondsStr, minutesStr, hoursStr) = splitSeconds(secondsCount : seconds)
                cell.timeSpentLabel?.text = "\(hoursStr):\(minutesStr):\(secondsStr)"
            } else {
                cell.timeSpentLabel.isHidden = true
            }
        } //normal mode
        else {
            self.listOfCards = sortArrayOfCards(oldListOfCards: self.listOfCards)
            cell.QuestionLabel?.text = self.listOfCards[indexPath.row].getQuestion()
            cell.AnswerLabel?.text = self.listOfCards[indexPath.row].getAnswer()
            cell.correctLabel?.text = "Correct: \(self.listOfCards[indexPath.row].getCorrectCount())"
            cell.incorrectLabel?.text = "Incorrect: \(self.listOfCards[indexPath.row].getIncorrectCount())"
            
            //times will be shown when timemode is active
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
    
    //all sorting functionality buttons
    @IBAction func sortByQuestion(_ sender: Any) {
        self.sortingCriterium = "Question"
        
        if (self.sortingOrder == "asc") {
            self.sortingOrder = "desc"
        } else {
            self.sortingOrder = "asc"
        }
        
        self.listAndSearchTableView.reloadData()
    }
    
    @IBAction func sortByAnswer(_ sender: Any) {
        self.sortingCriterium = "Answer"
        
        if (self.sortingOrder == "asc") {
            self.sortingOrder = "desc"
        } else {
            self.sortingOrder = "asc"
        }
        
        self.listAndSearchTableView.reloadData()
    }
    
    @IBAction func sortByCorrect(_ sender: Any) {
        self.sortingCriterium = "Correct"
        
        if (self.sortingOrder == "asc") {
            self.sortingOrder = "desc"
        } else {
            self.sortingOrder = "asc"
        }
        
        self.listAndSearchTableView.reloadData()
    }
    
    @IBAction func sortByIncorrect(_ sender: Any) {
        self.sortingCriterium = "Incorrect"
        
        if (self.sortingOrder == "asc") {
            self.sortingOrder = "desc"
        } else {
            self.sortingOrder = "asc"
        }
        
        self.listAndSearchTableView.reloadData()
    }
    
    @IBAction func sortByTime(_ sender: Any) {
        self.sortingCriterium = "Time"
        
        if (self.sortingOrder == "asc") {
            self.sortingOrder = "desc"
        } else {
            self.sortingOrder = "asc"
        }
        
        self.listAndSearchTableView.reloadData()
    }
}
