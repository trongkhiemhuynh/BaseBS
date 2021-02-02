//
//  Common.swift
//  BaseDemo
//
//  Created by BASEBS on 8/20/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import UIKit
import Charts
import CoreGraphics

public enum MultipartFormDataEncodingError: Error {
    case characterSetName
    case name(String)
    case value(String, name: String)
}

enum TabMenu : Int {
    case dashboard = 0
    case profile
    case ticket
    case more
}

enum DashboardType: Int {
    case manager
    case sale
    case agent
}

enum AlertType: String {
    case error = "ERROR!"
    case success = "SUCCESS"
    case undefine = "UNDEFINE!"
}

enum ButtonView: String {
    case ok = "OK"
    case cancel = "CANCEL"
}

enum MagicViewType {
    case none
    case setting
    case profile
//    case account_detail
//    case contact
//    case contact_detail
    case extend
    case customer_journey
    case extend_notes
    case event
    case logcall
    case address_pager
    case auto
    case extend_task
    case extend_attach
    case extend_event
    case extend_comment
    case extend_chat
    case new_child
//    case account_list
//    case account_new
//    case contact_new
    case object_detail
    case object_list
    case object_new
    case report
}

//enum ExtendViews {
//    case notes
//    case tasks
//    case events
//    case historical_customer
//}

enum HamburgerMenu: String {
    case dashboard = "Dashboards"
    case account = "Account"
    case contact = "Contact"
    case ticket = "Ticket"
}

public extension Notification.Name {
//    static let TabbarName = Notification.Name("TabbarName")
//    static let StageName = Notification.Name("StageName")
//    static let ChangeSort = Notification.Name("ChangeSort")
//    static let UpdateSort = Notification.Name("UpdateSort")
//    static let DetailTicket = Notification.Name("DetailTicket")
    
    static let UPDATE_LIST = NSNotification.Name(rawValue: "UPDATED_LIST")
    static let CBA_END = NSNotification.Name(rawValue: "CBA_END_CALL")
    static let CBA_CALL = NSNotification.Name(rawValue: "CBA_CALL")
    static let CBA_CO_BROWSE = NSNotification.Name(rawValue: "CBA_CO_BROWSE")
    static let CBA_CODE = NSNotification.Name(rawValue: "CBA_CODE")
}

let arrInputTicket = ["Ticket owner", "Ticket ID", "Phone", "Mail", "Priority", "Status", "Subject","Escalated ?", "Done ?","Date Time opened","Date Time closed","Created by..., date time","Last modifined by..., date time","Description"]

let arrIcTicket = ["ticket_owner","ticket_id", "phone", "mail_ic", "priority", "status", "subject","escalated", "done","date","date","createdby","createdby","description","description","description"]

let arrMenuItems = ["Profile","Dashboards","Account","Contact","Ticket"]
let arrExtends = ["Notes","Tasks","Chat","Comments","Attachments","Event","Historical Activities"]
let arrAccountArrowDown = ["Industry","District","City","Country"]
let arrContactArrowDown = ["Department"]
let arrNewChildArrowDown = ["Contact name","Status"]

let kAvatarImage = "kAvatarImage"
let kTokenLoginUser = "kTokenLoginUser"

enum ItemMenu : Int {
    case none = 0, ticket = 1, dashboard, email, notes, activities, activities_history, articles, account, contact
    
    static subscript(n: Int) -> ItemMenu {
        return ItemMenu(rawValue: n)!
    }
}

let sectionInsetsDefault = UIEdgeInsets(top: 8.0,
                                        left: 8.0,
                                        bottom: 8.0,
                                        right: 8.0)
let paddingInsetsLarge = UIEdgeInsets(top: 16.0,
                                      left: 16.0,
                                      bottom: 16.0,
                                      right: 16.0)

