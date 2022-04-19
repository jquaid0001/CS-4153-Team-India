//
//  ThirdGraphViewController.swift
//  Team_India
//
//  Created by Jordan Maples on 4/19/22.
//

import Charts
import UIKit

class ThirdViewController: UIViewController, ChartViewDelegate {

    var pieChart = PieChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pieChart.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pieChart.frame = CGRect(x: 0, y: 0,
                                width: self.view.frame.size.width,
                               height: self.view.frame.size.width)
        pieChart.center = view.center
        view.addSubview(pieChart)
        
        var entries = [ChartDataEntry]()
        
        for x in 0..<10 {
            entries.append(ChartDataEntry(x: Double(x),
                                             y: Double(x))
                           )
        }
        
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.pastel()
        

        let data = PieChartData(dataSet: set)
        pieChart.data = data

    }
    

 

}
