//
//  500pxStyleFlowLayout.swift
//  collection-view-layouts
//
//  Created by sergey on 3/14/18.
//

import UIKit

public class Px500StyleFlowLayout: ContentDynamicLayout {
    private let kMinCellsInRow: UInt32 = 1
    private let kMaxCellsInRow: UInt32 = 3
    private let kCenterWidthMinCoef: CGFloat = 0.2
    private let kCenterWidthMaxCoef: CGFloat = 0.4
    private let kNotCenterWidthMinCoef: CGFloat = 0.22
    private let kNotCenterWidthMaxCoef: CGFloat = 0.39
    private let kFullPercents: CGFloat = 1
    
    public var visibleRowsCount: Int = 5
    public var layoutConfiguration = Dictionary<Int, Int>()
    
    override public func calculateCollectionViewCellsFrames() {
        guard let contentCollectionView = collectionView, delegate != nil else {
            return
        }
        
        let sectionsCount = contentCollectionView.numberOfSections
        
        for section in 0..<sectionsCount {
            let itemsCount = contentCollectionView.numberOfItems(inSection: section)
            
            var sum: Int = 0
            var rowCount: Int = 0
            var cellsInRowCount: UInt32 = 0
            
            if layoutConfiguration.count == 0 {
                while sum < itemsCount {
                    if sum + Int(kMaxCellsInRow) < itemsCount {
                        cellsInRowCount = arc4random_uniform(kMaxCellsInRow) + kMinCellsInRow
                    } else {
                        cellsInRowCount = UInt32(itemsCount - sum)
                    }
                    
                    sum += Int(cellsInRowCount)
                    layoutConfiguration[rowCount] = Int(cellsInRowCount)
                    
                    rowCount += 1
                }
            } else {
                rowCount = layoutConfiguration.count
            }
            
            let cellHeight = collectionView!.frame.height / CGFloat(visibleRowsCount)
            
            var index: Int = 0
            var yOffset: CGFloat = contentPadding.vertical
            
            for i in 0..<rowCount  {
                let cellsInRow = layoutConfiguration[i]!
                
                var xOffset: CGFloat = contentPadding.horizontal
                var cellsSizes = [CGSize]()
                
                for i in index..<(index + cellsInRow)  {
                    let indexPath = IndexPath(item: i, section: section)
                    let contentSize = delegate!.cellSize(indexPath: indexPath)
                    
                    cellsSizes.append(contentSize)
                }
                
                let cellWidthsPercents = convertCellWidthsToRelative(cellsSizes: cellsSizes)
                
                for j in 0..<cellsInRow {
                    let indexPath = IndexPath(item: index, section: section)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    
                    let currentCellWidth = cellWidthsPercents[j]
                    
                    attributes.frame = CGRect(x: xOffset, y: yOffset, width: currentCellWidth, height: cellHeight)
                    
                    addCachedLayoutAttributes(attributes: attributes)
                    index += 1
                    xOffset += (currentCellWidth + cellsPadding.horizontal)
                }
                
                yOffset += (cellHeight + cellsPadding.vertical)
            }
            
            contentSize.width = contentCollectionView.frame.size.width
            contentSize.height = CGFloat(rowCount) * (cellHeight + cellsPadding.vertical) + contentPadding.vertical + cellsPadding.vertical
        }
    }
    
    private func convertCellWidthsToRelative(cellsSizes: [CGSize]) -> [CGFloat] {
        if cellsSizes.count == 1 {
            return [collectionView!.frame.size.width - 2 * contentPadding.horizontal]
        } else if cellsSizes.count == 2 {
            return calculateDoubleCells(cellsSizes: cellsSizes)
        } else if cellsSizes.count == 3 {
            return calculateThreeCells(cellsSizes: cellsSizes)
        }
        return [CGFloat(0)]
    }
    
    private func calculateDoubleCells(cellsSizes: [CGSize]) -> [CGFloat] {
        let firstCellSize = cellsSizes[0]
        let secondCellSize = cellsSizes[1]
        
        let contentWidth = collectionView!.frame.width  - 2 * contentPadding.horizontal
        
        let halfContentWidth = contentWidth / 2
        
        let coefficient = firstCellSize.width / secondCellSize.width
        
        if coefficient < kFullPercents {
            let relativeFirst = halfContentWidth * coefficient
            let relativeSecond = contentWidth - relativeFirst
            return [relativeFirst - cellsPadding.horizontal, relativeSecond]
        } else {
            let relativeFirst = halfContentWidth / coefficient
            let relativeSecond = contentWidth - relativeFirst
            return [relativeSecond - cellsPadding.horizontal, relativeFirst]
        }
    }
    
    private func calculateThreeCells(cellsSizes: [CGSize]) -> [CGFloat] {
        let contentWidth = collectionView!.frame.width  - 2 * contentPadding.horizontal

        let firstCellSize = cellsSizes[0]
        let secondCellSize = cellsSizes[1]
        let thirdCellSize = cellsSizes[2]
        
        let isFirstPortrait = firstCellSize.height > firstCellSize.width
        let isSecondPortrait = secondCellSize.height > secondCellSize.width
        let isThirdPortrait = thirdCellSize.height > thirdCellSize.width
        
        var relativeFirstWidth: CGFloat = 0
        var relativeSecondWidth: CGFloat = 0
        var relativeThirdWidth: CGFloat = 0
        
        if isFirstPortrait == true {
            relativeFirstWidth = CGFloat(contentWidth * kNotCenterWidthMinCoef)
            relativeSecondWidth = CGFloat(contentWidth * kNotCenterWidthMaxCoef - cellsPadding.horizontal)
            relativeThirdWidth = CGFloat(contentWidth * kNotCenterWidthMaxCoef - cellsPadding.horizontal)
            
            return [relativeFirstWidth, relativeSecondWidth, relativeThirdWidth]
        } else if isSecondPortrait == true {
            relativeFirstWidth = CGFloat(contentWidth * kCenterWidthMaxCoef - cellsPadding.horizontal)
            relativeSecondWidth = CGFloat(contentWidth * kCenterWidthMinCoef)
            relativeThirdWidth = CGFloat(contentWidth * kCenterWidthMaxCoef - cellsPadding.horizontal)
            
            return [relativeFirstWidth, relativeSecondWidth, relativeThirdWidth]
        } else if isThirdPortrait == true {
            relativeFirstWidth = CGFloat(contentWidth * kNotCenterWidthMaxCoef - cellsPadding.horizontal)
            relativeSecondWidth = CGFloat(contentWidth * kNotCenterWidthMaxCoef - cellsPadding.horizontal)
            relativeThirdWidth = CGFloat(contentWidth * kNotCenterWidthMinCoef)
            
            return [relativeFirstWidth, relativeSecondWidth, relativeThirdWidth]
        } else {
            let cellWidth = (contentWidth - 2 * cellsPadding.horizontal) / CGFloat(kMaxCellsInRow)
            return [CGFloat](repeating: cellWidth, count: Int(kMaxCellsInRow))
        }
    }
}
