//
//  ChartMaker.swift
//  Team_India
//
//  Created by Josh Quaid on 4/20/22.
//

import Foundation
import UIKit
import Charts

class ChartMaker {
    
    
    static func makeBarChart() -> BarChartView {
        // Create bar chart
        let barChart = BarChartView()
        
        let days = ["Sun", "Mon", "Tues", "Wed", "Thu", "Fri", "Sat"]
        
        barChart.dragEnabled = true
        barChart.backgroundColor = .systemFill
        
        // Configure the X axis
        let xAxis = barChart.xAxis
        xAxis.axisLineColor = .white
        xAxis.axisLineWidth = 2
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .boldSystemFont(ofSize: 14)
        xAxis.labelTextColor = .black
        xAxis.gridColor = .black
        xAxis.granularityEnabled = true
        xAxis.valueFormatter = IndexAxisValueFormatter(values:days)
        xAxis.granularity = 1
        
        // Configure the Y Axis
        let yAxis = barChart.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 14)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .black
        yAxis.gridColor = .black
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
        
        barChart.animate(xAxisDuration: 2.5)
        
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
        
        
        return barChart
    }
    
    static func makeLineChart() -> LineChartView {
        let lineChart = LineChartView()
        
        lineChart.backgroundColor = .systemFill
        
        lineChart.rightAxis.enabled = false
        
        let yAxis = lineChart.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 14)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .black
        yAxis.gridColor = .black
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 12
        
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.labelFont = .boldSystemFont(ofSize: 14)
        lineChart.xAxis.setLabelCount(6, force: false)
        lineChart.xAxis.axisLineColor = .black
        lineChart.xAxis.gridColor = .black
        
        lineChart.animate(xAxisDuration: 2.5)
        
        var entries = [ChartDataEntry]()
        
        for x in 0..<7 {
            entries.append(ChartDataEntry(x: Double(x),
                                             y: Double(x))
                           )
        }
        
        let set = LineChartDataSet(entries: entries, label: "Day")
        set.colors = ChartColorTemplates.material()

        let data = LineChartData(dataSet: set)
        lineChart.data = data
        
        return lineChart
    }
}
