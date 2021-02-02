//
//  DashboardLayout.swift
//  BaseDemo
//
//  Created by macOS on 10/19/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import UIKit

protocol DashboardLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGSize
}

//FIXME Custom CollectionView Layout
class DashboardLayout: UICollectionViewLayout {
    
    //properties
    private let oneColumns = 1
    private let twoColums = 2
    private let cellPadding: CGFloat = 8
    public var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let cv = collectionView else {
            return 0
        }
        
        let insets = cv.contentInset
        
        return cv.bounds.width - insets.left - insets.right
    }
    
    weak var delegate: DashboardLayoutDelegate?
    
    override func prepare() {
        //1
        guard cache.isEmpty, let cv = collectionView else {
            return
        }
        
        // 2
//        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: CGFloat = 0.0
        
//        for column in 0..< numberOfColumns {
//          xOffset.append(CGFloat(column) * columnWidth)
//        }
        
        var yOffset: CGFloat = 0.0
        
        // 3
        for item in 0 ..< cv.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            // 4
            let itemSize = delegate?.collectionView(
                cv,
                heightForPhotoAtIndexPath: indexPath) ?? CGSize(width: widthScreen - cellPadding*2 , height: 120.0)
            
            let height = cellPadding*2 + itemSize.height
            let width = cellPadding*2 + itemSize.width
            
            //frame for item
            let frame = CGRect(x: xOffset,
                               y: yOffset,
                               width: width,
                               height: height)
            
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // 5
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // 6
            contentHeight = max(contentHeight, frame.maxY)
            
            if frame.width > widthScreen/2 || frame.origin.x >= widthScreen/2 {
                xOffset = 0.0
                yOffset = yOffset + frame.height
            } else {
                xOffset = frame.width
            }
            
            Logger.info("\(xOffset) khiemht \(yOffset)")
            
            //          yOffset[column] = yOffset[column] + height
            
            //          column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
        
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
