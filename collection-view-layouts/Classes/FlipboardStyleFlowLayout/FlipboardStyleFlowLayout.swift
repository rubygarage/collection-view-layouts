//
//  FlipboardStyleFlowLayout.swift
//  collection-view-layouts
//
//  Created by sergey on 4/4/18.
//

import UIKit

public class FlipboardStyleFlowLayout: ContentDynamicLayout {
    private let kColumnsCount: Int = 3
    private let kCellsInSection: Int = 8
    
    override public func calculateCollectionViewCellsFrames() {
        guard let contentCollectionView = collectionView, delegate != nil else {
            return
        }
        
        contentSize.width = contentCollectionView.frame.size.width

        var yOffset: CGFloat = 0
        
        let cellWidth = contentCollectionView.frame.size.width / CGFloat(kColumnsCount)
        let itemsCount = contentCollectionView.numberOfItems(inSection: 0)
        
        for item in 0 ..< itemsCount  {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            
            if indexPath.row % kCellsInSection == 0 {
                attributes.frame = CGRect(x: 0, y: yOffset, width: cellWidth * 2, height: cellWidth)
            } else if indexPath.row % kCellsInSection == 1 {
                attributes.frame = CGRect(x: cellWidth * 2, y: yOffset, width: cellWidth, height: cellWidth)
                
                yOffset += cellWidth
            } else if indexPath.row % kCellsInSection == 2 {
                attributes.frame = CGRect(x: 0, y: yOffset, width: cellWidth, height: cellWidth)
            } else if indexPath.row % kCellsInSection == 3 {
                attributes.frame = CGRect(x: cellWidth, y: yOffset, width: cellWidth, height: cellWidth)
            } else if indexPath.row % kCellsInSection == 4 {
                attributes.frame = CGRect(x: cellWidth * 2, y: yOffset, width: cellWidth, height: cellWidth)
                
                yOffset += cellWidth
            } else if indexPath.row % kCellsInSection == 5 {
                attributes.frame = CGRect(x: 0, y: yOffset, width: cellWidth, height: cellWidth)
            } else if indexPath.row % kCellsInSection == 6 {
                attributes.frame = CGRect(x: cellWidth, y: yOffset, width: cellWidth, height: cellWidth)
            } else if indexPath.row % kCellsInSection == 7 {
                attributes.frame = CGRect(x: cellWidth * 2, y: yOffset, width: cellWidth, height: cellWidth)
                
                yOffset += cellWidth
            }

            addCachedLayoutAttributes(attributes: attributes)
        }
        
        let addHeight = (itemsCount % 8 > 0) ? cellWidth : 0
        
        contentSize.height = yOffset + addHeight
    }
}
