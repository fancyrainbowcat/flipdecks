//
//  PieChartViewController.swift
//  FlipDecks
//
//  Created by admin on 27.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit
import Charts

class PieChartViewController: UIViewController {

    var deck : Deck = Deck(name: "", languageName: "", fileEnding: "")
    var language : Language = Language(name: "")
    var listOfCards = [Card]()

    @IBOutlet weak var pieChartView: PieChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var correct = 0
        var incorrect = 0
        self.listOfCards =  self.deck.returnAllCards()
        for card in self.listOfCards
        {
            correct += card.getCorrectCount()
            incorrect += card.getIncorrectCount()
        }
        let answer = ["Correct", "Incorrect"]
        let score = [correct, incorrect]
        pieChartView.holeRadiusPercent = 0.5
        pieChartView.descriptionText = "";
        pieChartView.centerText = "Statistic Per Unit"

        
        setChart(dataPoints: answer, values: score)
    }

    func setChart(dataPoints: [String], values: [Int]) {
 
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
           let dataEntry1 = ChartDataEntry(x: Double(Int(i)), y: Double(values[i]), data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry1)
        }
        
        print(dataEntries[0].data)
        
        // custonize the dataentries
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Score")
        pieChartDataSet.valueFont = UIFont( name: "HelveticaNeue-Bold", size: 15.0)!
        pieChartDataSet.colors = [UIColor.black]
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        pieChartView.data = pieChartData
        
        //customize the legend
        let legend = pieChartView.legend
        legend.setCustom(colors: [UIColor.green, UIColor.red], labels: ["Correct", "Incorrect"])
        legend.font = UIFont( name: "HelveticaNeue-Bold", size: 15.0)!
        
        
        //customize the centre Text
        let myCenterText = [ NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 20.0)! ]
        let myAttrString = NSAttributedString(string: "Statistic Per Unit", attributes: myCenterText)
        pieChartView.centerAttributedText = myAttrString
        
        
        
        var colors: [UIColor] = [UIColor.green, UIColor.red]
        
        for _ in 0..<dataPoints.count {
           // let red = Double(arc4random_uniform(256))
            //let green = Double(arc4random_uniform(256))
            //let blue = Double(arc4random_uniform(256))
            
            let color = UIColor.green //UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)        }
        
        pieChartDataSet.colors = colors
        
        
        self.pieChartView.data = pieChartData
        self.pieChartView.animate(xAxisDuration: TimeInterval(2))
 
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
}
