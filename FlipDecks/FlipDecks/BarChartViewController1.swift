//
//  BarChartViewController1.swift
//  FlipDecks
//
//  Created by admin on 26.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit
import Charts





class BarChartViewController1: UIViewController {
@IBOutlet weak var barChartView: BarChartView!
    
        var deck : Deck = Deck(name: "", languageName: "", fileEnding: "")
        var language : Language = Language(name: "")
        var listOfCards = [Card]()
        var listOfUnits = [Deck]()

    func getListOfUnits() {
        if (self.language.getName() != "") {
            self.listOfUnits = (language.returnAllDecks())
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
            getListOfUnits()
            print(self.listOfUnits)
        
        
            var answer: [String] = []
            var score: [Int] = []
            var labels: [String] = []
        
                for unit in self.listOfUnits
                    {
                        var correct = 0
                        var incorrect = 0
            
                        self.listOfCards =  unit.returnAllCards()
                        for card in self.listOfCards
                            {
                
                                correct += card.getCorrectCount()
                                incorrect += card.getIncorrectCount()
                        }
                    answer+=(["Correct", "Incorrect"])
                    score += ([correct, incorrect])
                    
                    labels.append(unit.getName())

                }
        
  
            setChart(dataPoints: answer, values: score)

         }
    
    
        
        func setChart(dataPoints: [String], values: [Int]) {
            
            barChartView.noDataText = "There is no Data"
            var dataEntries: [BarChartDataEntry] = []
            var colors: [UIColor] = []
            
   /*         var labels: String
            
            
            
            
            for unit in self.listOfUnits
            {
                
                self.listOfCards =  unit.returnAllCards()
                
                labels = unit.getName()
                
            }
            
  */
            for i in 0..<dataPoints.count
                {
                    let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
                    
                    dataEntries.append(dataEntry)
                    
                    let status = dataPoints[i]
                        if status == "Correct"
                            {colors.append(UIColor.green)}
                        else
                            {colors.append(UIColor.red)}
                }
            
            for _ in 0..<dataPoints.count
                {
                    let color = UIColor.green
                    colors.append(color)
                }
            
            // customize the barchartview
            barChartView.backgroundColor = UIColor.gray
            barChartView.xAxis.labelPosition = .bottom
            barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
            barChartView.xAxis.drawAxisLineEnabled = false
            barChartView.xAxis.drawGridLinesEnabled = false
            barChartView.leftAxis.drawAxisLineEnabled = true
            
            barChartView.chartDescription = nil
            
            // customize legends
            let legend = barChartView.legend
            legend.setCustom(colors: [UIColor.green, UIColor.red ], labels: ["Correct", "Incorrect"])
            legend.font = UIFont( name: "HelveticaNeue-Bold", size: 15.0)!
            
            // append the dataset
            let data = BarChartDataSet(values: dataEntries, label: "" )
            var datasets=[IChartDataSet]()
            datasets.append(data)
            let linechartdata=BarChartData(dataSets: datasets)
            barChartView.data = linechartdata
            data.colors = colors
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
