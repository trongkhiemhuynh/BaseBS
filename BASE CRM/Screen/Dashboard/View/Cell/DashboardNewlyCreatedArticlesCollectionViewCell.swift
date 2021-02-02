//
//  DashboardNewlyCreatedArticlesCollectionViewCell.swift
//  BaseDemo
//
//  Created by macOS on 11/4/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit

class DashboardNewlyCreatedArticlesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tbv: UITableView!
    
    let arrDummyData = ["Call event", "Agent support"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = corner12Radius
        self.clipsToBounds = true
        
        tbv.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
}

extension DashboardNewlyCreatedArticlesCollectionViewCell: XibInitalization {
    typealias Element = DashboardNewlyCreatedArticlesCollectionViewCell
}

extension DashboardNewlyCreatedArticlesCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDummyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = arrDummyData[indexPath.row]
        
        return cell
    }
}
