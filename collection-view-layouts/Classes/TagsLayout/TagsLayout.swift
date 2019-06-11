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

    override public func calculateCollectionViewFrames() {
        guard let collectionView = collectionView, let delegate = delegate else {
            return
        }

        contentSize.width = collectionView.frame.size.width

        var xOffset = contentAlign == .left
            ? contentPadding.horizontal
            : contentSize.width - contentPadding.horizontal

        var yOffset = contentPadding.vertical

        for section in 0..<collectionView.numberOfSections {
            addAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                              section: section,
                                              yOffset: &yOffset)

            let itemsCount = collectionView.numberOfItems(inSection: section)

            for item in 0 ..< itemsCount {
                let isLastItem = item == itemsCount - 1
                let indexPath = IndexPath(item: item, section: section)
                let cellSize = delegate.cellSize(indexPath: indexPath)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                switch contentAlign {
                case .left:
                    if xOffset + cellSize.width + cellsPadding.vertical > contentSize.width {
                        xOffset = contentPadding.horizontal
                        yOffset += cellSize.height + cellsPadding.vertical
                    }

                    let origin = CGPoint(x: xOffset, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: cellSize)

                    xOffset += cellSize.width + cellsPadding.horizontal
                case .right:
                    if xOffset - cellSize.width - cellsPadding.horizontal < 0 {
                        xOffset = contentSize.width - contentPadding.horizontal
                        yOffset += cellSize.height + cellsPadding.vertical
                    }

                    let x = xOffset - cellSize.width
                    let origin = CGPoint(x: x, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: cellSize)

                    xOffset -= cellSize.width + cellsPadding.horizontal
                }

                cach.append(attributes)

                if isLastItem {
                    yOffset += cellSize.height + cellsPadding.vertical
                    xOffset = contentAlign == .left
                        ? contentPadding.horizontal
                        : contentSize.width - contentPadding.horizontal
                }
            }

            addAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                              section: section,
                                              yOffset: &yOffset)
        }

        contentSize.height = yOffset + contentPadding.vertical
    }
}
