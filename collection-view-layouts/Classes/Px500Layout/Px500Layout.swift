//
//  Px500Layout.swift
//  collection-view-layouts
//
//  Created by sergey on 3/14/18.
//

import UIKit

private let centerWidthMinCoef: CGFloat = 0.2
private let centerWidthMaxCoef: CGFloat = 0.4
private let notCenterWidthMinCoef: CGFloat = 0.22
private let notCenterWidthMaxCoef: CGFloat = 0.39
private let fullPercent: CGFloat = 1

public enum MinCellsInRow: Int {
    case one = 1
    case two
}

public enum MaxCellsInRow: Int {
    case two = 2
    case three
}

public class Px500Layout: BaseLayout {
    public var minCellsInRow = MinCellsInRow.one
    public var maxCellsInRow = MaxCellsInRow.three
    public var visibleRowsCount = 5
    public var layoutConfiguration = [[Int]]()

    // MARK: - ContentDynamicLayout
    
    override public func calculateCollectionViewFrames() {
        guard let collectionView = collectionView, let delegate = delegate else {
            return
        }

        contentSize.width = collectionView.frame.size.width

        let cellHeight = collectionView.frame.height / CGFloat(visibleRowsCount)

        var yOffset = contentPadding.vertical

        for section in 0..<collectionView.numberOfSections {
            addAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                              section: section,
                                              yOffset: &yOffset)

            let itemsCount = collectionView.numberOfItems(inSection: section)
            prepareLayoutConfiguration(forSection: section, withItemsCount: itemsCount)

            var item = 0
            for cellsInRow in layoutConfiguration[section] {
                let cellsSizes = Array(item..<(item + cellsInRow)).map { item -> CGSize in
                    let indexPath = IndexPath(item: item, section: section)
                    return delegate.cellSize(indexPath: indexPath)
                }

                var xOffset = contentPadding.horizontal

                for cellWidth in convertToRelativeCellsWidths(cellsSizes) {
                    let indexPath = IndexPath(item: item, section: section)
                    
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = CGRect(x: xOffset, y: yOffset, width: cellWidth, height: cellHeight)
                    cachedAttributes.append(attributes)

                    item += 1
                    xOffset += cellWidth + cellsPadding.horizontal
                }

                yOffset += cellHeight + cellsPadding.vertical
            }

            addAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                              section: section,
                                              yOffset: &yOffset)
        }

        contentSize.height = yOffset - cellsPadding.vertical + contentPadding.vertical
    }

    // MARK: - Helpers

    private func prepareLayoutConfiguration(forSection section: Int, withItemsCount itemsCount: Int) {
        if section == layoutConfiguration.count {
            layoutConfiguration.insert([], at: section)
        }

        if layoutConfiguration[section].reduce(0, +) != itemsCount {
            layoutConfiguration[section] = []
        } else if let min = layoutConfiguration[section].min(), let max = layoutConfiguration[section].max() {
            if min < minCellsInRow.rawValue || max > maxCellsInRow.rawValue {
                layoutConfiguration[section] = []
            }
        }

        guard layoutConfiguration[section].isEmpty else {
            return
        }

        var cellsSum = 0
        var cellsInRow = 0

        while cellsSum < itemsCount {
            if cellsSum + maxCellsInRow.rawValue < itemsCount {
                cellsInRow = Int.random(in: minCellsInRow.rawValue...maxCellsInRow.rawValue)
            } else {
                cellsInRow = itemsCount - cellsSum
            }

            cellsSum += cellsInRow
            layoutConfiguration[section].append(cellsInRow)
        }
    }
    
    private func convertToRelativeCellsWidths(_ cellsSizes: [CGSize]) -> [CGFloat] {
        if cellsSizes.count == 2 {
            return calculateTwoCells(cellsSizes)
        } else if cellsSizes.count == 3 {
            return calculateThreeCells(cellsSizes)
        }

        return [contentWidthWithoutPadding]
    }
    
    private func calculateTwoCells(_ cellsSizes: [CGSize]) -> [CGFloat] {
        let firstCellSize = cellsSizes[0]
        let secondCellSize = cellsSizes[1]
        let halfContentWidth = contentWidthWithoutPadding / 2
        let coefficient = firstCellSize.width / secondCellSize.width
        
        if coefficient < fullPercent {
            let firstRelative = halfContentWidth * coefficient
            let secondRelative = contentWidthWithoutPadding - firstRelative
            return [firstRelative - cellsPadding.horizontal, secondRelative]
        }

        let firstRelative = halfContentWidth / coefficient
        let secondRelative = contentWidthWithoutPadding - firstRelative
        return [secondRelative - cellsPadding.horizontal, firstRelative]
    }
    
    private func calculateThreeCells(_ cellsSizes: [CGSize]) -> [CGFloat] {
        let firstCellSize = cellsSizes[0]
        let secondCellSize = cellsSizes[1]
        let thirdCellSize = cellsSizes[2]
        let isFirstPortrait = firstCellSize.height > firstCellSize.width
        let isSecondPortrait = secondCellSize.height > secondCellSize.width
        let isThirdPortrait = thirdCellSize.height > thirdCellSize.width

        guard isFirstPortrait || isSecondPortrait || isThirdPortrait else {
            let cellWidth = (contentWidthWithoutPadding - 2 * cellsPadding.horizontal) / CGFloat(maxCellsInRow.rawValue)
            return [CGFloat](repeating: cellWidth, count: maxCellsInRow.rawValue)
        }

        let notCenterMinCoef = contentWidthWithoutPadding * notCenterWidthMinCoef
        let notCenterMaxCoef = contentWidthWithoutPadding * notCenterWidthMaxCoef - cellsPadding.horizontal
        let centerMinCoef = contentWidthWithoutPadding * centerWidthMinCoef
        let centerMaxCoef = contentWidthWithoutPadding * centerWidthMaxCoef - cellsPadding.horizontal
        
        if isFirstPortrait {
            return [notCenterMinCoef, notCenterMaxCoef, notCenterMaxCoef]
        } else if isSecondPortrait {
            return [centerMaxCoef, centerMinCoef, centerMaxCoef]
        }

        return [notCenterMaxCoef, notCenterMaxCoef, notCenterMinCoef]
    }
}
