//
//  CalendarView.swift
//  BaseDemo
//
//  Created by macOS on 9/1/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarView: UIView {

    @IBOutlet weak var fsCalendar : FSCalendar!
    
    
    @IBAction func close() {
        
    }
    
    override func awakeFromNib() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKb))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        
    }
    
    @objc func dismissKb() {
        self.removeFromSuperview()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension CalendarView: XibInitalization {
    typealias Element = CalendarView
}

extension CalendarView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let v = touch.view {
            if v.isDescendant(of: fsCalendar) {
                return false
            }
        }
        
        return true
    }
}