let itemsPerRow: CGFloat = 1.0
let heightLargeCell: CGFloat = 70.0
let heightMediumCell: CGFloat = 60.0
let heightDefaultCell: CGFloat = 50.0
let height100Cell: CGFloat = 100.0
let paddingTop: CGFloat = 8.0

let corner8Radius: CGFloat = 8.0

let corner12Radius: CGFloat = 12.0

let heightHeaderProfile: CGFloat = 150.0

let heightHeaderDetailTicket: CGFloat = 120.0

let heightHeaderDefault: CGFloat = 8.0

var nameDevice: String? = {
    return UIDevice.current.name
}()

var uuidDevice: String = {
    return UUID().uuidString.lowercased()
}()

var versionApp: String = {
    let dictionary = Bundle.main.infoDictionary!
    let version = dictionary["CFBundleShortVersionString"] as! String
    let build = dictionary["CFBundleVersion"] as! String
    return "\(version).\(build)"
}()

public class DayAxisValueFormatter: NSObject, IAxisValueFormatter {
    weak var chart: BarLineChartViewBase?
    let months = ["Jan", "Feb", "Mar",
    "Apr", "May", "Jun",
    "Jul", "Aug", "Sep",
    "Oct", "Nov", "Dec"]
    
    init(chart: BarLineChartViewBase) {
        self.chart = chart
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {

        let days = Int(value)
        let year = determineYear(forDays: days)
        let month = determineMonth(forDayOfYear: days)

        let monthName = months[month % months.count]
        let yearName = "\(year)"

        if let chart = chart,
            chart.visibleXRange > 30 * 6 {
            return monthName + yearName
        } else {
            let dayOfMonth = determineDayOfMonth(forDays: days, month: month + 12 * (year - 2016))
            var appendix: String

            switch dayOfMonth {
            case 1, 21, 31: appendix = "st"
            case 2, 22: appendix = "nd"
            case 3, 23: appendix = "rd"
            default: appendix = "th"
            }

            return dayOfMonth == 0 ? "" : String(format: "%d\(appendix) \(monthName)", dayOfMonth)
        }
    }
    
    private func days(forMonth month: Int, year: Int) -> Int {
        // month is 0-based
        switch month {
        case 1:
            var is29Feb = false
            if year < 1582 {
                is29Feb = (year < 1 ? year + 1 : year) % 4 == 0
            } else if year > 1582 {
                is29Feb = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
            }
            
            return is29Feb ? 29 : 28
            
        case 3, 5, 8, 10:
            return 30
            
        default:
            return 31
        }
    }
    
    private func determineMonth(forDayOfYear dayOfYear: Int) -> Int {
        var month = -1
        var days = 0
        
        while days < dayOfYear {
            month += 1
            if month >= 12 {
                month = 0
            }
            
            let year = determineYear(forDays: days)
            days += self.days(forMonth: month, year: year)
        }
        
        return max(month, 0)
    }
    
    private func determineDayOfMonth(forDays days: Int, month: Int) -> Int {
        var count = 0
        var daysForMonth = 0
        
        while count < month {
            let year = determineYear(forDays: days)
            daysForMonth += self.days(forMonth: count % 12, year: year)
            count += 1
        }
        
        return days - daysForMonth
    }
    
    private func determineYear(forDays days: Int) -> Int {
        switch days {
        case ...366: return 2016
        case 367...730: return 2017
        case 731...1094: return 2018
        case 1095...1458: return 2019
        default: return 2020
        }
    }
}

class XYMarkerView: BalloonMarker {
    public var xAxisValueFormatter: IAxisValueFormatter
    fileprivate var yFormatter = NumberFormatter()
    
    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets,
                xAxisValueFormatter: IAxisValueFormatter) {
        self.xAxisValueFormatter = xAxisValueFormatter
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 1
        super.init(color: color, font: font, textColor: textColor, insets: insets)
    }
    
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let string = "x: "
            + xAxisValueFormatter.stringForValue(entry.x, axis: XAxis())
            + ", y: "
            + yFormatter.string(from: NSNumber(floatLiteral: entry.y))!
        
