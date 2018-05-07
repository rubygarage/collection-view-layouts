//
//  InstagramStyleFlowLayuout.swift
//  collection-view-layouts
//
//  Created by sergey on 3/21/18.
//

import UIKit

public enum GridType {
    case defaultGrid
    case onePreviewCell
    case regularPreviewCell
}

public class InstagramStyleFlowLayout: ContentDynamicLayout {
    private let kColumnsCount: Int = 3
    private let kSectionsCount: Int = 4
    private let kRowsCountInDefaultSection: Int = 2
    
    public var gridType: GridType = .regularPreviewCell
    
    override public func calculateCollectionViewCellsFrames() {
        guard collectionView != nil, delegate != nil else {
            return
        }
        
        if gridType == .defaultGrid {
            calculateDefaultGridCellFrame()
        } else if gridType == .onePreviewCell {
            calculateOnePreviewGridCellFrame()
        } else if gridType == .regularPreviewCell {
            calculateRegularPreviewCellFrame()
        }
    }
    
    private func calculateDefaultGridCellFrame() {
        let collectionViewWidth = collectionView!.frame.width
        
        let cellHeight = (collectionViewWidth - 2 * contentPadding.horizontal - 2 * cellsPadding.vertical) / 3
        var yOffset: CGFloat = contentPadding.vertical
        
        let sectionsCount = collectionView!.numberOfSections
        
        for section in 0..<sectionsCount {
            let itemsCount = collectionView!.numberOfItems(inSection: section)

            for item in 0 ..< itemsCount {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                let x = CGFloat(indexPath.row % kColumnsCount) * (cellHeight + cellsPadding.horizontal) + contentPadding.horizontal
                attributes.frame = CGRect(x: x, y: yOffset, width: cellHeight, height: cellHeight)
                
                if indexPath.row % kColumnsCount == 2 {
                    yOffset += cellHeight + cellsPadding.vertical
                }
                
                addCachedLayoutAttributes(attributes: attributes)
            }
            
            contentSize.width = collectionViewWidth
            
            let addHeight = (itemsCount % kColumnsCount) > 0 ? cellHeight : 0
            let innerHeight = CGFloat(itemsCount / kColumnsCount) * (cellHeight + cellsPadding.vertical)
            let outerHeight = 2 * contentPadding.vertical
            contentSize.height = innerHeight + addHeight + outerHeight
        }
    }
    
    private func calculateOnePreviewGridCellFrame() {
        let collectionViewWidth = collectionView!.frame.width
        
        let cellHeight = (collectionViewWidth - 2 * contentPadding.horizontal - 2 * cellsPadding.vertical) / 3
        var yOffset: CGFloat = 2 * cellHeight + contentPadding.vertical
        
        let sectionsCount = collectionView!.numberOfSections
        
        for section in 0..<sectionsCount {
            let itemsCount = collectionView!.numberOfItems(inSection: section)

            for item in 0 ..< itemsCount {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                if indexPath.row == 0 {
                    attributes.frame = CGRect(x: contentPadding.horizontal, y: contentPadding.vertical, width: cellHeight, height: cellHeight)
                    yOffset += cellsPadding.vertical
                } else if indexPath.row == 1 {
                    let bottomFrame = CGRect(x: contentPadding.horizontal, y: cellHeight + contentPadding.vertical + cellsPadding.vertical, width: cellHeight, height: cellHeight)
                    let rightFrame = CGRect(x: cellHeight + contentPadding.horizontal + cellsPadding.horizontal, y: contentPadding.vertical, width: cellHeight, height: cellHeight)
                    attributes.frame = (itemsCount == 2) ? rightFrame : bottomFrame
                } else if indexPath.row == 2 {
                    attributes.frame = CGRect(x: cellHeight + contentPadding.horizontal + cellsPadding.horizontal, y: contentPadding.vertical, width: cellHeight * 2 + cellsPadding.horizontal, height: cellHeight * 2 + cellsPadding.vertical)
                    yOffset += cellsPadding.vertical
                } else {
                    let x = CGFloat(indexPath.row % 3) * (cellHeight + cellsPadding.horizontal) + contentPadding.horizontal
                    attributes.frame = CGRect(x: x, y: yOffset, width: cellHeight, height: cellHeight)
                    
                    if indexPath.row % kColumnsCount == 2 {
                        yOffset += (cellHeight + cellsPadding.vertical)
                    }
                }
                
                addCachedLayoutAttributes(attributes: attributes)
            }
            
            contentSize.width = collectionView!.frame.size.width
            
            let addHeight = (itemsCount % kColumnsCount) > 0 ? cellHeight : 0
            contentSize.height = yOffset + addHeight + 2 * contentPadding.vertical
        }
    }
    
