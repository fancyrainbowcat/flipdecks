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

    @IBOutlet weak var barChartView: BarChartView!
    var deck : Deck = Deck(name: "", languageName: "", fileEnding: "")
    var language : Language = Language(name: "")
    var listOfCards = [Card]()

    @IBOutlet weak var pieChartView: PieChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var unfinished = 0
        var NotPlayed = 0
        var finished = 0
        var correct = 0
        var incorrect = 0
        
        self.listOfCards =  self.deck.returnAllCards()
        for card in self.listOfCards
            
            {   // increment correct incorrect Barchart
                correct += card.getCorrectCount()
                incorrect += card.getIncorrectCount()
          
                // PieChart
                if card.getCorrectCount() >= 3
                    {finished += 1}
                else if (card.getCorrectCount() == 0 && card.getIncorrectCount() == 0 )
                    {NotPlayed += 1}
                else
                    {unfinished += 1}
            }
        
        // Barchart
        let answer1 = ["Correct", "Incorrect"]
        let score1 = [correct, incorrect]
        // PieChart
        let answer = ["Finished", "Unfinished", "Not-Played"]
        let score  = [finished, unfinished, NotPlayed]

        pieChartView.holeRadiusPercent = 0.5
        pieChartView.chartDescription = nil
        pieChartView.centerText = "Statistic Per Unit"

        // func Barchart
        setChart1(dataPoints: answer1, values: score1)
        // func PieChart
        setChart(dataPoints: answer, values: score)
    }

    // func dial Barchart
    func setChart1(dataPoints: [String], values: [Int]) {
        
        barChartView.noDataText = "There is no Data"
        
        //customize the legend
        let legend = barChartView.legend
        legend.setCustom(colors: [UIColor.green, UIColor.red], labels: ["Correct", "Incorrect"])
        legend.font = UIFont( name: "HelveticaNeue-Bold", size: 15.0)!
        
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry1 = BarChartDataEntry(x: Double(Int(i)), y: Double(values[i]))
                //, data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry1)
        }
        
       // print(dataEntries[0].data)
        
        var colors: [UIColor] = [UIColor.green, UIColor.red]
        for _ in 0..<dataPoints.count {
            
            let color = UIColor.green
            colors.append(color)        }
        
        // custonize the dataentries
        let barChartDataSet = BarChartDataSet(values: dataEntries, label: "Score")
        barChartDataSet.colors = colors
        barChartDataSet.valueFont = UIFont( name: "HelveticaNeue-Bold", size: 15.0)!
        
        
        barChartView.backgroundColor = UIColor.gray
        barChartView.xAxis.labelPosition = .bottom
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawAxisLineEnabled = true
        barChartView.rightAxis.drawLabelsEnabled = false
        barChartView.leftAxis.drawLabelsEnabled = false
        barChartView.xAxis.drawLabelsEnabled = false
        
        barChartView.chartDescription = nil
        
        // hide the 0.0
        let noZeroFormatter = NumberFormatter()
        noZeroFormatter.zeroSymbol = ""
        barChartDataSet.valueFormatter = DefaultValueFormatter(formatter: noZeroFormatter)

        
        let barChartData = BarChartData(dataSet: barChartDataSet)
        
        barChartView.data = barChartData
        
//        self.barChartView.data = barChartData
        self.barChartView.animate(xAxisDuration: TimeInterval(2))
        
    }

    
    // func dial pie chart
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
        
        // hide dataentries  0.0
        let noZeroFormatter = NumberFormatter()
        noZeroFormatter.zeroSymbol = ""
        pieChartDataSet.valueFormatter = DefaultValueFormatter(formatter: noZeroFormatter)
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        pieChartView.data = pieChartData
        
        //customize the legend
        let legend = pieChartView.legend
        legend.setCustom(colors: [UIColor.green, UIColor.red , UIColor.gray], labels: ["Finished", "Unfinished", "Not-Played"])
        legend.font = UIFont( name: "HelveticaNeue-Bold", size: 15.0)!
        
        
        //customize the centre Text
        let myCenterText = [ NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 20.0)! ]
        let myAttrString = NSAttributedString(string: "Statistic Per Unit", attributes: myCenterText)
        pieChartView.centerAttributedText = myAttrString
        
        
        
        var colors: [UIColor] = [UIColor.green, UIColor.red , UIColor.gray]
        
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
