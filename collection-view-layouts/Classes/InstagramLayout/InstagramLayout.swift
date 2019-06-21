//
//  InstagramLayuout.swift
//  collection-view-layouts
//
//  Created by sergey on 3/21/18.
//

import UIKit

private let columnsCount = 3
private let patternSectionsCount = 4
private let patternDefaultSectionRowsCount = 2

public enum GridType {
    case defaultGrid
    case onePreviewCell
    case regularPreviewCell
}

public class InstagramLayout: BaseLayout {
    public var gridType: GridType = .regularPreviewCell

    private var cellSide: CGFloat = 0
    private var cellSize: CGSize = .zero
    private var previewCellSize: CGSize = .zero
    private var yOffset: CGFloat = 0

    // MARK: - ContentDynamicLayout
    
    override public func calculateCollectionViewFrames() {
        guard let collectionView = collectionView else {
            return
        }

        contentSize.width = collectionView.frame.size.width

        cellSide = (contentWidthWithoutPadding - 2 * cellsPadding.vertical) / CGFloat(columnsCount)
        cellSize = CGSize(width: cellSide, height: cellSide)
        previewCellSize = CGSize(width: cellSide * 2 + cellsPadding.horizontal,
                                 height: cellSide * 2 + cellsPadding.vertical)

        yOffset = contentPadding.vertical

        switch gridType {
        case .defaultGrid:
            calculateDefaultGridFrames(collectionView)
        case .onePreviewCell:
            calculateOnePreviewCellFrames(collectionView)
        case .regularPreviewCell:
            calculateRegularPreviewCellFrames(collectionView)
        }

        contentSize.height = yOffset - cellsPadding.vertical + contentPadding.vertical
    }

    // MARK: - Helpers
    