    private func calculateRegularPreviewCellFrame() {
        let sectionsCount = collectionView!.numberOfSections
        
        for sect in 0..<sectionsCount {
            let itemsCount = collectionView!.numberOfItems(inSection: sect)
            let collectionViewWidth = collectionView!.frame.width
            
            let cellHeight = (collectionViewWidth - 2 * contentPadding.horizontal - 2 * cellsPadding.vertical) / 3
            var yOffset: CGFloat = contentPadding.vertical
            
            var section: Int = 0
            var rowCount: Int = 0
            
            for item in 0 ..< itemsCount {
                let indexPath = IndexPath(item: item, section: sect)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                if section % kSectionsCount == 0 {
                    calculateRightPreviewSection(attributes: attributes, indexPath: indexPath, cellHeight: cellHeight, section: &section, yOffset: &yOffset, sect: sect)
                } else if section % kSectionsCount == 1 || section % kSectionsCount == 3 {
                    calculateDefaultSection(attributes: attributes, indexPath: indexPath, rowCount: &rowCount, cellHeight: cellHeight, section: &section, yOffset: &yOffset, sect: sect)
                } else if section % kSectionsCount == 2 {
                    calculateLeftPreviewSection(attributes: attributes, indexPath: indexPath, cellHeight: cellHeight, section: &section, yOffset: &yOffset, sect: sect)
                }
                
                addCachedLayoutAttributes(attributes: attributes)
            }
            
            contentSize.width = collectionView!.frame.size.width
            
            contentSize.height = yOffset + contentPadding.horizontal
        }
    }
    
    private func calculateRightPreviewSection(attributes: UICollectionViewLayoutAttributes, indexPath: IndexPath, cellHeight: CGFloat,  section: inout Int, yOffset: inout CGFloat, sect: Int) {
        let itemsCount = collectionView!.numberOfItems(inSection: sect)

        if indexPath.row % kColumnsCount == 0 {
            attributes.frame = CGRect(x: contentPadding.horizontal, y: yOffset, width: cellHeight, height: cellHeight)
            yOffset = (indexPath.row + 1 == itemsCount) ? yOffset + cellHeight : yOffset
            yOffset = (indexPath.row + 2 == itemsCount) ? yOffset : yOffset + cellsPadding.vertical
        } else if indexPath.row % kColumnsCount == 1 {
            let bottomFrame = CGRect(x: contentPadding.horizontal, y: yOffset + cellHeight, width: cellHeight, height: cellHeight)
            let rightFrame = CGRect(x: cellHeight + contentPadding.horizontal + cellsPadding.horizontal, y: yOffset, width: cellHeight, height: cellHeight)
            attributes.frame = (indexPath.row + 1 == itemsCount) ? rightFrame : bottomFrame
            yOffset += cellHeight
        } else if indexPath.row % kColumnsCount == 2 {
            yOffset -= cellsPadding.vertical
            yOffset -= cellHeight
            attributes.frame = CGRect(x: cellHeight + contentPadding.horizontal + cellsPadding.horizontal, y: yOffset, width: cellHeight * 2 + cellsPadding.horizontal, height: cellHeight * 2 + cellsPadding.vertical)
            section += 1
            yOffset += 2 * (cellHeight + cellsPadding.vertical)
        }
    }
    
    private func calculateDefaultSection(attributes: UICollectionViewLayoutAttributes, indexPath: IndexPath, rowCount: inout Int, cellHeight: CGFloat,  section: inout Int, yOffset: inout CGFloat, sect: Int) {
        let itemsCount = collectionView!.numberOfItems(inSection: sect)

        let x = CGFloat(indexPath.row % kColumnsCount) * (cellHeight + cellsPadding.horizontal) + contentPadding.horizontal
        attributes.frame = CGRect(x: x, y: yOffset, width: cellHeight, height: cellHeight)
        
        if indexPath.row % kColumnsCount == 2 {
            yOffset += (cellHeight + cellsPadding.vertical)
            rowCount += 1
        }
        
        if rowCount == kRowsCountInDefaultSection {
            rowCount = 0
            section += 1
        }
        
        yOffset = (indexPath.row + 1 == itemsCount && indexPath.row % kColumnsCount != 2) ? yOffset + cellHeight : yOffset
    }
    
    private func calculateLeftPreviewSection(attributes: UICollectionViewLayoutAttributes, indexPath: IndexPath, cellHeight: CGFloat,  section: inout Int, yOffset: inout CGFloat, sect: Int) {
        let itemsCount = collectionView!.numberOfItems(inSection: sect)

        if indexPath.row % kColumnsCount == 0 {
            let bigFrame = CGRect(x: contentPadding.horizontal, y: yOffset, width: cellHeight * 2 + cellsPadding.horizontal, height: cellHeight * 2 + cellsPadding.vertical)
            let smallFrame = CGRect(x: contentPadding.horizontal, y: yOffset, width: cellHeight, height: cellHeight)
            
            let updatedIndex = indexPath.row + 1
            attributes.frame = (updatedIndex == itemsCount || updatedIndex == itemsCount - 1) ? smallFrame : bigFrame
            
            yOffset = (indexPath.row + 1 == itemsCount) ? yOffset + cellHeight : yOffset
        } else if indexPath.row % kColumnsCount == 1 {
            let centralFrame = CGRect(x: cellHeight + contentPadding.horizontal + cellsPadding.horizontal, y: yOffset, width: cellHeight, height: cellHeight)
            let rightFrame = CGRect(x: cellHeight * 2 + contentPadding.horizontal + 2 * cellsPadding.horizontal, y: yOffset, width: cellHeight, height: cellHeight)
            
            attributes.frame = (indexPath.row + 1 == itemsCount) ? centralFrame : rightFrame
            
            yOffset += cellHeight
        } else if indexPath.row % kColumnsCount == 2 {
            yOffset += cellsPadding.vertical
            attributes.frame = CGRect(x: cellHeight * 2 + contentPadding.horizontal + 2 * cellsPadding.horizontal, y: yOffset, width: cellHeight, height: cellHeight)
            section += 1
            yOffset += cellHeight + (cellsPadding.vertical)
        }
    }
}
