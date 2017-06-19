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
    
    let gameController = MemoryGame()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.MemoryCollectionView.delegate = self
        self.MemoryCollectionView.dataSource = self
        
        
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
    
       // gameController.selectCard()
        
        collectionView.deselectItem(at: indexPath, animated:true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let numberOfColumns:Int = self.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
        
        let itemWidth: CGFloat = collectionView.frame.width / 3.0 - 15.0 //numberOfColumns as CGFloat - 10 //- (minimumInteritemSpacing * numberOfColumns))
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    

    
    func setupNewGame() {
        let cardsData:[UILabel] = MemoryGame.defaultCardLabels
        gameController.newGame(cardsData)
    }

    

    // IBOutlets
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var MemoryCollectionView: UICollectionView!

}

