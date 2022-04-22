//
//  ChartMaker.swift
//  Team_India
//
//  Created by Josh Quaid on 4/20/22.
//  Written by Jordan Maples
//

import Foundation
import UIKit
import Charts

// The class for making charts
class ChartMaker {
    
    // Sets up the barChart and returns a built barChart
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
        
        // Animates the barChart in the yAxis direction
        barChart.animate(yAxisDuration: 2.5)
        
        
        return barChart
    }
    
    // Sets up a LineChart and returns the chart
    static func makeLineChart() -> LineChartView {
        let lineChart = LineChartView()
        
        // Set the background color
        lineChart.backgroundColor = .systemFill
        
        // Disable the rightAxis so there is no displaying of labels on the right side
        lineChart.rightAxis.enabled = false
        
        // Configure the yAxis settings for the lineChart
        let yAxis = lineChart.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 14)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .black
        yAxis.gridColor = .black
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 22
        
        // Configure the xAxis settings for the lineChart
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.labelFont = .boldSystemFont(ofSize: 14)
        lineChart.xAxis.setLabelCount(6, force: false)
        lineChart.xAxis.axisLineColor = .black
        lineChart.xAxis.gridColor = .black
        lineChart.xAxis.granularityEnabled = true
        lineChart.xAxis.granularity = 1
        
        // Animate the lineChart in the xAxis direction
        lineChart.animate(xAxisDuration: 2.5)
        
        
        // Static data entries as an example
        var entries = [ChartDataEntry]()
        
        for x in 0..<7 {
            entries.append(ChartDataEntry(x: Double(x),
                                             y: Double(x))
                           )
        }
        
        // Create a set of ChartDataEntries
        let set = LineChartDataSet(entries: entries, label: "Day")
        // Set the colors for the lineChart
        set.colors = ChartColorTemplates.material()

        // Create a LineChartData object
        let data = LineChartData(dataSet: set)
        // Set the lineChart data to data
        lineChart.data = data
        
        return lineChart
    }
}
