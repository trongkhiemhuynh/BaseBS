//
//  DashboardTrafficCollectionViewCell.swift
//  BaseDemo
//
//  Created by macOS on 10/19/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit
import Charts

class DashboardTrafficCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var vPieChart: UIView!
    var chartPieView : PieChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 12.0
        self.clipsToBounds = true
        
        addPieChart()
    }
    
    func addPieChart() {
        chartPieView = PieChartView(frame: vPieChart.bounds)
        chartPieView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        vPieChart.addSubview(chartPieView!)
        
        setupPieChartView(chartView: chartPieView)
    }

    func setupPieChartView(chartView: PieChartView) {
        
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.0
        chartView.transparentCircleRadiusPercent = 0.0
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
        
        chartView.drawCenterTextEnabled = true
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let items = [254.82, 112.28, 3095.13, 482.88, 1444.96]
        
        var saleCounts: Double = 0
        
        items.forEach { (val) in
            saleCounts += val
        }
        
        let centerText = NSMutableAttributedString(string: "\(saleCounts) stocks")
        
        centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 7)!,
                                  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        
        chartView.centerAttributedText = centerText;
        
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        chartView.legend.enabled = false
        
        
        // entry label styling
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = .systemFont(ofSize: 10, weight: .light)
        
//        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        
        setPieDataCount(items)
    }
    
    func setPieDataCount(_ items : Array<Double>) {
            let company = ["Facebook","Apple","Amazon","Netflix","Google"]
            
            let entries = (0..<items.count).map { (i) -> PieChartDataEntry in
                // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
                return PieChartDataEntry(value: Double(items[i]),
                                         label: company[i],
                                         icon: nil)
            }
            
            let set = PieChartDataSet(entries: entries)
            set.drawIconsEnabled = false
            set.sliceSpace = 1
            
            set.colors = ChartColorTemplates.liberty()
//        ChartColorTemplates.vordiplom()
//                + ChartColorTemplates.joyful()
//                + ChartColorTemplates.colorful()
//                + ChartColorTemplates.liberty()
//                + ChartColorTemplates.pastel()
//                + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
            
            let data = PieChartData(dataSet: set)
            
            let pFormatter = NumberFormatter()
            pFormatter.numberStyle = .percent
            pFormatter.maximumFractionDigits = 1
            pFormatter.multiplier = 1
            pFormatter.percentSymbol = " %"
            data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
            
            data.setValueFont(.systemFont(ofSize: 11, weight: .light))
            data.setValueTextColor(.white)
            
            chartPieView.data = data
            
            chartPieView.setNeedsDisplay()
    //        chartView.highlightValues(nil)
        }
}

extension DashboardTrafficCollectionViewCell: XibInitalization {
    typealias Element = DashboardTrafficCollectionViewCell
}
