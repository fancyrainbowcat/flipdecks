//
//  ModusViewController.swift
//  FlipDecks
//
//  Created by Nicola Greth on 04.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit

//View Controller for all modi for one unit for one language
class ModusViewController: UIViewController {

    var unitName = ""
    var languageName = ""
    
    //set title when view was loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(languageName) - \(unitName)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
