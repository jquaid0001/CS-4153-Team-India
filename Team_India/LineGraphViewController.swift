//
//  LineGraphViewController.swift
//  Team_India
//
//  Created by Jordan Maples on 4/19/22.
//

import Charts
import UIKit

class LineGraphViewController: UIViewController, ChartViewDelegate {
    
    lazy var lineChart: LineChartView = {
        let chartView = LineChartView()
        
        chartView.backgroundColor = .systemFill
        
        chartView.rightAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 14)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .black
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 14)
        chartView.xAxis.setLabelCount(6, force: false)
        chartView.xAxis.axisLineColor = .systemFill
        
        chartView.animate(xAxisDuration: 2.5)
        
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lineChart.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        lineChart.frame = CGRect(x: 0, y: 0,
                                width: self.view.frame.size.width,
                               height: self.view.frame.size.width)
        lineChart.center = view.center
        view.addSubview(lineChart)
        
        
        
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

    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
}
