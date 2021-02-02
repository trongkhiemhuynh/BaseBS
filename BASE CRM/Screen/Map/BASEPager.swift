//
//  BASEPager.swift
//  BaseDemo
//
//  Created by macOS on 9/24/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import UIKit
import MapKit

protocol BASEPagerOutput: class {
    func onChangedAt(index: Int)
}

class BASEPager: BaseView {

    @IBOutlet weak var pagerControl: UIPageControl!
    
    //variable
    var arrLocation: Array<CLLocation>?
    weak var delegate: BASEPagerOutput?
    
    override func commonInit() {
        Bundle.main.loadNibNamed("BASEPager", owner: self, options: nil)
        addSubview(vContent) 
        vContent.frame = self.bounds
        vContent.backgroundColor = .clear
    }
    
    override func awakeFromNib() {
        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("layoutSubviews")
    }
    
    func setupView() {
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.scrollDirection = .horizontal
        
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.registerCell(AddressPagerCollectionViewCell.self)
        pagerControl.numberOfPages = arrLocation!.count
        pagerControl.currentPage = 0
        
        collectionView.reloadData()
    }
}

extension BASEPager: BaseViewOutput {
    func didAddNew(type: String) {
        self.delegateAddSubView?.didAddNew(type: "pager")
    }
}

extension BASEPager: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrLocation?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddressPagerCollectionViewCell.identifier, for: indexPath) as! AddressPagerCollectionViewCell
        
        cell.onUpdate(indexPath.row)
        
        
        return cell
    }

}

extension BASEPager: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()

        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return}
        //update map
        delegate?.onChangedAt(index: indexPath.row)
//        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        pagerControl.currentPage = indexPath.row
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        var visibleR = CGRect()
        
//        visibleR.origin = collectionView.contentOffset
//        visibleR.size = collectionView.bounds.size
//        
//        let percentItem =  visibleR.origin.x / visibleR.size.width
//        
//        if percentItem > 0.5 {
//            collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .bottom, animated: true)
//        }
    }
}

extension BASEPager: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.width - 30, height: self.collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return paddingInsetsLarge.left
    }
}
