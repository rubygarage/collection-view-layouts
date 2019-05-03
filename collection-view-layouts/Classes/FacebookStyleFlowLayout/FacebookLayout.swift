//
//  FacebookLayout.swift
//  collection-view-layouts
//
//  Created by sergey on 4/10/18.
//

import UIKit

private let patternTotalCellsCount = 5
private let patternLargeCellsCount = 2
private let patternSmallCellsCount = 3

public class FacebookLayout: ContentDynamicLayout {

    // MARK: - ContentDynamicLayout

    override public func calculateCollectionViewCellsFrames() {
        guard let collectionView = collectionView else {
            return
        }
        
        contentSize.width = collectionView.frame.size.width
        
        let largeCellSide = (contentWidthWithoutPadding - cellsPadding.horizontal) / CGFloat(patternLargeCellsCount)
        let smallCellSide = (contentWidthWithoutPadding - 2 * cellsPadding.horizontal) / CGFloat(patternSmallCellsCount)
        let largeCellSize = CGSize(width: largeCellSide, height: largeCellSide)
        let smallCellSize = CGSize(width: smallCellSide, height: smallCellSide)

        var yOffset = contentPadding.vertical

        for section in 0..<collectionView.numberOfSections {
            let itemsCount = collectionView.numberOfItems(inSection: section)

            for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                let remainder = item % patternTotalCellsCount
                let isLastRow = item == itemsCount - 1
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                if remainder == 0 {
                    let origin = CGPoint(x: contentPadding.horizontal, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: largeCellSize)

                    if isLastRow {
                        yOffset += largeCellSide
                    }
                } else if remainder == 1 {
                    let x = largeCellSide + contentPadding.horizontal + cellsPadding.horizontal
                    let origin = CGPoint(x: x, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: largeCellSize)

                    yOffset += largeCellSide + cellsPadding.vertical
                } else if remainder == 2 {
                    let origin = CGPoint(x: contentPadding.horizontal, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: smallCellSize)

                    if isLastRow {
                        yOffset += smallCellSide
                    }
                } else if remainder == 3 {
                    let x = smallCellSide + cellsPadding.horizontal + contentPadding.horizontal
                    let origin = CGPoint(x: x, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: smallCellSize)

                    if isLastRow {
                        yOffset += smallCellSide
                    }
                } else if remainder == 4 {
                    let x = 2 * (smallCellSide + cellsPadding.horizontal) + contentPadding.horizontal
                    let origin = CGPoint(x: x, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: smallCellSize)

                    yOffset += smallCellSide + cellsPadding.vertical
                }
                
                addCachedLayoutAttributes(attributes: attributes)
            }
        }
        
        contentSize.height = yOffset + contentPadding.vertical
    }
}
