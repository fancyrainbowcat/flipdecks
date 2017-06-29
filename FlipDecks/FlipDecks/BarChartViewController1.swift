//
//  BarChartViewController1.swift
//  FlipDecks
//
//  Created by admin on 26.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit
import Charts


//var answer: [String]!


class BarChartViewController1: UIViewController {
@IBOutlet weak var barChartView: BarChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let answer = ["True", "False"]
        let units = [20.0, 4.0]
        
        
        setChart(dataPoints: answer, values: units)

         }
        
        func setChart(dataPoints: [String], values: [Double]) {
            barChartView.noDataText = "There is no Data"
            
            var dataEntries: [BarChartDataEntry] = []
            
            for i in 0..<dataPoints.count
            {
                let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
                dataEntries.append(dataEntry)
            }
            
            
            var colors: [UIColor] = [UIColor.green, UIColor.red]
            
            for _ in 0..<dataPoints.count {
                // let red = Double(arc4random_uniform(256))
                //let green = Double(arc4random_uniform(256))
                //let blue = Double(arc4random_uniform(256))
                //let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
                
                let color = UIColor.green
                colors.append(color)        }
            
          

            
            
            barChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
            barChartView.xAxis.labelPosition = .bottom
            barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
            
            let linechartdataset=BarChartDataSet(values: dataEntries, label: "Questions")
            var datasets=[IChartDataSet]()
            datasets.append(linechartdataset)
            let linechartdata=BarChartData(dataSets: datasets)
            barChartView.data = linechartdata
   linechartdataset.colors = colors
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
