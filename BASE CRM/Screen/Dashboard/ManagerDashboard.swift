//
//  CustomDashLion.swift
//  BaseDemo
//
//  Created by macOS on 8/27/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit
import Charts

protocol DBSaleChart {
    func setupPieChartView(chartView : PieChartView)
    func setPieDataCount(_ items : Array<Double>)
}

class ManagerDashboard: BaseView {
    /// outlet
    @IBOutlet weak var vBarChart : UIView!
    @IBOutlet weak var vPieChart : UIView!
    @IBOutlet weak var vInfoUser : UIView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblJob: UILabel!
    
    @IBOutlet weak var iv:UIImageView!
    @IBOutlet weak var vWrapBarChart: UIView!
    
    var chartView : BarChartView!
    var chartPieView : PieChartView!
    
    override func awakeFromNib() {
        
        let loginObj = RealmManager.shared.onGetLoginObject() as? LoginObj
        
        lblName.text = loginObj?.name
        lblJob.text = loginObj?.tenant
        
        iv.layer.cornerRadius = iv.frame.size.width/2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapProfile(gesture:))))
        
        if let imgData = ApplicationManager.sharedInstance.getValueUserDefault(key: kAvatarImage) as? Data {
            iv.image = UIImage(data: imgData)
        }
    }
    
    @objc func didTapProfile(gesture : UITapGestureRecognizer) {
        //show profile view
//        let profileVC = ProfileViewController.xibInstance()
//        controller?.onPushController(profileVC)
    }
    
    private lazy var lblEmailCounts : UILabel = {
        let label = UILabel(frame: .zero)
        
        label.font = UIFont.boldSystemFont(ofSize: 12)
        
        label.textColor = .darkGray
        
        return label
    }()

    /// addBartChartView
    override func addBarChart() {
//        Logger.info(vBarChart.bounds)
        chartView = BarChartView(frame: vBarChart.bounds)
        chartView?.autoresizingMask = [.flexibleWidth, .flexibleHeight,.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        
        vBarChart.addSubview(chartView!)
        
        vWrapBarChart.addSubview(lblEmailCounts)
        lblEmailCounts.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: vWrapBarChart.frame.width, height: 30))
        
        setupBarChart(chartView : chartView)
    }
    
    /// addPieChartView
    override func addPieChart() {
        chartPieView = PieChartView(frame: vPieChart.bounds)
        chartPieView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        vPieChart.addSubview(chartPieView!)
        
        setupPieChartView(chartView: chartPieView)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
//    func setup(barLineChartView chartView: BarLineChartViewBase) {
//        chartView.chartDescription?.enabled = false
//
//        chartView.dragEnabled = true
//        chartView.setScaleEnabled(true)
//        chartView.pinchZoomEnabled = false
//
//        // ChartYAxis *leftAxis = chartView.leftAxis;
//
//        let xAxis = chartView.xAxis
//        xAxis.labelPosition = .bottom
//
//        chartView.rightAxis.enabled = false
//    }
    
    func setupBarChart(chartView : BarChartView) {
        
        chartView.chartDescription?.enabled = false
        chartView.maxVisibleCount = 7
        chartView.pinchZoomEnabled = false
        chartView.drawBarShadowEnabled = false
        chartView.pinchZoomEnabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = DayWeekAxisValueFormatter(chart: chartView)
                
        chartView.legend.enabled = false
        
        self.setDataCount()
        
        //////////////////////////////////////
        
    }
    
    /// BARCHART
    func setDataCount() {
        let items = [10,20,30,40,50,60,70]
        
        var emailCounts : Int = 0
        
        items.forEach { (val) in
            emailCounts += val
        }
        
        lblEmailCounts.text = "Number of emails: \(emailCounts)"
        
        let yVals = (0..<items.count).map { (i) -> BarChartDataEntry in

            let val = Double(items[i])//Double(arc4random_uniform(UInt32(mult))) + mult/3
            return BarChartDataEntry(x: Double(i), y: val)
        }
        
        var set1: BarChartDataSet! = nil
        if let set = chartView.data?.dataSets.first as? BarChartDataSet {
            set1 = set
            set1?.replaceEntries(yVals)
            chartView.data?.notifyDataChanged()
            chartView.notifyDataSetChanged()
        } else {
            set1 = BarChartDataSet(entries: yVals, label: "Data Set")
            set1.colors = ChartColorTemplates.vordiplom()
            set1.drawValuesEnabled = false
            
            let data = BarChartData(dataSet: set1)
            chartView.data = data
            chartView.fitBars = true
            
            Logger.info(set1)
        }
        
        chartView.setNeedsDisplay()
    }
}

extension ManagerDashboard : DBSaleChart {
    
    func setupPieChartView(chartView: PieChartView) {
        
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.3
        chartView.transparentCircleRadiusPercent = 0.61
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
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        
        
        // entry label styling
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = .systemFont(ofSize: 10, weight: .light)
        
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        
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
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
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

extension ManagerDashboard : XibInitalization {
    typealias Element = ManagerDashboard
}

class DayWeekAxisValueFormatter: NSObject, IAxisValueFormatter {
    weak var chart: BarLineChartViewBase?
    let date = ["MON","TUE","WED","THU","FRI","SAT","SUN"]
    
    init(chart: BarLineChartViewBase) {
        self.chart = chart
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return date[Int(value)]
    }
}
