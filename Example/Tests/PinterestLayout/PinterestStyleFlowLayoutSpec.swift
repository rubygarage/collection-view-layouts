//
//  PinterestFlowLayoutTest.swift
//  collection-view-layouts_Example
//
//  Created by sergey on 2/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Fakery
import Nimble
import Quick
@testable import collection_view_layouts

class PinterestStyleFlowLayoutSpec: QuickSpec {
    private let kPinterestStyleFlowLayoutMaxItems: UInt32 = 50
    private let kPinterestStyleFlowLayoutMinItems: UInt32 = 10
    
    override func spec() {
        let itemsCount = Int(arc4random_uniform(kPinterestStyleFlowLayoutMaxItems) + kPinterestStyleFlowLayoutMinItems)
        let items = Faker.init().lorem.words(amount: itemsCount).components(separatedBy: .whitespaces)
        
        describe("Check pinterest flow layout") {
            it("should have default values") {
                let pinterestFlowLayout = PinterestStyleFlowLayout()

                expect(pinterestFlowLayout.contentAlign).to(beAKindOf(DynamicContentAlign.self))
                expect(pinterestFlowLayout.contentAlign).to(equal(DynamicContentAlign.left))
                expect(pinterestFlowLayout.contentAlign).notTo(equal(DynamicContentAlign.right))
                
                expect(pinterestFlowLayout.cellsPadding).to(beAKindOf(ItemsPadding.self))
                expect(pinterestFlowLayout.cellsPadding.horizontal).to(equal(0))
                expect(pinterestFlowLayout.cellsPadding.vertical).to(equal(0))

                expect(pinterestFlowLayout.contentPadding).to(beAKindOf(ItemsPadding.self))
                expect(pinterestFlowLayout.contentPadding.horizontal).to(equal(0))
                expect(pinterestFlowLayout.contentPadding.vertical).to(equal(0))

                expect(pinterestFlowLayout.contentSize).to(beAKindOf(CGSize.self))

                pinterestFlowLayout.calculateCollectionViewCellsFrames()
                
                expect(pinterestFlowLayout.cachedLayoutAttributes.count).to(equal(0))
                
                expect(pinterestFlowLayout.collectionView).to(beNil())
                expect(pinterestFlowLayout.delegate).to(beNil())
            }
        }
        
        describe("Check pinterest flow layout with default settings") {
            let tagsFlowLayout = self.configurePinterestFlowLayout(items: items)
            let attributes = tagsFlowLayout.cachedLayoutAttributes
            
            it("should have single cell only in every column") {
                var currentColumnCount: Int = 0
                
                for attr in attributes {
                    expect(attr.frame.size.width).to(equal(UIScreen.main.bounds.width / CGFloat(tagsFlowLayout.columnsCount)))
                    
                    let columnIndex = attr.indexPath.row % tagsFlowLayout.columnsCount
                    expect(columnIndex).to(equal(currentColumnCount))
                    
                    currentColumnCount = (currentColumnCount < tagsFlowLayout.columnsCount - 1) ? (currentColumnCount + 1) : 0
                }
            }
            
            it("should have every row cells does not intersect between themselves") {
                var previousFramesDict = Dictionary<Int, CGRect>()
                var currentFramesDict = Dictionary<Int, CGRect>()
                
                for attr in attributes {
                    let columnIndex = attr.indexPath.row % tagsFlowLayout.columnsCount
                    currentFramesDict[columnIndex] = attr.frame
                    
                    if columnIndex == tagsFlowLayout.columnsCount - 1 {
                        for i in 0..<previousFramesDict.count {
                            let firstFrame = previousFramesDict[i]!
                            let secondFrame = currentFramesDict[i]!
                            
                            expect(firstFrame.intersects(secondFrame)).to(beFalse())
                        }
                        
                        previousFramesDict = currentFramesDict
                    }
                }
            }
            
            describe("Check pinterest flow layout with custom settings") {
                let items = ["A", "B", "C", "D"]
                let tagsFlowLayout = self.configurePinterestFlowLayout(isCellsTransefered: true, items: items)
                let attributes = tagsFlowLayout.cachedLayoutAttributes
                
                it("should transfer every new cell to previous minimum Y offset") {
                    let firstCellAttributes = attributes[0]
                    let secondCellAttributes = attributes[1]
                    let thirdCellAttributes = attributes[2]
                    let fourthCellAttributes = attributes[3]
                    
                    let cellWidth = UIScreen.main.bounds.width / 2
                    expect(firstCellAttributes.frame).to(equal(CGRect(x: 0, y: 0, width: cellWidth, height: 100)))
                    expect(secondCellAttributes.frame).to(equal(CGRect(x: cellWidth, y: 0, width: cellWidth, height: 30)))
                    expect(thirdCellAttributes.frame).to(equal(CGRect(x: cellWidth, y: 30, width: cellWidth, height: 80)))
                    expect(fourthCellAttributes.frame).to(equal(CGRect(x: 0, y: 100, width: cellWidth, height: 50)))
                }
            }
        }
        
        describe("Check pinterest flow layout with custom settings") {
            it("should have equal width for all cells") {
                let tagsFlowLayout = self.configurePinterestFlowLayout(columnsCount: 3, items: items)
                let attributes = tagsFlowLayout.cachedLayoutAttributes
                
                var currentColumnCount: Int = 0
                
                for attr in attributes {
                    expect(attr.frame.size.width).to(equal(UIScreen.main.bounds.width / CGFloat(tagsFlowLayout.columnsCount)))
                    
                    let columnIndex = attr.indexPath.row % tagsFlowLayout.columnsCount
                    expect(columnIndex).to(equal(currentColumnCount))
                    
                    currentColumnCount = (currentColumnCount < tagsFlowLayout.columnsCount - 1) ? (currentColumnCount + 1) : 0
                }
            }
            
            it("should have outer paddings for cells") {
                let items = ["A", "B", "C", "D"]

                let hPadding: CGFloat = 10
                let vPadding: CGFloat = 10
                let tagsFlowLayout = self.configurePinterestFlowLayout(contentPadding: ItemsPadding(horizontal: hPadding, vertical: vPadding), isCellsTransefered: true, items: items)
                let attributes = tagsFlowLayout.cachedLayoutAttributes
                
                let firstCellAttributes = attributes[0]
                let secondCellAttributes = attributes[1]
                let thirdCellAttributes = attributes[2]
                let fourthCellAttributes = attributes[3]
                
                let cellWidth = (UIScreen.main.bounds.width - 2 * hPadding) / 2
                expect(firstCellAttributes.frame).to(equal(CGRect(x: hPadding, y: vPadding, width: cellWidth, height: 100)))
                expect(secondCellAttributes.frame).to(equal(CGRect(x: cellWidth + hPadding, y: vPadding, width: cellWidth, height: 30)))
                expect(thirdCellAttributes.frame).to(equal(CGRect(x: cellWidth + hPadding, y: 40, width: cellWidth, height: 80)))
                expect(fourthCellAttributes.frame).to(equal(CGRect(x: hPadding, y: 110, width: cellWidth, height: 50)))
            }
            
            it("should have inner paddings for cells") {
                let items = ["A", "B", "C", "D"]
                
                let hPadding: CGFloat = 10
                let vPadding: CGFloat = 10
                let tagsFlowLayout = self.configurePinterestFlowLayout(cellsPadding: ItemsPadding(horizontal: hPadding, vertical: vPadding), isCellsTransefered: true, items: items)
                let attributes = tagsFlowLayout.cachedLayoutAttributes
                
                let firstCellAttributes = attributes[0]
                let secondCellAttributes = attributes[1]
                let thirdCellAttributes = attributes[2]
                let fourthCellAttributes = attributes[3]
                
                let cellWidth = (UIScreen.main.bounds.width - hPadding) / 2
                expect(firstCellAttributes.frame).to(equal(CGRect(x: 0, y: 0, width: cellWidth, height: 100)))
                expect(secondCellAttributes.frame).to(equal(CGRect(x: cellWidth + hPadding, y: 0, width: cellWidth, height: 30)))
                expect(thirdCellAttributes.frame).to(equal(CGRect(x: cellWidth + hPadding, y: 30 + vPadding, width: cellWidth, height: 80)))
                expect(fourthCellAttributes.frame).to(equal(CGRect(x: 0, y: 100 + vPadding, width: cellWidth, height: 50)))
            }
        }
    }
    
    private func configurePinterestFlowLayout(contentPadding: ItemsPadding = ItemsPadding(), cellsPadding: ItemsPadding = ItemsPadding(), columnsCount: Int = 2, isCellsTransefered: Bool = false, items: [String]) -> PinterestStyleFlowLayout {
        let flowDelegate: ContentDynamicLayoutDelegate = (isCellsTransefered) ? PinterestFourElementsDelegateMock() : PinterestFlowDelegate(items: items)
        let pinterestFlowLayout = PinterestStyleFlowLayout()
        pinterestFlowLayout.delegate = flowDelegate
        pinterestFlowLayout.contentPadding = contentPadding
        pinterestFlowLayout.cellsPadding = cellsPadding
        
        let dataSource = ContentDataSource()
        dataSource.items = items
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: pinterestFlowLayout)
        collectionView.dataSource = dataSource
        
        pinterestFlowLayout.calculateCollectionViewCellsFrames()
        
        return pinterestFlowLayout
    }
}
