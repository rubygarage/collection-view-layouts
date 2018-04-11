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
        
        let itemsCount = contentCollectionView.numberOfItems(inSection: 0)
        
        var yOffset: CGFloat = 0
        
        for item in 0 ..< itemsCount  {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let smallCellHeight: CGFloat = contentCollectionView.frame.height / CGFloat(kRowsCount)
            let largeCellHeight: CGFloat = smallCellHeight * 2
            let cellWidth = contentCollectionView.frame.width / 2
            let addCellHeight = contentCollectionView.frame.height / CGFloat(kRowsCount - 1)
            
            if indexPath.row % kCellsInSection == 0 {
                attributes.frame = CGRect(x: 0, y: yOffset, width: cellWidth, height: smallCellHeight)
                yOffset = (indexPath.row + 1 == itemsCount) ? yOffset + smallCellHeight : yOffset
            } else if indexPath.row % kCellsInSection == 1 {
                attributes.frame = CGRect(x: cellWidth, y: yOffset, width: cellWidth, height: largeCellHeight)
                yOffset = (indexPath.row + 1 == itemsCount) ? yOffset + largeCellHeight : yOffset + smallCellHeight
            } else if indexPath.row % kCellsInSection == 2 {
                attributes.frame = CGRect(x: 0, y: yOffset, width: cellWidth, height: smallCellHeight)
                yOffset += smallCellHeight
            } else if indexPath.row % kCellsInSection == 3 {
                attributes.frame = CGRect(x: 0, y: yOffset, width: contentCollectionView.frame.width, height: addCellHeight)
                yOffset += addCellHeight
            }
            
            addCachedLayoutAttributes(attributes: attributes)
        }
        
        contentSize.height = yOffset
    }
}
