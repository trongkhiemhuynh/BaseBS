//
//  CVAllConditionCollectionViewCell.swift
//  BASE CRM
//
//  Created by khiemht on 1/28/21.
//  Copyright © 2021 HTK Technologies. All rights reserved.
//

import UIKit

class CVAllConditionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var cv: UICollectionView!
    
    @IBAction func add() {
        count += 1
        cv.reloadData()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "CV_ALL_ADD"), object: nil)
    }
    
    @IBAction func delete() {
        
    }
    
    var count: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cv.registerCell(CVAddCollectionViewCell.self)
        cv.backgroundColor = .red
    }

}

extension CVAllConditionCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVAddCollectionViewCell.identifier, for: indexPath) as! CVAddCollectionViewCell
        cell.onDelete = {
            self.count -= 1
            self.cv.reloadData()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "CV_ALL_SUB"), object: nil)
        }
        return cell
    }
}

extension CVAllConditionCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cv.bounds.width, height: 200)
    }
}

extension CVAllConditionCollectionViewCell: XibInitalization {
    typealias Element = CVAllConditionCollectionViewCell
}
