//
//  BaseView.swift
//  BaseDemo
//
//  Created by BASEBS on 8/20/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit

enum Option {
    case toggleValues
    case toggleIcons
    case toggleHighlight
    case animateX
    case animateY
    case animateXY
    case saveToGallery
    case togglePinchZoom
    case toggleAutoScaleMinMax
    case toggleData
    case toggleBarBorders
    // CandleChart
    case toggleShadowColorSameAsCandle
    case toggleShowCandleBar
    // CombinedChart
    case toggleLineValues
    case toggleBarValues
    case removeDataSet
    // CubicLineSampleFillFormatter
    case toggleFilled
    case toggleCircles
    case toggleCubic
    case toggleHorizontalCubic
    case toggleStepped
    // HalfPieChartController
    case toggleXValues
    case togglePercent
    case toggleHole
    case spin
    case drawCenter
    // RadarChart
    case toggleXLabels
    case toggleYLabels
    case toggleRotate
    case toggleHighlightCircle
    
    var label: String {
        switch self {
        case .toggleValues: return "Toggle Y-Values"
        case .toggleIcons: return "Toggle Icons"
        case .toggleHighlight: return "Toggle Highlight"
        case .animateX: return "Animate X"
        case .animateY: return "Animate Y"
        case .animateXY: return "Animate XY"
        case .saveToGallery: return "Save to Camera Roll"
        case .togglePinchZoom: return "Toggle PinchZoom"
        case .toggleAutoScaleMinMax: return "Toggle auto scale min/max"
        case .toggleData: return "Toggle Data"
        case .toggleBarBorders: return "Toggle Bar Borders"
        // CandleChart
        case .toggleShadowColorSameAsCandle: return "Toggle shadow same color"
        case .toggleShowCandleBar: return "Toggle show candle bar"
        // CombinedChart
        case .toggleLineValues: return "Toggle Line Values"
        case .toggleBarValues: return "Toggle Bar Values"
        case .removeDataSet: return "Remove Random Set"
        // CubicLineSampleFillFormatter
        case .toggleFilled: return "Toggle Filled"
        case .toggleCircles: return "Toggle Circles"
        case .toggleCubic: return "Toggle Cubic"
        case .toggleHorizontalCubic: return "Toggle Horizontal Cubic"
        case .toggleStepped: return "Toggle Stepped"
        // HalfPieChartController
        case .toggleXValues: return "Toggle X-Values"
        case .togglePercent: return "Toggle Percent"
        case .toggleHole: return "Toggle Hole"
        case .spin: return "Spin"
        case .drawCenter: return "Draw CenterText"
        // RadarChart
        case .toggleXLabels: return "Toggle X-Labels"
        case .toggleYLabels: return "Toggle Y-Labels"
        case .toggleRotate: return "Toggle Rotate"
        case .toggleHighlightCircle: return "Toggle highlight circle"
        }
    }
}

protocol ChartSubViews {
    func addBarChart()
    func addPieChart()
}

@objc protocol BaseViewOutput: class {
    func didAddNew(type: String)
    @objc optional func didAddPicklist(v: UIView?)
    @objc optional func onDetailView()
    @objc optional func onPopView()
}

class BaseView: UIView, ChartSubViews {
    // outlet
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var vTitle: CustomTitleView!
    
    //variable
    weak var controller: UIViewController?
    weak var delegateAddSubView: BaseViewOutput?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Logger.info(frame)
        commonInit()
        initBaseAbility()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func commonInit() {
        
    }

    func addBack() {
       
        let btnBack = UIButton()
        btnBack.setImage(UIImage(named: "back"), for: .normal)
        btnBack.addTarget(self, action:#selector(didBack) , for: .touchUpInside)
        btnBack.isUserInteractionEnabled = true
        btnBack.frame = CGRect(x: widthScreen - 50, y: heightScreen - heightTabbar - 70, width: 40, height: 40)
        
        addSubview(btnBack)
        
//        btnBack.translatesAutoresizingMaskIntoConstraints = false
//
//        let traillingConstraint = NSLayoutConstraint(item: btnBack, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 8)
//
//        let bottomConstraint = NSLayoutConstraint(item: btnBack, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 100)
//
//        let widthConstraint = NSLayoutConstraint(item: btnBack, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40)
//
//        let heightConstraint = NSLayoutConstraint(item: btnBack, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40)
//
//        addConstraints([traillingConstraint, bottomConstraint, widthConstraint, heightConstraint])
    }
    
//    func getPresenterView(title: String, isAddNew: Bool) -> PresenterView {
//        let presenter = PresenterView.xibInstance()
////        presenter.frame = CGRect(x: CGPoint.zero.x, y: CGPoint.zero.y, width: widthScreen, height: heightScreen)
//        presenter.frame = self.bounds
//        //header
//        if title.isEmpty {
//            presenter.vTitle.isHidden = true
//        } else {
//            presenter.vTitle.lblTitle.text = title
//        }
//        
//        presenter.hideAddNewBtn(on: !isAddNew)
//        
//        presenter.controller = controller
//        
//        return presenter
//    }
    
    @IBAction func didBack() {
        let topController = UIApplication.getTopViewController()
        topController?.navigationController?.popViewController(animated: true)
    }
    
    func addBarChart() {
        
    }
    
    func addPieChart() {
        
    }
    
    @objc func onDismissKeyboard() {
        self.endEditing(true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        Logger.info(self.frame)
    }
}

extension BaseView: BaseAbility {
    func initCommon() {
        
    }
    
    func initUIs() {
        
    }
    
    func initBinding() {
        
    }
    
    func initActions() {
        
    }
    
    
}
