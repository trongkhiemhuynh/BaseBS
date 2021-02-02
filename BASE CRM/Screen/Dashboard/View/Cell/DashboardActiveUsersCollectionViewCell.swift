//
//  DashboardActiveUsersCollectionViewCell.swift
//  BaseDemo
//
//  Created by macOS on 11/4/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit

class DashboardActiveUsersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iv1: UIImageView!
    @IBOutlet weak var iv2: UIImageView!
    @IBOutlet weak var iv3: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = corner12Radius
        self.clipsToBounds = true
        
        iv1.layer.cornerRadius = iv1.bounds.height/2
        iv2.layer.cornerRadius = iv2.bounds.height/2
        iv3.layer.cornerRadius = iv3.bounds.height/2
        
        downloadImage()
    }
    
    private func downloadImage() {
        TestManager.loadImage(imageView: iv1, urlString: "https://wallpapercave.com/wp/wp3183363.jpg", completion: {})
        TestManager.loadImage(imageView: iv2, urlString: "https://wallpaperaccess.com/full/1958133.jpg", completion: {})
        TestManager.loadImage(imageView: iv3, urlString: "https://images7.alphacoders.com/106/1067956.jpg", completion: {})
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        
//        iv1.image = UIImage(named: "no_image")
//        iv2.image = UIImage(named: "no_image")
//        iv3.image = UIImage(named: "no_image")
//    }

}

extension DashboardActiveUsersCollectionViewCell: XibInitalization {
    typealias Element = DashboardActiveUsersCollectionViewCell
}
