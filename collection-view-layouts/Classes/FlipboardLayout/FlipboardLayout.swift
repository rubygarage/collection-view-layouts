//
//  FlipboardLayout.swift
//  collection-view-layouts
//
//  Created by sergey on 4/4/18.
//

import UIKit

private let patternTotalCellsCount = 8
private let patternColumnsCount = 3

public class FlipboardLayout: ContentDynamicLayout {

    // MARK: - ContentDynamicLayout

    override public func calculateCollectionViewFrames() {
        guard let collectionView = collectionView else {
            return
        }
        
        contentSize.width = collectionView.frame.size.width
        
        let cellSide = (contentWidthWithoutPadding - 2 * cellsPadding.horizontal) / CGFloat(patternColumnsCount)
        let squareCellSize = CGSize(width: cellSide, height: cellSide)
        let rectangleCellSize = CGSize(width: cellSide * 2 + cellsPadding.horizontal, height: cellSide)

        var yOffset = contentPadding.vertical
        
        for section in 0..<collectionView.numberOfSections {
            addAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                              section: section,
                                              yOffset: &yOffset)

            let itemsCount = collectionView.numberOfItems(inSection: section)

            for item in 0 ..< itemsCount {
                let remainder = item % patternTotalCellsCount
                let isLastItem = item == itemsCount - 1
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                if remainder == 0 {
                    let x = contentAlign == .left
                        ? contentPadding.horizontal
                        : cellSide + cellsPadding.horizontal + contentPadding.horizontal

                    let origin = CGPoint(x: x, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: rectangleCellSize)

                    if isLastItem {
                        yOffset += cellSide + cellsPadding.vertical
                    }
                } else if remainder == 1 {
                    let x = contentAlign == .left
                        ? 2 * (cellSide + cellsPadding.horizontal) + contentPadding.horizontal
                        : contentPadding.horizontal

                    let origin = CGPoint(x: x, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: squareCellSize)
                    
                    yOffset += cellSide + cellsPadding.vertical
                } else if remainder == 2 || remainder == 5 {
                    let origin = CGPoint(x: contentPadding.horizontal, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: squareCellSize)

                    if isLastItem {
                        yOffset += cellSide + cellsPadding.vertical
                    }
                } else if remainder == 3 || remainder == 6 {
                    let x = cellSide + cellsPadding.horizontal + contentPadding.horizontal
                    let origin = CGPoint(x: x, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: squareCellSize)

                    if isLastItem {
                        yOffset += cellSide + cellsPadding.vertical
                    }
                } else if remainder == 4 || remainder == 7 {
                    let x = 2 * (cellSide + cellsPadding.horizontal) + contentPadding.horizontal
                    let origin = CGPoint(x: x, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: squareCellSize)
                    
                    yOffset += cellSide + cellsPadding.vertical
                }
                
                cach.append(attributes)
            }

            addAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                              section: section,
                                              yOffset: &yOffset)
        }
        
        contentSize.height = yOffset + contentPadding.vertical
    }
}
