//
//  Px500Layout.swift
//  collection-view-layouts
//
//  Created by sergey on 3/14/18.
//

import UIKit

private let minCellsInRow = 1
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

public class Px500Layout: ContentDynamicLayout {
    public var minCellsInRow = MinCellsInRow.one
    public var maxCellsInRow = MaxCellsInRow.three
    public var visibleRowsCount = 5
    public var layoutConfiguration = Dictionary<Int, Int>()

    // MARK: - ContentDynamicLayout
    
    override public func calculateCollectionViewCellsFrames() {
        guard let collectionView = collectionView, let delegate = delegate else {
            return
        }

        contentSize.width = collectionView.frame.size.width

        let cellHeight = collectionView.frame.height / CGFloat(visibleRowsCount)

        for section in 0..<collectionView.numberOfSections {
            let itemsCount = collectionView.numberOfItems(inSection: section)

            var item = 0
            var yOffset = contentPadding.vertical

            prepareLayoutConfiguration(with: itemsCount)
            
            for (_, cellsInRow) in layoutConfiguration {
                let cellsSizes = Array(item..<(item + cellsInRow)).map { item -> CGSize in
                    let indexPath = IndexPath(item: item, section: section)
                    return delegate.cellSize(indexPath: indexPath)
                }

                var xOffset = contentPadding.horizontal

                for cellWidth in convertToRelativeCellsWidths(cellsSizes) {
                    let indexPath = IndexPath(item: item, section: section)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = CGRect(x: xOffset, y: yOffset, width: cellWidth, height: cellHeight)
                    addCachedLayoutAttributes(attributes: attributes)

                    item += 1
                    xOffset += cellWidth + cellsPadding.horizontal
                }
                
                yOffset += cellHeight + cellsPadding.vertical
            }

            contentSize.height = CGFloat(layoutConfiguration.count) * (cellHeight + cellsPadding.vertical)
                + contentPadding.vertical + cellsPadding.vertical
        }
    }

    // MARK: - Helpers

    private func prepareLayoutConfiguration(with itemsCount: Int) {
        guard layoutConfiguration.isEmpty else {
            return
        }

        var row = 0
        var cellsSum = 0
        var cellsInRow = 0

        while cellsSum < itemsCount {
            if cellsSum + maxCellsInRow.rawValue < itemsCount {
                cellsInRow = Int.random(in: minCellsInRow.rawValue...maxCellsInRow.rawValue)
            } else {
                cellsInRow = itemsCount - cellsSum
            }

            cellsSum += cellsInRow
            layoutConfiguration[row] = cellsInRow
            row += 1
        }
    }
    
    private func convertToRelativeCellsWidths(_ cellsSizes: [CGSize]) -> [CGFloat] {
        if cellsSizes.count == 1 {
            return [contentWidthWithoutPadding]
        } else if cellsSizes.count == 2 {
            return calculateTwoCells(cellsSizes)
        } else if cellsSizes.count == 3 {
            return calculateThreeCells(cellsSizes)
        } else {
            return [CGFloat(0)]
        }
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
        } else {
            let firstRelative = halfContentWidth / coefficient
            let secondRelative = contentWidthWithoutPadding - firstRelative
            return [secondRelative - cellsPadding.horizontal, firstRelative]
        }
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
        } else {
            return [notCenterMaxCoef, notCenterMaxCoef, notCenterMinCoef]
        }
    }
}
