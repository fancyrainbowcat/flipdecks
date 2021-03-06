//
//  ListAndSearchViewController.swift
//  FlipDecks
//
//  Created by Nicola Greth on 25.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

class ListAndSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    // current deck and language (filled via segue)
    var deck : Deck = Deck(name: "", languageName: "", fileEnding: "")
    var language : Language = Language(name: "")
    
    //list for cards and filtered cards
    var listOfCards = [Card]()
    var filteredCards = [Card]()
    
    //timeMode on/off (filled via segue)
    var timeMode = false
    
    //shows when user is searching
    var searchActive : Bool = false
    
    //sorting functionality
    var sortingCriterium = "Question"
    var sortingOrder = "asc"
    
    //IBOutlets
    @IBOutlet weak var listAndSearchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortByQuestionButton: UIBarButtonItem!
    @IBOutlet weak var sortByAnswerButton: UIBarButtonItem!
    @IBOutlet weak var sortByCorrectButton: UIBarButtonItem!
    @IBOutlet weak var sortByIncorrectButton: UIBarButtonItem!
    @IBOutlet weak var sortByTimeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //controller should act as TableView and have a SearchBar
        listAndSearchTableView.delegate = self as UITableViewDelegate
        listAndSearchTableView.dataSource = self as UITableViewDataSource
        searchBar.delegate = self
        
        //fill list of all cards from current deck
        self.listOfCards = sortArrayOfCards(oldListOfCards: self.deck.returnAllCards())
        
        //time button will only appear in sorting menu if time mode is switched on
        if(timeMode == false) {
            sortByTimeButton.isEnabled = false
            sortByTimeButton.title = ""
        } else {
            sortByTimeButton.isEnabled = true
        }
        
        //to cancel keyboard when screen is tapped
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //reset all sort button colors
        self.sortByTimeButton.tintColor = UIColor.green
        self.sortByQuestionButton.tintColor = UIColor.orange
        self.sortByAnswerButton.tintColor = UIColor.green
        self.sortByCorrectButton.tintColor = UIColor.green
        self.sortByIncorrectButton.tintColor = UIColor.green
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
        
        //data has to be reloaded after search -> to show only the filtered cards based on search criterium
        self.listAndSearchTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //fill rows of table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //when search is active use list of filtered cards
        if (searchActive) {
            return self.filteredCards.count
        }
        
        //if search is not active use list of all cards
        return self.listOfCards.count
    }
    
    //sorts array of cards 
    func sortArrayOfCards(oldListOfCards : [Card]) -> [Card] {
        var newListOfCards = [Card]()
    
        //different possibilities on how to search
        //if the sort criterium is not question or answer it will sort by the criterium and then by question, to make the sorting order distinct
        
        //sort by question ascending
        if (self.sortingCriterium == "Question" && self.sortingOrder == "asc") {
            newListOfCards = oldListOfCards.sorted(by: {$0.getQuestion() < $1.getQuestion()})
        }
        //sort by answer ascending
        else if (self.sortingCriterium == "Answer" && self.sortingOrder == "asc") {
            newListOfCards = oldListOfCards.sorted(by: {$0.getAnswer() < $1.getAnswer()})
        }
        //sort by correctCount ascending, then by question ascending
        else if (self.sortingCriterium == "Correct" && self.sortingOrder == "asc") {
            newListOfCards = oldListOfCards.sorted(by:{
                if ($0.getCorrectCount() != $1.getCorrectCount()) {
                    return $0.getCorrectCount() < $1.getCorrectCount()
                } else {
                    return $0.getQuestion() < $1.getQuestion()
                }
            })
        }
        //sort by incorrectCount ascending, then by question ascending
        else if (self.sortingCriterium == "Incorrect" && self.sortingOrder == "asc") {
            newListOfCards = oldListOfCards.sorted(by:{
                if ($0.getIncorrectCount() != $1.getIncorrectCount()) {
                    return $0.getIncorrectCount() < $1.getIncorrectCount()
                } else {
                    return $0.getQuestion() < $1.getQuestion()
                }
            })
        }
        //sort by time ascending, then by question ascending
        else if (self.sortingCriterium == "Time" && self.sortingOrder == "asc"){
            newListOfCards = oldListOfCards.sorted(by:{
                if ($0.getTimeSpentOnCard() != $1.getTimeSpentOnCard()) {
                    return $0.getTimeSpentOnCard() < $1.getTimeSpentOnCard()
                } else {
                    return $0.getQuestion() < $1.getQuestion()
                }
            })
        }
        //sort by question descending
        else if (self.sortingCriterium == "Question" && self.sortingOrder == "desc") {
            newListOfCards = oldListOfCards.sorted(by: {$0.getQuestion() > $1.getQuestion()})
        }
        //sort by answer descending
        else if (self.sortingCriterium == "Answer" && self.sortingOrder == "desc") {
            newListOfCards = oldListOfCards.sorted(by: {$0.getAnswer() > $1.getAnswer()})
        }
        //sort by correctCount descending, then by question descending
        else if (self.sortingCriterium == "Correct" && self.sortingOrder == "desc") {
            newListOfCards = oldListOfCards.sorted(by:{
                if ($0.getCorrectCount() != $1.getCorrectCount()) {
                    return $0.getCorrectCount() > $1.getCorrectCount()
                } else {
                    return $0.getQuestion() > $1.getQuestion()
                }
            })
        }
        //sort by incorrectCount descending, then by question descending
        else if (self.sortingCriterium == "Incorrect" && self.sortingOrder == "desc") {
            newListOfCards = oldListOfCards.sorted(by:{
                if ($0.getIncorrectCount() != $1.getIncorrectCount()) {
                    return $0.getIncorrectCount() > $1.getIncorrectCount()
                } else {
                    return $0.getQuestion() > $1.getQuestion()
                }
            })
        }
        //sort by time descending, then by question descending
        else if (self.sortingCriterium == "Time" && self.sortingOrder == "desc"){
            newListOfCards = oldListOfCards.sorted(by:{
                if ($0.getTimeSpentOnCard() != $1.getTimeSpentOnCard()) {
                    return $0.getTimeSpentOnCard() > $1.getTimeSpentOnCard()
                } else {
                    return $0.getQuestion() > $1.getQuestion()
                }
            })
        }
        
        //return sorted list of cards
        return newListOfCards
    }
    
    //content of table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //current cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListAndSearchTableViewCell
        
        //cells cannot be selected
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        //if search is active use filtered list of cards
        if (searchActive) {
            self.filteredCards = sortArrayOfCards(oldListOfCards: self.filteredCards)
            cell.QuestionLabel?.text = self.filteredCards[indexPath.row].getQuestion()
            cell.AnswerLabel?.text = self.filteredCards[indexPath.row].getAnswer()
            cell.correctLabel?.text = "Correct: \(self.filteredCards[indexPath.row].getCorrectCount())"
            cell.incorrectLabel?.text = "Incorrect: \(self.filteredCards[indexPath.row].getIncorrectCount())"
            
            //times will only be shown when timemode is active
            if(timeMode == true) {
                let seconds = self.filteredCards[indexPath.row].getTimeSpentOnCard()
                
                //transform time in seconds to correct time format
                let (secondsStr, minutesStr, hoursStr) = splitSeconds(secondsCount : seconds)
                cell.timeSpentLabel?.text = "\(hoursStr):\(minutesStr):\(secondsStr)"
            } else {
                cell.timeSpentLabel.isHidden = true
            }
        } //if search is not active use normal list of cards
        else {
            self.listOfCards = sortArrayOfCards(oldListOfCards: self.listOfCards)
            cell.QuestionLabel?.text = self.listOfCards[indexPath.row].getQuestion()
            cell.AnswerLabel?.text = self.listOfCards[indexPath.row].getAnswer()
            cell.correctLabel?.text = "Correct: \(self.listOfCards[indexPath.row].getCorrectCount())"
            cell.incorrectLabel?.text = "Incorrect: \(self.listOfCards[indexPath.row].getIncorrectCount())"
            
            //times will be shown when timemode is active
            if(timeMode == true) {
                let seconds = self.listOfCards[indexPath.row].getTimeSpentOnCard()
                
                //transform time in seconds to correct time format
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
    //sort by question
    @IBAction func sortByQuestion(_ sender: Any) {
        
        //set orange color to chosen button
        self.sortByTimeButton.tintColor = UIColor.green
        self.sortByQuestionButton.tintColor = UIColor.orange
        self.sortByAnswerButton.tintColor = UIColor.green
        self.sortByCorrectButton.tintColor = UIColor.green
        self.sortByIncorrectButton.tintColor = UIColor.green
        
        self.sortingCriterium = "Question"
        
        //when button is clicked sorting order will switched
        if (self.sortingOrder == "asc") {
            self.sortingOrder = "desc"
        } else {
            self.sortingOrder = "asc"
        }
        
        //show sorted data
        self.listAndSearchTableView.reloadData()
    }
    
    //sort by answer
    @IBAction func sortByAnswer(_ sender: Any) {
        
        //set orange color to chosen button
        self.sortByTimeButton.tintColor = UIColor.green
        self.sortByQuestionButton.tintColor = UIColor.green
        self.sortByAnswerButton.tintColor = UIColor.orange
        self.sortByCorrectButton.tintColor = UIColor.green
        self.sortByIncorrectButton.tintColor = UIColor.green
        
        self.sortingCriterium = "Answer"
        
        //when button is clicked sorting order will switched
        if (self.sortingOrder == "asc") {
            self.sortingOrder = "desc"
        } else {
            self.sortingOrder = "asc"
        }
        
        //show sorted data
        self.listAndSearchTableView.reloadData()
    }
    
    //sort by correct count
    @IBAction func sortByCorrect(_ sender: Any) {
        
        //set orange color to chosen button
        self.sortByTimeButton.tintColor = UIColor.green
        self.sortByQuestionButton.tintColor = UIColor.green
        self.sortByAnswerButton.tintColor = UIColor.green
        self.sortByCorrectButton.tintColor = UIColor.orange
        self.sortByIncorrectButton.tintColor = UIColor.green
        
        self.sortingCriterium = "Correct"
        
        //when button is clicked sorting order will switched
        if (self.sortingOrder == "asc") {
            self.sortingOrder = "desc"
        } else {
            self.sortingOrder = "asc"
        }
        
        //show sorted data
        self.listAndSearchTableView.reloadData()
    }
    
    //sort by incorrect count
    @IBAction func sortByIncorrect(_ sender: Any) {
        
        //set orange color to chosen button
        self.sortByTimeButton.tintColor = UIColor.green
        self.sortByQuestionButton.tintColor = UIColor.green
        self.sortByAnswerButton.tintColor = UIColor.green
        self.sortByCorrectButton.tintColor = UIColor.green
        self.sortByIncorrectButton.tintColor = UIColor.orange
        
        self.sortingCriterium = "Incorrect"
        
        //when button is clicked sorting order will switched
        if (self.sortingOrder == "asc") {
            self.sortingOrder = "desc"
        } else {
            self.sortingOrder = "asc"
        }
        
        //show sorted data
        self.listAndSearchTableView.reloadData()
    }
    
    //sort by time 
    @IBAction func sortByTime(_ sender: Any) {
        
        //set orange color to chosen button
        self.sortByTimeButton.tintColor = UIColor.orange
        self.sortByQuestionButton.tintColor = UIColor.green
        self.sortByAnswerButton.tintColor = UIColor.green
        self.sortByCorrectButton.tintColor = UIColor.green
        self.sortByIncorrectButton.tintColor = UIColor.green
        
        self.sortingCriterium = "Time"
        
        //when button is clicked sorting order will switched
        if (self.sortingOrder == "asc") {
            self.sortingOrder = "desc"
        } else {
            self.sortingOrder = "asc"
        }
        
        //show sorted data
        self.listAndSearchTableView.reloadData()
    }
}
