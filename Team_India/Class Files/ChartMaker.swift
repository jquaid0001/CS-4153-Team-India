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
        
        //let days = ["Sun", "Mon", "Tues", "Wed", "Thu", "Fri", "Sat"]
        
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
        //xAxis.valueFormatter = IndexAxisValueFormatter(values:days)
        xAxis.granularity = 1
        
        // Configure the Y Axis
        let yAxis = barChart.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 14)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .black
        yAxis.gridColor = .black
        yAxis.axisMinimum = 0
      
        // Configure legend
        let l = barChart.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .line
        l.formSize = 9
        l.font = UIFont(name: "HelveticaNeue-Light", size: 12)!
        l.xEntrySpace = 6
        
        barChart.animate(yAxisDuration: 2.5)
        
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
