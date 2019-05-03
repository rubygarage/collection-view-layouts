//
//  TagsLayout.swift
//  collection-view-layouts
//
//  Created by sergey on 2/21/18.
//  Copyright © 2018 rubygarage. All rights reserved.
//

import UIKit

public class TagsLayout: ContentDynamicLayout {

    // MARK: - ContentDynamicLayout

    override public func calculateCollectionViewCellsFrames() {
        guard let collectionView = collectionView, let delegate = delegate else {
            return
        }

        contentSize.width = collectionView.frame.size.width

        var leftMargin = contentAlign == .left
            ? contentPadding.horizontal
            : contentSize.width - contentPadding.horizontal

        var topMargin = contentPadding.vertical

        for section in 0..<collectionView.numberOfSections {
            for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let cellSize = delegate.cellSize(indexPath: indexPath)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                if contentAlign == .left {
                    if leftMargin + cellSize.width + cellsPadding.vertical > contentSize.width {
                        leftMargin = contentPadding.horizontal
                        topMargin += cellSize.height + cellsPadding.vertical
                    }

                    let origin = CGPoint(x: leftMargin, y: topMargin)
                    attributes.frame = CGRect(origin: origin, size: cellSize)

                    leftMargin += cellSize.width + cellsPadding.horizontal
                    
                } else {
                    if leftMargin - cellSize.width - cellsPadding.horizontal < 0 {
                        leftMargin = contentSize.width - contentPadding.horizontal
                        topMargin += cellSize.height + cellsPadding.vertical
                    }

                    let x = leftMargin - cellSize.width
                    let origin = CGPoint(x: x, y: topMargin)
                    attributes.frame = CGRect(origin: origin, size: cellSize)

                    leftMargin -= cellSize.width + cellsPadding.horizontal
                }

                addCachedLayoutAttributes(attributes: attributes)

                contentSize.height = topMargin + cellSize.height + contentPadding.vertical
            }
        }
    }
}
