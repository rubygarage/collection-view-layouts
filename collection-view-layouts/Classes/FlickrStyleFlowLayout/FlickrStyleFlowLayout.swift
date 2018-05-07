//
//  FlickrStyleFlowLayout.swift
//  collection-view-layouts
//
//  Created by sergey on 4/11/18.
//

import UIKit

public class FlickrStyleFlowLayout: ContentDynamicLayout {
    private let kCellsInSection: Int = 4
    private let kRowsCount: Int = 5
    private let kColumnsCount: Int = 2
    
    override public func calculateCollectionViewCellsFrames() {
        guard let contentCollectionView = collectionView, delegate != nil else {
            return
        }
        
        contentSize.width = contentCollectionView.frame.size.width
        
        var yOffset: CGFloat = contentPadding.vertical
        
        let sectionsCount = collectionView!.numberOfSections
        
        for section in 0..<sectionsCount {
            let itemsCount = contentCollectionView.numberOfItems(inSection: section)

            for item in 0 ..< itemsCount {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                let smallCellHeight: CGFloat = (contentCollectionView.frame.height - 2 * contentPadding.vertical - cellsPadding.vertical) / CGFloat(kRowsCount)
                let largeCellHeight: CGFloat = smallCellHeight * 2 + cellsPadding.vertical
                let cellWidth = (contentCollectionView.frame.width - 2 * contentPadding.horizontal - cellsPadding.horizontal) / 2
                let addCellHeight = (contentCollectionView.frame.height - 2 * contentPadding.vertical - cellsPadding.vertical) / CGFloat(kRowsCount - 1)
                let addCellWidth = contentCollectionView.frame.width - 2 * contentPadding.horizontal
                
                if indexPath.row % kCellsInSection == 0 {
                    attributes.frame = CGRect(x: contentPadding.horizontal, y: yOffset, width: cellWidth, height: smallCellHeight)
                    yOffset = (indexPath.row + 1 == itemsCount) ? yOffset + smallCellHeight : yOffset
                    yOffset += cellsPadding.vertical
                } else if indexPath.row % kCellsInSection == 1 {
                    yOffset -= cellsPadding.vertical
                    attributes.frame = CGRect(x: cellWidth + contentPadding.horizontal + cellsPadding.horizontal, y: yOffset, width: cellWidth, height: largeCellHeight)
                    yOffset = (indexPath.row + 1 == itemsCount) ? yOffset + largeCellHeight : yOffset + smallCellHeight
                    yOffset += cellsPadding.vertical
                } else if indexPath.row % kCellsInSection == 2 {
                    attributes.frame = CGRect(x: contentPadding.horizontal, y: yOffset, width: cellWidth, height: smallCellHeight)
                    yOffset += smallCellHeight + cellsPadding.vertical
                } else if indexPath.row % kCellsInSection == 3 {
                    attributes.frame = CGRect(x: contentPadding.horizontal, y: yOffset, width: addCellWidth, height: addCellHeight)
                    yOffset += addCellHeight + cellsPadding.vertical
                }
                
                addCachedLayoutAttributes(attributes: attributes)
            }
        }
        
        contentSize.height = yOffset + contentPadding.vertical
    }
}
