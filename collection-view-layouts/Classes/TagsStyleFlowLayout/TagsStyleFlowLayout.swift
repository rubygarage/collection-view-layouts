//
//  TagsStyleLayout.swift
//  collection-view-layouts
//
//  Created by sergey on 2/21/18.
//  Copyright © 2018 rubygarage. All rights reserved.
//

import UIKit

public class TagsStyleFlowLayout: ContentDynamicLayout {
    override public func calculateCollectionViewCellsFrames() {
        guard let contentCollectionView = collectionView, delegate != nil else {
            return
        }
        
        contentSize.width = contentCollectionView.frame.size.width

        let leftPadding = 0 + contentPadding.horizontal
        let rightPadding = contentCollectionView.frame.size.width - contentPadding.horizontal

        var leftMargin: CGFloat = (contentAlign == .left) ? leftPadding : rightPadding

        var topMargin: CGFloat = contentPadding.vertical

        let sectionsCount = contentCollectionView.numberOfSections
        
        for section in 0..<sectionsCount {
            for item in 0 ..< contentCollectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                attributes.frame.size = delegate!.cellSize(indexPath: indexPath)
                
                let currentCellWidth = attributes.frame.size.width
                let currentCellHeight = attributes.frame.size.height
                
                if contentAlign == .left {
                    if leftMargin + currentCellWidth + cellsPadding.vertical > contentCollectionView.frame.size.width {
                        leftMargin = contentPadding.horizontal
                        topMargin += attributes.frame.size.height + cellsPadding.vertical
                    }
                    
                    attributes.frame.origin.x = leftMargin
                    attributes.frame.origin.y = topMargin
                    
                    leftMargin += currentCellWidth + cellsPadding.horizontal
                    
                } else if contentAlign == .right {
                    if leftMargin - currentCellWidth - cellsPadding.horizontal < 0 {
                        leftMargin = contentCollectionView.frame.size.width - contentPadding.horizontal
                        topMargin += attributes.frame.size.height + cellsPadding.vertical
                    }
                    
                    attributes.frame.origin.x = leftMargin - currentCellWidth
                    attributes.frame.origin.y = topMargin
                    
                    leftMargin -= currentCellWidth + cellsPadding.horizontal
                }
                
                addCachedLayoutAttributes(attributes: attributes)
                
                contentSize.height = topMargin + currentCellHeight + contentPadding.vertical
            }
        }
    }
}
