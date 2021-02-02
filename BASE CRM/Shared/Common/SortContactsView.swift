//
//  SortContactsView.swift
//  BaseDemo
//
//  Created by macOS on 9/9/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit

protocol SortContactsViewOutput: class {
    func didSelect(item : String?)
}

class SortContactsView: UIView {
    
    @IBOutlet weak var tv : UITableView!
    
    // delegate
    weak var delegate : SortContactsViewOutput?
    
    // varible
    var dummyData : [String] = ["Last activity","First name","Last name","Contact owner","Create date","Lead status","Last contacted"]
    var selectedIdx : IndexPath?
    var selectedItemName : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tv.register(SortContactsViewCell.self)
    }
    
    @IBAction func didBack() {
        removeFromSuperview()
    }
}

extension SortContactsView : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SortContactsViewCell.identifier, for: indexPath) as! SortContactsViewCell
        
        let sortType = dummyData[indexPath.row]
        
        cell.lbl.text = sortType
        
        //check icon right
        if let sName = selectedItemName {
            if sName == sortType {
                cell.iv.isHidden = false
                selectedIdx = indexPath
            } else {
                cell.iv.isHidden = true
            }
        } else {
            cell.iv.isHidden = true
        }
        
        return cell
    }
}

extension SortContactsView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //update row
        let cell = tableView.cellForRow(at: indexPath) as! SortContactsViewCell
        selectedItemName = cell.lbl.text
        
        guard let sIndexPath = selectedIdx else {return}
        
        tableView.reloadRows(at: [indexPath, sIndexPath], with: .fade)
        
        delegate?.didSelect(item: selectedItemName)
        
        //remove from superview
        didBack()
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath) as! SortContactsViewCell
        cell.iv.isHidden = true
        
        return indexPath
    }
}

extension SortContactsView : XibInitalization {
    typealias Element = SortContactsView
}