        setLabel(string)
    }
    
}

class BalloonMarker: MarkerImage
{
    @objc open var color: UIColor
    @objc open var arrowSize = CGSize(width: 15, height: 11)
    @objc open var font: UIFont
    @objc open var textColor: UIColor
    @objc open var insets: UIEdgeInsets
    @objc open var minimumSize = CGSize()
    
    fileprivate var label: String?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [NSAttributedString.Key : Any]()
    
    @objc public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets)
    {
        self.color = color
        self.font = font
        self.textColor = textColor
        self.insets = insets
        
        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
        super.init()
    }
    
    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
    {
        var offset = self.offset
        var size = self.size

        if size.width == 0.0 && image != nil
        {
            size.width = image!.size.width
        }
        if size.height == 0.0 && image != nil
        {
            size.height = image!.size.height
        }

        let width = size.width
        let height = size.height
        let padding: CGFloat = 8.0

        var origin = point
        origin.x -= width / 2
        origin.y -= height

        if origin.x + offset.x < 0.0
        {
            offset.x = -origin.x + padding
        }
        else if let chart = chartView,
            origin.x + width + offset.x > chart.bounds.size.width
        {
            offset.x = chart.bounds.size.width - origin.x - width - padding
        }

        if origin.y + offset.y < 0
        {
            offset.y = height + padding;
        }
        else if let chart = chartView,
            origin.y + height + offset.y > chart.bounds.size.height
        {
            offset.y = chart.bounds.size.height - origin.y - height - padding
        }

        return offset
    }
    
    open override func draw(context: CGContext, point: CGPoint)
    {
        guard let label = label else { return }
        
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size
        
        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height
        
        context.saveGState()

        context.setFillColor(color.cgColor)

        if offset.y > 0
        {
            context.beginPath()
            context.move(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + arrowSize.height))
            //arrow vertex
            context.addLine(to: CGPoint(
                x: point.x,
                y: point.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + rect.size.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + rect.size.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + arrowSize.height))
            context.fillPath()
        }
        else
        {
            context.beginPath()
            context.move(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + rect.size.width,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            //arrow vertex
            context.addLine(to: CGPoint(
                x: point.x,
                y: point.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y + rect.size.height - arrowSize.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x,
                y: rect.origin.y))
            context.fillPath()
        }
        
        if offset.y > 0 {
            rect.origin.y += self.insets.top + arrowSize.height
        } else {
            rect.origin.y += self.insets.top
        }

        rect.size.height -= self.insets.top + self.insets.bottom
        
        UIGraphicsPushContext(context)
        
        label.draw(in: rect, withAttributes: _drawAttributes)
        
        UIGraphicsPopContext()
        
        context.restoreGState()
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        setLabel(String(entry.y))
    }
    
    @objc open func setLabel(_ newLabel: String)
    {
        label = newLabel
        
        _drawAttributes.removeAll()
        _drawAttributes[.font] = self.font
        _drawAttributes[.paragraphStyle] = _paragraphStyle
        _drawAttributes[.foregroundColor] = self.textColor
        
        _labelSize = label?.size(withAttributes: _drawAttributes) ?? CGSize.zero
        
        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
}

