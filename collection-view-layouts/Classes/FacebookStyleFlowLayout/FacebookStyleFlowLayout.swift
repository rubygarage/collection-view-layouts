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
        
        var yOffset: CGFloat = contentPadding.vertical
        
        let largeCellWidth = (contentCollectionView.frame.size.width - 2 * contentPadding.horizontal - cellsPadding.horizontal) / CGFloat(kLargeColumnsCount)
        let smallCellWidth = (contentCollectionView.frame.size.width - 2 * (contentPadding.horizontal + cellsPadding.horizontal)) / CGFloat(kSmallColumnsCount)
        
        let sectionsCount = collectionView!.numberOfSections
        
        for section in 0..<sectionsCount {
            let itemsCount = contentCollectionView.numberOfItems(inSection: section)
            for item in 0 ..< itemsCount {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                if indexPath.row % kCellsInSection == 0 {
                    attributes.frame = CGRect(x: contentPadding.horizontal, y: yOffset, width: largeCellWidth, height: largeCellWidth)
                    yOffset = (indexPath.row + 1 == itemsCount) ? yOffset + largeCellWidth : yOffset
                } else if indexPath.row % kCellsInSection == 1 {
                    attributes.frame = CGRect(x: largeCellWidth + contentPadding.horizontal + cellsPadding.horizontal, y: yOffset, width: largeCellWidth, height: largeCellWidth)
                    yOffset += largeCellWidth + cellsPadding.vertical
                } else if indexPath.row % kCellsInSection == 2 {
                    attributes.frame = CGRect(x: contentPadding.horizontal, y: yOffset, width: smallCellWidth, height: smallCellWidth)
                    yOffset = (indexPath.row + 1 == itemsCount) ? yOffset + smallCellWidth : yOffset
                } else if indexPath.row % kCellsInSection == 3 {
                    attributes.frame = CGRect(x: smallCellWidth + cellsPadding.horizontal + contentPadding.horizontal, y: yOffset, width: smallCellWidth, height: smallCellWidth)
                    yOffset = (indexPath.row + 1 == itemsCount) ? yOffset + smallCellWidth : yOffset
                } else if indexPath.row % kCellsInSection == 4 {
                    attributes.frame = CGRect(x: (smallCellWidth + cellsPadding.horizontal) * 2 + contentPadding.horizontal, y: yOffset, width: smallCellWidth, height: smallCellWidth)
                    yOffset += smallCellWidth + cellsPadding.vertical
                }
                
                addCachedLayoutAttributes(attributes: attributes)
            }
        }
        
        contentSize.height = yOffset + contentPadding.vertical
    }
}
