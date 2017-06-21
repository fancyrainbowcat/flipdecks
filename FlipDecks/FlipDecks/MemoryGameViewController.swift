//
//  MemoryGameViewController.swift
//  FlipDecks
//
//  Created by Bea Sax on 14.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    // Returns an array containing this sequence shuffled
    var shuffled: Array {
        var elements = self
        return elements.shuffle()
    }
   // Shuffles this sequence in place
    @discardableResult
    mutating func shuffle() -> Array {
        indices.dropLast().forEach {
            guard case let index = Int(arc4random_uniform(UInt32(count - $0))) + $0, index != $0 else { return }
            swap(&self[$0], &self[index])
        }
        return self
    }
    var chooseOne: Element { return self[Int(arc4random_uniform(UInt32(count)))] }
    func choose(_ n: Int) -> Array { return Array(shuffled.prefix(n)) }
}



class MemoryGameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var deck : Deck = Deck(name: "", languageName: "", fileEnding: "")
    var language : Language = Language(name: "")
   // var mCards = [Card]()
    var testArray = [1,2,3,4,5,6,7,8,9,10,11,12,13]
    var backImage = ["mCardBack"]
    
    var answers: [MemoryCard] = [MemoryCard]()
    var questions: [MemoryCard] = [MemoryCard]()
    
    let gameController = MemoryGame()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MemoryCollectionView.delegate = self
        self.MemoryCollectionView.dataSource = self
        
        print(deck.listOfCards[0].getQuestion())
        
        let mCards = deck.listOfCards.choose(6)
        let testLeFunc = testArray.choose(6)
        
        print(mCards)
        print(testLeFunc)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12   // array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mcell = collectionView.dequeueReusableCell(withReuseIdentifier: "mCell", for: indexPath) as! MemoryViewCell
        // set images to the cells
        
        mcell.cellImageView.image = UIImage(named: backImage[0]) // or named: backImage[indexPath.row]
        
        mcell.showCard(false, animated: false)
        return mcell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MemoryViewCell
        
        if cell.shown { return }
        cell.showCard(true, animated: true)
        
        cell.mCard = MemoryCard(cellText: deck.listOfCards[0].getQuestion(), id: deck.listOfCards[0])
        
        gameController.selectCard(cell : cell, mCard: cell.mCard!)
        
        collectionView.deselectItem(at: indexPath, animated:true)
    }
    

    
    func setupNewGame() {
        gameController.newGame(cardsData: MemoryGame.defaultCardStrings)
    }
    func divideCards(cards:[Card]) {
       // split dat array in questions and answers!
        for card in cards {
            let answer = card.getAnswer()
            let question = card.getQuestion()
            answers.append(MemoryCard(cellText: answer, id: card))
            questions.append(MemoryCard(cellText: question, id: card))
        }
        // shuffle both of the arrays
        questions.shuffle()
        answers.shuffle()
    }
    
    

    // IBOutlets
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var MemoryCollectionView: UICollectionView!

}

