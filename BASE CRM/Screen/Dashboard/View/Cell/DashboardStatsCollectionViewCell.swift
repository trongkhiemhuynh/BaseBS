//
//  DashboardStatsCollectionViewCell.swift
//  BaseDemo
//
//  Created by macOS on 10/19/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit
import Charts

class DashboardStatsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var vBarChart : UIView!
    var chartView: BarChartView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addBarChart()
    }

    override func layoutSubviews() {
        self.layer.cornerRadius = 12.0
        self.clipsToBounds = true
        Logger.info(self.bounds)
    }
    
    func addBarChart() {
    //        Logger.info(vBarChart.bounds)
            chartView = BarChartView(frame: vBarChart.bounds)
            chartView?.autoresizingMask = [.flexibleWidth, .flexibleHeight,.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
            
            vBarChart.addSubview(chartView!)
            
//            vWrapBarChart.addSubview(lblEmailCounts)
//            lblEmailCounts.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: vWrapBarChart.frame.width, height: 30))
            
            setupBarChart(chartView: chartView)
        }
    
    func setupBarChart(chartView : BarChartView) {
        
        chartView.chartDescription?.enabled = false
        chartView.maxVisibleCount = 12
        chartView.pinchZoomEnabled = false
        chartView.drawBarShadowEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = DayWeekAxisValueFormatter(chart: chartView)
                
        chartView.legend.enabled = false
        
        self.setDataCount()
        
    }
    
    // BARCHART
    func setDataCount() {
        let items = [10,20,30,40,50,60,70]
        
        var emailCounts : Int = 0
        
        items.forEach { (val) in
            emailCounts += val
        }
        
//        lblEmailCounts.text = "Number of emails: \(emailCounts)"
        
        let yVals = (0..<items.count).map { (i) -> BarChartDataEntry in

            let val = Double(items[i])//Double(arc4random_uniform(UInt32(mult))) + mult/3
            return BarChartDataEntry(x: Double(i), y: val)
        }
    
        var set1: BarChartDataSet!
        
//        if let set = chartView.data?.dataSets.first as? BarChartDataSet {
//            set1 = set
//            set1?.replaceEntries(yVals)
//            chartView.data?.notifyDataChanged()
//            chartView.notifyDataSetChanged()
//        } else {
            set1 = BarChartDataSet(entries: yVals, label: "Data Set")
            set1.colors = ChartColorTemplates.liberty()
            set1.drawValuesEnabled = false
            
            let data = BarChartData(dataSet: set1)
            chartView.data = data
            chartView.fitBars = true
//        }
        
        chartView.setNeedsDisplay()
    }
}

extension DashboardStatsCollectionViewCell: XibInitalization {
    typealias Element = DashboardStatsCollectionViewCell
}
