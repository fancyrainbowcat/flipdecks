//
//  MemoryViewCell.swift
//  FlipDecks
//
//  Created by Bea Sax on 16.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

class MemoryViewCell: UICollectionViewCell {
    
    //IBOutlets for CollectionViewCells
    
    @IBOutlet weak var frontCellLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    
    var shown: Bool = false
    
    func showCard (_ show: Bool, animated: Bool) {
        cellImageView.isHidden = false
        frontCellLabel.isHidden = false
        shown = show
        
        // flip animation for CollectionViewCells yay
        if animated {
            if show {
                UIView.transition(from: cellImageView,
                                  to: frontCellLabel,
                                  duration: 0.5,
                                  options: [.transitionFlipFromRight, .showHideTransitionViews],
                                  completion: { (finished: Bool) -> () in
                })
            } else {
                UIView.transition(from: cellImageView,
                                  to: frontCellLabel,
                                  duration: 0.5,
                                  options: [.transitionFlipFromRight, .showHideTransitionViews],
                                  completion:  { (finished: Bool) -> () in
                })
            }
        } else {
            if show {
                bringSubview(toFront: frontCellLabel)
                cellImageView.isHidden = true
            } else {
                bringSubview(toFront: cellImageView)
                frontCellLabel.isHidden = true
            }
        }
    }
}
