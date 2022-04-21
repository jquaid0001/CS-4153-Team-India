//
//  LineGraphViewController.swift
//  Team_India
//
//  Created by Jordan Maples on 4/19/22.
//

import Charts
import UIKit

class LineGraphViewController: UIViewController, ChartViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createLineChart()
        
    }
    
    private func createLineChart() {
        // Create line chart
        let lineChart = LineChartView(frame: CGRect(x: 0, y: 0,
                                    width: self.view.frame.size.width,
                                    height: self.view.frame.size.width))
        let days = ["Sun", "Mon", "Tues", "Wed", "Thu", "Fri", "Sat"]
        
        lineChart.dragEnabled = true
        lineChart.backgroundColor = .systemFill
        
        // Configure the Y Axis
        let yAxis = lineChart.leftAxis
        
        yAxis.labelFont = .boldSystemFont(ofSize: 14)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.gridColor = .white
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 12
        
        // Configure the X Axis
        let xAxis = lineChart.xAxis
        
        xAxis.axisLineColor = .white
        xAxis.axisLineWidth = 2
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .boldSystemFont(ofSize: 14)
        xAxis.labelTextColor = .white
        xAxis.gridColor = .white
        xAxis.granularityEnabled = true
        xAxis.valueFormatter = IndexAxisValueFormatter(values:days)
        xAxis.granularity = 1
        
        let l = lineChart.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .vertical
        l.drawInside = false
        l.form = .line
        l.formSize = 9
        l.font = UIFont(name: "HelveticaNeue-Light", size: 12)!
        l.xEntrySpace = 6
        
        lineChart.animate(xAxisDuration: 2.5)
        
        // Supply data
        var lineEntries = [ChartDataEntry]()

        for x in 0..<7 {
            lineEntries.append(ChartDataEntry(x: Double(x),
                                              y: Double.random(in: 0...12))
                           )
        }
        // Assign Data points to locations on the graph yAxis
        let set = LineChartDataSet(entries: lineEntries, label: "Session 1")
        set.colors = ChartColorTemplates.material()

        let data = LineChartData(dataSet: set)
        lineChart.data = data
        
        view.addSubview(lineChart)
        lineChart.rightAxis.enabled = false
        lineChart.center = view.center
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            print(entry)
        }
}
//    lazy var lineChart: LineChartView = {
//        let chartView = LineChartView()
//
//        chartView.backgroundColor = .systemFill
//
//        chartView.rightAxis.enabled = false
//
//        let yAxis = chartView.leftAxis
//        yAxis.labelFont = .boldSystemFont(ofSize: 14)
//        yAxis.setLabelCount(6, force: false)
//        yAxis.labelTextColor = .black
//
//        chartView.xAxis.labelPosition = .bottom
//        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 14)
//        chartView.xAxis.setLabelCount(6, force: false)
//        chartView.xAxis.axisLineColor = .systemFill
//
//        chartView.animate(xAxisDuration: 2.5)
//
//        return chartView
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        lineChart.delegate = self
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        lineChart.frame = CGRect(x: 0, y: 0,
//                                width: self.view.frame.size.width,
//                               height: self.view.frame.size.width)
//        lineChart.center = view.center
//        view.addSubview(lineChart)
//
//
//
//        var entries = [ChartDataEntry]()
//
//        for x in 0..<7 {
//            entries.append(ChartDataEntry(x: Double(x),
//                                             y: Double(x))
//                           )
//        }
//
//        let set = LineChartDataSet(entries: entries, label: "Day")
//        set.colors = ChartColorTemplates.material()
//
//        let data = LineChartData(dataSet: set)
//        lineChart.data = data
//
//    }
//
//    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//        print(entry)
//    }
//}
