//
//  NewCustomViewController.swift
//  BASE CRM
//
//  Created by khiemht on 1/28/21.
//  Copyright © 2021 HTK Technologies. All rights reserved.
//

import UIKit

class NewCustomViewController: UIViewController {

    @IBOutlet weak var cv: UICollectionView!
    
    var heightAll:CGFloat = 50
    let heightAdd:CGFloat = 200
    
    var cAll = 2
    var cAny = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        // Do any additional setup after loading the view.
        register()
    
    }
    
    func register() {
//        cv.registerCell(CVViewNameCollectionViewCell.self)
//        cv.registerCell(CVIsDefaultCollectionViewCell.self)
//        cv.registerCell(CVAllConditionCollectionViewCell.self)
        
//        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "CV_ALL_ADD"), object: nil, queue: nil) { (notification) in
//            self.heightAll += self.heightAdd
//            self.cv.reloadData()
//        }
//
//        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "CV_ALL_SUB"), object: nil, queue: nil) { (notification) in
//            self.heightAll -= self.heightAdd
//            self.cv.reloadData()
//        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewCustomViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVViewNameCollectionViewCell.identifier, for: indexPath)
            
            return cell
        }
        
        if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVIsDefaultCollectionViewCell.identifier, for: indexPath)
            
            return cell
        }
        
//        if indexPath.row == 2 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVAllConditionCollectionViewCell.identifier, for: indexPath)
//
//            return cell
//        }

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVAllConditionCollectionViewCell.identifier, for: indexPath)
            
            return cell
        
    }
}

extension NewCustomViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("debug")
        print(indexPath.row)
        
        if indexPath.row == 2 {
            return CGSize(width: self.cv.bounds.width, height: heightAll)
        }
        
        return CGSize(width: self.cv.bounds.width, height: 70)
    }
}

extension NewCustomViewController {
    @IBAction func save() {
        cv.reloadData()
    }
}
