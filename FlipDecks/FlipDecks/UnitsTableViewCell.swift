//
//  UnitsTableViewCell.swift
//  FlipDecks
//
//  Created by Nicola Greth on 14.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

//cell for units table view 
class UnitsTableViewCell: UITableViewCell {
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var ProgressBar: UIProgressView!
    
    //set color of progress bar 
    func returnColor() -> UIColor {
        if (self.ProgressBar.progress > 0.66) {
            return UIColor.green
        } else if (self.ProgressBar.progress > 0.33) {
            return UIColor.yellow
        }
        
        return UIColor.red
    }
}
