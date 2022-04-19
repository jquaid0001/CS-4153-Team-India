//
//  BarGraphViewController.swift
//  Team_India
//
//  Created by Jordan Maples on 4/19/22.
//

import Charts // Import dependancy
import UIKit

class ViewController: UIViewController, ChartViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        createChart()
    }
    
    private func createChart() {
        // Create bar chart
        let barChart = BarChartView(frame: CGRect(x: 0, y: 0,
            width: view.frame.size.width,
            height: view.frame.size.width))
        
        let days = ["Sun", "Mon", "Tues", "Wed", "Thu", "Fri", "Sat"]
        
        barChart.dragEnabled = true
        barChart.backgroundColor = .systemFill
        
        // Configure the X axis
        let xAxis = barChart.xAxis
        xAxis.axisLineColor = .white
        xAxis.axisLineWidth = 2
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .boldSystemFont(ofSize: 14)
        xAxis.labelTextColor = .white
        xAxis.gridColor = .white
        xAxis.granularityEnabled = true
        xAxis.valueFormatter = IndexAxisValueFormatter(values:days)
        xAxis.granularity = 1
        
        // Configure the Y Axis
        let yAxis = barChart.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 14)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.gridColor = .white
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 12
      
        // Configure legend
        let l = barChart.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .vertical
        l.drawInside = false
        l.form = .line
        l.formSize = 9
        l.font = UIFont(name: "HelveticaNeue-Light", size: 12)!
        l.xEntrySpace = 6
        
        barChart.animate(xAxisDuration: 3.0)
        
        // Supply data
        var entries = [BarChartDataEntry]()
        var entries2 = [BarChartDataEntry]()
        
        // **FIXME** The method in which to pull data; here are two dataSets atm
        // Format [(date:String, time:(hours:Int, minutes: Int, seconds:Int ))]
        for x in 0..<7 {
            entries.append(BarChartDataEntry(x: Double(x), y: Double.random(in: 4...6)))
            entries2.append(BarChartDataEntry(x: Double(x), y: Double.random(in: 0...3)))
        }
       
        
        // Data set build
        let set = BarChartDataSet(entries: entries, label: "Session 1")
        let set2 = BarChartDataSet(entries: entries2, label: "Session 2")
        
        
        set.setColor(UIColor(red: 0.0, green: 0.42, blue: 0.46, alpha: 1.0))  // **FIXME**
        set2.setColor(UIColor(red: 0.75, green: 0.85, blue: 0.86, alpha: 1.0))
        
        let data = BarChartData(dataSets: [set, set2])
        barChart.data = data
        
        view.addSubview(barChart)
        barChart.rightAxis.enabled = false
        barChart.center = view.center
    }
}

