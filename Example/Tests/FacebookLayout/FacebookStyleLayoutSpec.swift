//
//  FacebookStyleLayoutSpec.swift
//  collection-view-layouts_Tests
//
//  Created by sergey on 4/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import collection_view_layouts

class FacebookStyleLayoutSpec: QuickSpec {
    override func spec() {
        describe("Check facebook flow layout") {
            it("should have default values") {
                let facebookFlowLayout = FacebookStyleFlowLayout()
                
                expect(facebookFlowLayout.contentAlign).to(beAKindOf(DynamicContentAlign.self))
                expect(facebookFlowLayout.contentAlign).to(equal(DynamicContentAlign.left))
                
                expect(facebookFlowLayout.cellsPadding).to(beAKindOf(ItemsPadding.self))
                expect(facebookFlowLayout.cellsPadding.horizontal).to(equal(0))
                expect(facebookFlowLayout.cellsPadding.vertical).to(equal(0))
                
                expect(facebookFlowLayout.contentPadding).to(beAKindOf(ItemsPadding.self))
                expect(facebookFlowLayout.contentPadding.horizontal).to(equal(0))
                expect(facebookFlowLayout.contentPadding.vertical).to(equal(0))
                
                expect(facebookFlowLayout.contentSize).to(beAKindOf(CGSize.self))
                
                facebookFlowLayout.calculateCollectionViewCellsFrames()
                
                expect(facebookFlowLayout.cachedLayoutAttributes.count).to(equal(0))
                
                expect(facebookFlowLayout.collectionView).to(beNil())
                expect(facebookFlowLayout.delegate).to(beNil())
            }
        }
        
        describe("Check flipboard flow inner items") {
            it("should have valid frames") {
                let items = ["1", "2", "3", "4", "5"]
                let facebookFlowLayout = self.configureFacebookFlowLayout(items: items)
                let attributes = facebookFlowLayout.cachedLayoutAttributes
                
                let largeCellWidth = UIScreen.main.bounds.width / CGFloat(2)
                let smallCellWidth = UIScreen.main.bounds.width / CGFloat(3)
                
                let firstCellAttributes = attributes[0]
                let secondCellAttributes = attributes[1]
                let thirdCellAttributes = attributes[2]
                let fourthCellAttributes = attributes[3]
                let fifthCellAttributes = attributes[4]
                
                expect(firstCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: 0, width: largeCellWidth, height: largeCellWidth)))
                expect(secondCellAttributes.frame).to(beCloseTo(CGRect(x: largeCellWidth, y: 0, width: largeCellWidth, height: largeCellWidth)))
                expect(thirdCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: largeCellWidth, width: smallCellWidth, height: smallCellWidth)))
                expect(fourthCellAttributes.frame).to(beCloseTo(CGRect(x: smallCellWidth, y: largeCellWidth, width: smallCellWidth, height: smallCellWidth)))
                expect(fifthCellAttributes.frame).to(beCloseTo(CGRect(x: smallCellWidth * 2, y: largeCellWidth, width: smallCellWidth, height: smallCellWidth)))
            }
            
            it("should have valid content paddings") {
                let items = ["1", "2", "3", "4", "5"]
                let hPadding: CGFloat = 10
                let vPadding: CGFloat = 10
                let contentPadding = ItemsPadding(horizontal: hPadding, vertical: vPadding)
                
                let facebookFlowLayout = self.configureFacebookFlowLayout(contentPadding: contentPadding, items: items)
                let attributes = facebookFlowLayout.cachedLayoutAttributes
                
                let largeCellWidth = (UIScreen.main.bounds.width - 2 * hPadding) / CGFloat(2)
                let smallCellWidth = (UIScreen.main.bounds.width - 2 * hPadding) / CGFloat(3)
                
                let firstCellAttributes = attributes[0]
                let secondCellAttributes = attributes[1]
                let thirdCellAttributes = attributes[2]
                let fourthCellAttributes = attributes[3]
                let fifthCellAttributes = attributes[4]
                
                expect(firstCellAttributes.frame).to(beCloseTo(CGRect(x: hPadding, y: vPadding, width: largeCellWidth, height: largeCellWidth)))
                expect(secondCellAttributes.frame).to(beCloseTo(CGRect(x: largeCellWidth + hPadding, y: vPadding, width: largeCellWidth, height: largeCellWidth)))
                expect(thirdCellAttributes.frame).to(beCloseTo(CGRect(x: hPadding, y: largeCellWidth + vPadding, width: smallCellWidth, height: smallCellWidth)))
                expect(fourthCellAttributes.frame).to(beCloseTo(CGRect(x: smallCellWidth + hPadding, y: largeCellWidth + vPadding, width: smallCellWidth, height: smallCellWidth)))
                expect(fifthCellAttributes.frame).to(beCloseTo(CGRect(x: smallCellWidth * 2 + hPadding, y: largeCellWidth + vPadding, width: smallCellWidth, height: smallCellWidth)))
            }
            
            it("should have valid cells paddings") {
                let items = ["1", "2", "3", "4", "5"]
                let hPadding: CGFloat = 8
                let vPadding: CGFloat = 8
                let cellsPadding = ItemsPadding(horizontal: hPadding, vertical: vPadding)
                
                let facebookFlowLayout = self.configureFacebookFlowLayout(cellsPadding: cellsPadding, items: items)
                let attributes = facebookFlowLayout.cachedLayoutAttributes
                
                let largeCellWidth = (UIScreen.main.bounds.width - hPadding) / CGFloat(2)
                let smallCellWidth = (UIScreen.main.bounds.width - 2 * hPadding) / CGFloat(3)
                
                let firstCellAttributes = attributes[0]
                let secondCellAttributes = attributes[1]
                let thirdCellAttributes = attributes[2]
                let fourthCellAttributes = attributes[3]
                let fifthCellAttributes = attributes[4]
                
                expect(firstCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: 0, width: largeCellWidth, height: largeCellWidth)))
                expect(secondCellAttributes.frame).to(beCloseTo(CGRect(x: largeCellWidth + hPadding, y: 0, width: largeCellWidth, height: largeCellWidth)))
                expect(thirdCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: largeCellWidth + vPadding, width: smallCellWidth, height: smallCellWidth)))
                expect(fourthCellAttributes.frame).to(beCloseTo(CGRect(x: smallCellWidth + hPadding, y: largeCellWidth + vPadding, width: smallCellWidth, height: smallCellWidth)))
                expect(fifthCellAttributes.frame).to(beCloseTo(CGRect(x: (smallCellWidth + hPadding) * 2, y: largeCellWidth + vPadding, width: smallCellWidth, height: smallCellWidth)))
            }
        }
    }
    
    private func configureFacebookFlowLayout(contentPadding: ItemsPadding = ItemsPadding(), cellsPadding: ItemsPadding = ItemsPadding(), align: DynamicContentAlign = .left, items: [String]) -> FacebookStyleFlowLayout {
        let flowDelegate = FacebookFlowDelegateMock(items: items)
        let facebookFlowLayout = FacebookStyleFlowLayout()
        facebookFlowLayout.delegate = flowDelegate
        
        facebookFlowLayout.contentPadding = contentPadding
        facebookFlowLayout.cellsPadding = cellsPadding
        facebookFlowLayout.contentAlign = align
        
        let dataSource = ContentDataSource()
        dataSource.items = items
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: facebookFlowLayout)
        collectionView.dataSource = dataSource
        
        facebookFlowLayout.calculateCollectionViewCellsFrames()
        
        expect(facebookFlowLayout.collectionView).notTo(beNil())
        
        _ = flowDelegate.cellSize(indexPath: IndexPath(row: 0, section: 0))
        expect(flowDelegate.isCellSizeWasCalled).to(beTrue())
        
        expect(facebookFlowLayout.delegate).notTo(beNil())
        expect(facebookFlowLayout.delegate).to(beAKindOf(ContentDynamicLayoutDelegate.self))
        
        return facebookFlowLayout
    }
}
