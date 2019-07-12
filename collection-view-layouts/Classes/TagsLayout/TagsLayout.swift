//
//  TagsLayout.swift
//  collection-view-layouts
//
//  Created by sergey on 2/21/18.
//  Copyright © 2018 rubygarage. All rights reserved.
//

import UIKit

public enum ScrollDirection : Int {
    case vertical
    case horizontal
}

public class TagsLayout: ContentAlignableLayout {
    public var scrollDirection = ScrollDirection.vertical

    // MARK: - ContentDynamicLayout

    override public func calculateCollectionViewFrames() {
        switch scrollDirection {
        case .vertical:
            calculateVerticalScrollDirection()
        case .horizontal:
            calculateHorizontalScrollDirection()
        }
    }

    // MARK: - Helpers

    func calculateVerticalScrollDirection() {
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

                cachedAttributes.append(attributes)

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

        contentSize.height = yOffset - cellsPadding.vertical + contentPadding.vertical
    }

    func calculateHorizontalScrollDirection() {
        guard let collectionView = collectionView, let delegate = delegate else {
            return
        }

        contentSize.height = collectionView.frame.size.height

        var xOffset = contentPadding.horizontal
        var yOffset = contentPadding.vertical

        for section in 0..<collectionView.numberOfSections {
            let itemsCount = collectionView.numberOfItems(inSection: section)

            var rowsCount = 0
            var xOffsets = [CGFloat]()

            for item in 0 ..< itemsCount {
                let isLastItem = item == itemsCount - 1
                let indexPath = IndexPath(item: item, section: section)
                let cellSize = delegate.cellSize(indexPath: indexPath)

                if yOffset + cellSize.height + cellsPadding.vertical > contentSize.height {
                    yOffset = contentPadding.vertical
                    rowsCount = item
                }

                let isFirstColumn = rowsCount == 0
                let row = isFirstColumn ? 0 : item % rowsCount
                let isValidRow = row < xOffsets.count

                let x = isFirstColumn || !isValidRow ? xOffset : xOffsets[row]
                let origin = CGPoint(x: x, y: yOffset)

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(origin: origin, size: cellSize)
                cachedAttributes.append(attributes)

                if isFirstColumn {
                    xOffsets.append(xOffset + cellSize.width + cellsPadding.horizontal)
                } else if isValidRow {
                    let x = xOffsets[row]
                    xOffsets[row] = x + cellSize.width + cellsPadding.horizontal
                }

                yOffset += cellSize.height + cellsPadding.vertical

                if isLastItem {
                    xOffset = xOffsets.max()!
                    yOffset = contentPadding.vertical

                    xOffsets.removeAll()
                    rowsCount = 0
                }
            }
        }

        contentSize.width = xOffset - cellsPadding.horizontal + contentPadding.horizontal
    }
}
