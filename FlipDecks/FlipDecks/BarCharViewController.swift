//
//  BarCharViewController.swift
//  FlipDecks
//
//  Created by admin on 22.06.17.
//  Copyright © 2017 Nicola Greth. All rights reserved.
//

import UIKit
import Charts


var answer: [String]!


class BarChartViewController: UIViewController {
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
         answer = ["Right", "False"]
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
        
        let linechartdataset=BarChartDataSet(values: dataEntries, label: "Questions")
        var datasets=[IChartDataSet]()
        datasets.append(linechartdataset)
        let linechartdata=BarChartData(dataSets: datasets)
        barChartView.data = linechartdata
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
