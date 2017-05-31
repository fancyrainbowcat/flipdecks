//
//  FancyButton.swift
//  cities
//
//  Created by admin on 24.05.17.
//  Copyright © 2017 tip. All rights reserved.
//

import UIKit

@IBDesignable
class FancyButton: UIButton {

    @IBInspectable var fancyColor: UIColor = UIColor.red
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path = UIBezierPath(ovalIn: rect)
        fancyColor.setFill()
        path.fill()
    }

}
