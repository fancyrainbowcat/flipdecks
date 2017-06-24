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
    var backImage = ["mCardBack"]
    var answers: [MemoryCard] = [MemoryCard]()
    var questions: [MemoryCard] = [MemoryCard]()
    
    var finalMemoryCards = [MemoryCard]()
    
    
    
    let gameController = MemoryGame()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MemoryCollectionView.delegate = self
        self.MemoryCollectionView.dataSource = self
        
        finalMemoryCards = setupNewCards()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return finalMemoryCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mcell = collectionView.dequeueReusableCell(withReuseIdentifier: "mCell", for: indexPath) as! MemoryViewCell

       
        //set Labels to cells
        startCards([finalMemoryCards[indexPath.row]], mcell as MemoryViewCell)
        // set back image to cells
        mcell.cellImageView.image = UIImage(named: backImage[0]) // or if different images named: backImage[indexPath.row]
        
        mcell.showCard(false, animated: false)
        return mcell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MemoryViewCell
        
        if cell.shown { return }
        cell.showCard(true, animated: true)
        
        gameController.selectCard(cell : cell, mCard: cell.mCard!)
        
        collectionView.deselectItem(at: indexPath, animated:true)
    }
    
    // TODO: Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let numberOfColumns:Int = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
        
        let itemWidth: CGFloat = collectionView.frame.width / 3.0 - 15.0 //numberOfColumns as CGFloat - 10 //- (minimumInteritemSpacing * numberOfColumns))
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    

    
    func setupNewCards() -> [MemoryCard] {

        let mCards = deck.listOfCards.choose(6)

        let finalMemoryCards = divideCards(cards: mCards)
        
        return finalMemoryCards
    }
    
    func divideCards(cards:[Card]) -> [MemoryCard] {
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
        
        // combine them to one wonderful Array
        var finalMemoryCards = questions + answers
        // shuffle it again - MAXIMUM SHUFFLE
        finalMemoryCards.shuffle()
        
    
        return finalMemoryCards
    }
    
    func startCards (_ mCards: [MemoryCard], _ cell: MemoryViewCell) {
        for card in mCards {
            cell.setCard(mCell: cell, cellText: card.frontCellText, mCard: card)
        }
    }

    // IBOutlets
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var MemoryCollectionView: UICollectionView!

}