//class BarChartDataSet: BarLineScatterCandleBubbleChartDataSet, IBarChartDataSet
//{
//    private func initialize()
//    {
//        self.highlightColor = NSUIColor.black
//
//        self.calcStackSize(entries: entries as! [BarChartDataEntry])
//        self.calcEntryCountIncludingStacks(entries: entries as! [BarChartDataEntry])
//    }
//
//    public required init()
//    {
//        super.init()
//        initialize()
//    }
//
//    public override init(entries: [ChartDataEntry]?, label: String?)
//    {
//        super.init(entries: entries, label: label)
//        initialize()
//    }
//
//    // MARK: - Data functions and accessors
//
//    /// the maximum number of bars that are stacked upon each other, this value
//    /// is calculated from the Entries that are added to the DataSet
//    private var _stackSize = 1
//
//    /// the overall entry count, including counting each stack-value individually
//    private var _entryCountStacks = 0
//
//    /// Calculates the total number of entries this DataSet represents, including
//    /// stacks. All values belonging to a stack are calculated separately.
//    private func calcEntryCountIncludingStacks(entries: [BarChartDataEntry])
//    {
//        _entryCountStacks = 0
//
//        for i in 0 ..< entries.count
//        {
//            if let vals = entries[i].yValues
//            {
//                _entryCountStacks += vals.count
//            }
//            else
//            {
//                _entryCountStacks += 1
//            }
//        }
//    }
//
//    /// calculates the maximum stacksize that occurs in the Entries array of this DataSet
//    private func calcStackSize(entries: [BarChartDataEntry])
//    {
//        for i in 0 ..< entries.count
//        {
//            if let vals = entries[i].yValues
//            {
//                if vals.count > _stackSize
//                {
//                    _stackSize = vals.count
//                }
//            }
//        }
//    }
//
//    open override func calcMinMax(entry e: ChartDataEntry)
//    {
//        guard let e = e as? BarChartDataEntry
//            else { return }
//
//        if !e.y.isNaN
//        {
//            if e.yValues == nil
//            {
//                if e.y < _yMin
//                {
//                    _yMin = e.y
//                }
//
//                if e.y > _yMax
//                {
//                    _yMax = e.y
//                }
//            }
//            else
//            {
//                if -e.negativeSum < _yMin
//                {
//                    _yMin = -e.negativeSum
//                }
//
//                if e.positiveSum > _yMax
//                {
//                    _yMax = e.positiveSum
//                }
//            }
//
//            calcMinMaxX(entry: e)
//        }
//    }
//
//    /// The maximum number of bars that can be stacked upon another in this DataSet.
//    open var stackSize: Int
//    {
//        return _stackSize
//    }
//
//    /// `true` if this DataSet is stacked (stacksize > 1) or not.
//    open var isStacked: Bool
//    {
//        return _stackSize > 1 ? true : false
//    }
//
//    /// The overall entry count, including counting each stack-value individually
//    @objc open var entryCountStacks: Int
//    {
//        return _entryCountStacks
//    }
//
//    /// array of labels used to describe the different values of the stacked bars
//    open var stackLabels: [String] = []
//
//    // MARK: - Styling functions and accessors
//
//    /// the color used for drawing the bar-shadows. The bar shadows is a surface behind the bar that indicates the maximum value
//    open var barShadowColor = NSUIColor(red: 215.0/255.0, green: 215.0/255.0, blue: 215.0/255.0, alpha: 1.0)
//
//    /// the width used for drawing borders around the bars. If borderWidth == 0, no border will be drawn.
//    open var barBorderWidth : CGFloat = 0.0
//
//    /// the color drawing borders around the bars.
//    open var barBorderColor = NSUIColor.black
//
//    /// the alpha value (transparency) that is used for drawing the highlight indicator bar. min = 0.0 (fully transparent), max = 1.0 (fully opaque)
//    open var highlightAlpha = CGFloat(120.0 / 255.0)
//
//    // MARK: - NSCopying
//
//    open override func copy(with zone: NSZone? = nil) -> Any
//    {
//        let copy = super.copy(with: zone) as! BarChartDataSet
//        copy._stackSize = _stackSize
//        copy._entryCountStacks = _entryCountStacks
//        copy.stackLabels = stackLabels
//
//        copy.barShadowColor = barShadowColor
//        copy.barBorderWidth = barBorderWidth
//        copy.barBorderColor = barBorderColor
//        copy.highlightAlpha = highlightAlpha
//        return copy
//    }
//}
