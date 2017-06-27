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

    @IBOutlet weak var pieChartView: PieChartView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let answer = ["True", "False"]
        let score = [10, 2]
        setChart(dataPoints: answer, values: score)
    }

    
    func setChart(dataPoints: [String], values: [Int]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
           let dataEntry1 = ChartDataEntry(x: Double(Int(i)), y: Double(values[i]), data: dataPoints[i] as AnyObject)
            

            dataEntries.append(dataEntry1)
        }
        print(dataEntries[0].data)
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Score")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)        }
        
        pieChartDataSet.colors = colors
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
}