    private func calculateDefaultGridFrames(_ collectionView: UICollectionView) {
        for section in 0..<collectionView.numberOfSections {
            addAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                              section: section,
                                              yOffset: &yOffset)

            let itemsCount = collectionView.numberOfItems(inSection: section)

            for item in 0 ..< itemsCount {
                let column = item % columnsCount
                let isLastItemInRow = column == 2
                let isLastItemInSection = item == itemsCount - 1
                let indexPath = IndexPath(item: item, section: section)

                let x = CGFloat(column) * (cellSide + cellsPadding.horizontal) + contentPadding.horizontal
                let origin = CGPoint(x: x, y: yOffset)

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(origin: origin, size: cellSize)
                cachedAttributes.append(attributes)
                
                if isLastItemInRow || isLastItemInSection {
                    yOffset += cellSide + cellsPadding.vertical
                }
            }

            addAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                              section: section,
                                              yOffset: &yOffset)
        }
    }
    
    private func calculateOnePreviewCellFrames(_ collectionView: UICollectionView) {
        for section in 0..<collectionView.numberOfSections {
            addAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                              section: section,
                                              yOffset: &yOffset)

            let itemsCount = collectionView.numberOfItems(inSection: section)

            for item in 0 ..< itemsCount {
                let column = item % columnsCount
                let isLastItemInRow = column == 2
                let isLastItemInSection = item == itemsCount - 1
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                if item == 0 {
                    let origin = CGPoint(x: contentPadding.horizontal, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: cellSize)

                    if isLastItemInSection {
                        yOffset += cellSide + cellsPadding.vertical
                    }
                } else if item == 1 {
                    let x = cellSide + contentPadding.horizontal + cellsPadding.horizontal
                    let origin = CGPoint(x: x, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: previewCellSize)

                    yOffset += isLastItemInSection ? previewCellSize.height : cellSide
                    yOffset += cellsPadding.vertical
                } else if item == 2 {
                    let origin = CGPoint(x: contentPadding.horizontal, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: cellSize)

                    yOffset += cellSide + cellsPadding.vertical
                } else {
                    let x = CGFloat(column) * (cellSide + cellsPadding.horizontal) + contentPadding.horizontal
                    let origin = CGPoint(x: x, y: yOffset)
                    attributes.frame = CGRect(origin: origin, size: cellSize)
                    
                    if isLastItemInRow || isLastItemInSection {
                        yOffset += cellSide + cellsPadding.vertical
                    }
                }
                
                cachedAttributes.append(attributes)
            }

            addAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                              section: section,
                                              yOffset: &yOffset)
        }
    }
    
    private func calculateRegularPreviewCellFrames(_ collectionView: UICollectionView) {
        for section in 0..<collectionView.numberOfSections {
            addAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                              section: section,
                                              yOffset: &yOffset)

            let itemsCount = collectionView.numberOfItems(inSection: section)
            
            var patternSection = 0
            var rowsCount = 0
            
            for item in 0 ..< itemsCount {
                let itemRemainder = item % columnsCount
                let patternSectionRemainder = patternSection % patternSectionsCount
                let isLastItemInRow = itemRemainder == 2
                let isLastItemInSection = item == itemsCount - 1
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                if patternSectionRemainder == 0 {
                    calculateRightPreviewSection(patternSection: &patternSection,
                                                 remainder: itemRemainder,
                                                 isLastItemInSection: isLastItemInSection,
                                                 attributes: attributes)
                } else if patternSectionRemainder == 1 || patternSectionRemainder == 3 {
                    calculateDefaultSection(rowsCount: &rowsCount,
                                            patternSection: &patternSection,
                                            remainder: itemRemainder,
                                            isLastItemInRow: isLastItemInRow,
                                            isLastItemInSection: isLastItemInSection,
                                            attributes: attributes)
                } else if patternSectionRemainder == 2 {
                    calculateLeftPreviewSection(patternSection: &patternSection,
                                                remainder: itemRemainder,
                                                isLastItemInSection: isLastItemInSection,
                                                attributes: attributes)
                }
                
                cachedAttributes.append(attributes)
            }

            addAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                              section: section,
                                              yOffset: &yOffset)
        }
    }
    
    private func calculateRightPreviewSection(patternSection: inout Int,
                                              remainder: Int,
                                              isLastItemInSection: Bool,
                                              attributes: UICollectionViewLayoutAttributes) {

        if remainder == 0 {
            let origin = CGPoint(x: contentPadding.horizontal, y: yOffset)
            attributes.frame = CGRect(origin: origin, size: cellSize)

            if isLastItemInSection {
                yOffset += cellSide + cellsPadding.vertical
            }
        } else if remainder == 1 {
            let x = cellSide + contentPadding.horizontal + cellsPadding.horizontal
            let origin = CGPoint(x: x, y: yOffset)
            attributes.frame = CGRect(origin: origin, size: previewCellSize)

            yOffset += isLastItemInSection ? previewCellSize.height : cellSide
            yOffset += cellsPadding.vertical
        } else {
            let origin = CGPoint(x: contentPadding.horizontal, y: yOffset)
            attributes.frame = CGRect(origin: origin, size: cellSize)

            yOffset += cellSide + cellsPadding.vertical

            patternSection += 1
        }
    }

    private func calculateDefaultSection(rowsCount: inout Int,
                                         patternSection: inout Int,
                                         remainder: Int,
                                         isLastItemInRow: Bool,
                                         isLastItemInSection: Bool,
                                         attributes: UICollectionViewLayoutAttributes) {

        let x = CGFloat(remainder) * (cellSide + cellsPadding.horizontal) + contentPadding.horizontal
        let origin = CGPoint(x: x, y: yOffset)
        attributes.frame = CGRect(origin: origin, size: cellSize)

        if isLastItemInRow || isLastItemInSection {
            yOffset += cellSide + cellsPadding.vertical
            rowsCount += 1
        }

        if rowsCount == patternDefaultSectionRowsCount {
            rowsCount = 0
            patternSection += 1
        }
    }
    
    private func calculateLeftPreviewSection(patternSection: inout Int,
                                             remainder: Int,
                                             isLastItemInSection: Bool,
                                             attributes: UICollectionViewLayoutAttributes) {

        if remainder == 0 {
            let origin = CGPoint(x: contentPadding.horizontal, y: yOffset)
            attributes.frame = CGRect(origin: origin, size: previewCellSize)

            if isLastItemInSection {
                yOffset += previewCellSize.height + cellsPadding.vertical
            }
        } else if remainder == 1 {
            let x = previewCellSize.width + contentPadding.horizontal + cellsPadding.horizontal
            let origin = CGPoint(x: x, y: yOffset)
            attributes.frame = CGRect(origin: origin, size: cellSize)

            yOffset += isLastItemInSection ? previewCellSize.height : cellSide
            yOffset += cellsPadding.vertical
        } else {
            let x = previewCellSize.width + contentPadding.horizontal + cellsPadding.horizontal
            let origin = CGPoint(x: x, y: yOffset)
            attributes.frame = CGRect(origin: origin, size: cellSize)

            yOffset += cellSide + cellsPadding.vertical

            patternSection += 1
        }
    }
}
