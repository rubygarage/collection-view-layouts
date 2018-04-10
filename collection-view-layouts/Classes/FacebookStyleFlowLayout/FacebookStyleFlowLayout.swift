//
//  FacebookStyleFlowLayout.swift
//  collection-view-layouts
//
//  Created by sergey on 4/10/18.
//

import UIKit

public class FacebookStyleFlowLayout: ContentDynamicLayout {
    private let kCellsInSection: Int = 5
    private let kLargeColumnsCount: Int = 2
    private let kSmallColumnsCount: Int = 3
    
    override public func calculateCollectionViewCellsFrames() {
        guard let contentCollectionView = collectionView, delegate != nil else {
            return
        }
        
        contentSize.width = contentCollectionView.frame.size.width
        
        var yOffset: CGFloat = 0
        
        let largeCellWidth = contentCollectionView.frame.size.width / CGFloat(kLargeColumnsCount)
        let smallCellWidth = contentCollectionView.frame.size.width / CGFloat(kSmallColumnsCount)
        
        let itemsCount = contentCollectionView.numberOfItems(inSection: 0)
        
        for item in 0 ..< itemsCount  {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            if indexPath.row % kCellsInSection == 0 {
                attributes.frame = CGRect(x: 0, y: yOffset, width: largeCellWidth, height: largeCellWidth)
                yOffset = (indexPath.row + 1 == itemsCount) ? yOffset + largeCellWidth : yOffset
            } else if indexPath.row % kCellsInSection == 1 {
                attributes.frame = CGRect(x: largeCellWidth, y: yOffset, width: largeCellWidth, height: largeCellWidth)
                yOffset += largeCellWidth
            } else if indexPath.row % kCellsInSection == 2 {
                attributes.frame = CGRect(x: 0, y: yOffset, width: smallCellWidth, height: smallCellWidth)
                yOffset = (indexPath.row + 1 == itemsCount) ? yOffset + smallCellWidth : yOffset
            } else if indexPath.row % kCellsInSection == 3 {
                attributes.frame = CGRect(x: smallCellWidth, y: yOffset, width: smallCellWidth, height: smallCellWidth)
                yOffset = (indexPath.row + 1 == itemsCount) ? yOffset + smallCellWidth : yOffset
            } else if indexPath.row % kCellsInSection == 4 {
                attributes.frame = CGRect(x: smallCellWidth * 2, y: yOffset, width: smallCellWidth, height: smallCellWidth)
                yOffset += smallCellWidth
            }
            
            addCachedLayoutAttributes(attributes: attributes)
        }
        
        contentSize.height = yOffset
    }
}
