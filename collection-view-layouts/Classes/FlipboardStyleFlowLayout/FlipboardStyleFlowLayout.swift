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
        
        var yOffset: CGFloat = contentPadding.vertical
        
        let cellWidth = (contentCollectionView.frame.size.width - 2 * (contentPadding.horizontal + cellsPadding.horizontal)) / CGFloat(kColumnsCount)
        
        let sectionsCount = collectionView!.numberOfSections
        
        for section in 0..<sectionsCount {
            let itemsCount = contentCollectionView.numberOfItems(inSection: section)
            for item in 0 ..< itemsCount {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                if indexPath.row % kCellsInSection == 0 {
                    let x = (contentAlign == .left) ? contentPadding.horizontal : (cellWidth + cellsPadding.horizontal + contentPadding.horizontal)
                    attributes.frame = CGRect(x: x, y: yOffset, width: cellWidth * 2 + cellsPadding.horizontal, height: cellWidth)
                    
                    yOffset = (indexPath.row + 1 == itemsCount) ? yOffset + cellWidth : yOffset
                } else if indexPath.row % kCellsInSection == 1 {
                    let x = (contentAlign == .left) ? (cellWidth + cellsPadding.horizontal) * 2 + contentPadding.horizontal : contentPadding.horizontal
                    attributes.frame = CGRect(x: x, y: yOffset, width: cellWidth, height: cellWidth)
                    
                    yOffset += cellWidth + cellsPadding.vertical
                } else if indexPath.row % kCellsInSection == 2 {
                    attributes.frame = CGRect(x: contentPadding.horizontal, y: yOffset, width: cellWidth, height: cellWidth)
                    yOffset = (indexPath.row + 1 == itemsCount) ? yOffset + cellWidth : yOffset
                } else if indexPath.row % kCellsInSection == 3 {
                    attributes.frame = CGRect(x: (cellWidth + cellsPadding.horizontal) + contentPadding.horizontal, y: yOffset, width: cellWidth, height: cellWidth)
                    yOffset = (indexPath.row + 1 == itemsCount) ? yOffset + cellWidth : yOffset
                } else if indexPath.row % kCellsInSection == 4 {
                    attributes.frame = CGRect(x: (cellWidth + cellsPadding.horizontal) * 2 + contentPadding.horizontal, y: yOffset, width: cellWidth, height: cellWidth)
                    
                    yOffset += cellWidth + cellsPadding.vertical
                } else if indexPath.row % kCellsInSection == 5 {
                    attributes.frame = CGRect(x: contentPadding.horizontal, y: yOffset, width: cellWidth, height: cellWidth)
                    yOffset = (indexPath.row + 1 == itemsCount) ? yOffset + cellWidth : yOffset
                } else if indexPath.row % kCellsInSection == 6 {
                    attributes.frame = CGRect(x: (cellWidth + cellsPadding.horizontal) + contentPadding.horizontal, y: yOffset, width: cellWidth, height: cellWidth)
                    yOffset = (indexPath.row + 1 == itemsCount) ? yOffset + cellWidth : yOffset
                } else if indexPath.row % kCellsInSection == 7 {
                    attributes.frame = CGRect(x: (cellWidth + cellsPadding.horizontal) * 2 + contentPadding.horizontal, y: yOffset, width: cellWidth, height: cellWidth)
                    
                    yOffset += cellWidth + cellsPadding.vertical
                }
                
                addCachedLayoutAttributes(attributes: attributes)
            }
        }
        
        contentSize.height = yOffset + contentPadding.vertical
    }
}
