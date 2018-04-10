//
//  FlipboardStyleLayoutSpec.swift
//  collection-view-layouts_Example
//
//  Created by sergey on 4/6/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import collection_view_layouts

class FlipboardStyleLayoutSpec: QuickSpec {
    override func spec() {
        describe("Check flipboard flow layout") {
            it("should have default values") {
                let flipboardFlowLayout = FlipboardStyleFlowLayout()
                
                expect(flipboardFlowLayout.contentAlign).to(beAKindOf(DynamicContentAlign.self))
                expect(flipboardFlowLayout.contentAlign).to(equal(DynamicContentAlign.left))
                
                expect(flipboardFlowLayout.cellsPadding).to(beAKindOf(ItemsPadding.self))
                expect(flipboardFlowLayout.cellsPadding.horizontal).to(equal(0))
                expect(flipboardFlowLayout.cellsPadding.vertical).to(equal(0))
                
                expect(flipboardFlowLayout.contentPadding).to(beAKindOf(ItemsPadding.self))
                expect(flipboardFlowLayout.contentPadding.horizontal).to(equal(0))
                expect(flipboardFlowLayout.contentPadding.vertical).to(equal(0))
                
                expect(flipboardFlowLayout.contentSize).to(beAKindOf(CGSize.self))
                
                flipboardFlowLayout.calculateCollectionViewCellsFrames()
                
                expect(flipboardFlowLayout.cachedLayoutAttributes.count).to(equal(0))
                
                expect(flipboardFlowLayout.collectionView).to(beNil())
                expect(flipboardFlowLayout.delegate).to(beNil())
            }
        }
        
        describe("Check flipboard flow inner items") {
            it("should have valid frames in left align") {
                let items = ["1", "2", "3", "4", "5", "6", "7", "8"]
                let flipboardFlowLayout = self.configureFlipboardFlowLayout(items: items)
                let attributes = flipboardFlowLayout.cachedLayoutAttributes
                
                let cellWidth = UIScreen.main.bounds.width / 3
                
                let firstCellAttributes = attributes[0]
                let secondCellAttributes = attributes[1]
                let thirdCellAttributes = attributes[2]
                let fourthCellAttributes = attributes[3]
                let fifthCellAttributes = attributes[4]
                let sixthCellAttributes = attributes[5]
                let seventhCellAttributes = attributes[6]
                let eighthCellAttributes = attributes[7]
                
                expect(firstCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: 0, width: cellWidth * 2, height: cellWidth)))
                expect(secondCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth * 2, y: 0, width: cellWidth, height: cellWidth)))
                expect(thirdCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: cellWidth, width: cellWidth, height: cellWidth)))
                expect(fourthCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth, y: cellWidth, width: cellWidth, height: cellWidth)))
                expect(fifthCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth * 2, y: cellWidth, width: cellWidth, height: cellWidth)))
                expect(sixthCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: cellWidth * 2, width: cellWidth, height: cellWidth)))
                expect(seventhCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth, y: cellWidth * 2, width: cellWidth, height: cellWidth)))
                expect(eighthCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth * 2, y: cellWidth * 2, width: cellWidth, height: cellWidth)))
            }
            
            it("should have valid frames in right align") {
                let items = ["1", "2", "3", "4", "5", "6", "7", "8"]
                let flipboardFlowLayout = self.configureFlipboardFlowLayout(align: .right, items: items)
                let attributes = flipboardFlowLayout.cachedLayoutAttributes
                
                let cellWidth = UIScreen.main.bounds.width / 3
                
                let firstCellAttributes = attributes[0]
                let secondCellAttributes = attributes[1]
                let thirdCellAttributes = attributes[2]
                let fourthCellAttributes = attributes[3]
                let fifthCellAttributes = attributes[4]
                let sixthCellAttributes = attributes[5]
                let seventhCellAttributes = attributes[6]
                let eighthCellAttributes = attributes[7]
                
                expect(firstCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth, y: 0, width: cellWidth * 2, height: cellWidth)))
                expect(secondCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: 0, width: cellWidth, height: cellWidth)))
                expect(thirdCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: cellWidth, width: cellWidth, height: cellWidth)))
                expect(fourthCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth, y: cellWidth, width: cellWidth, height: cellWidth)))
                expect(fifthCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth * 2, y: cellWidth, width: cellWidth, height: cellWidth)))
                expect(sixthCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: cellWidth * 2, width: cellWidth, height: cellWidth)))
                expect(seventhCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth, y: cellWidth * 2, width: cellWidth, height: cellWidth)))
                expect(eighthCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth * 2, y: cellWidth * 2, width: cellWidth, height: cellWidth)))
            }
            
            it("should have valid content paddings") {
                let items = ["1", "2", "3", "4", "5", "6", "7", "8"]
                let hPadding: CGFloat = 10
                let vPadding: CGFloat = 10
                let contentPadding = ItemsPadding(horizontal: hPadding, vertical: vPadding)
                
                let flipboardFlowLayout = self.configureFlipboardFlowLayout(contentPadding: contentPadding, items: items)
                let attributes = flipboardFlowLayout.cachedLayoutAttributes
                
                let cellWidth = (UIScreen.main.bounds.width - 2 * hPadding) / 3
                
                let firstCellAttributes = attributes[0]
                let secondCellAttributes = attributes[1]
                let thirdCellAttributes = attributes[2]
                let fourthCellAttributes = attributes[3]
                let fifthCellAttributes = attributes[4]
                let sixthCellAttributes = attributes[5]
                let seventhCellAttributes = attributes[6]
                let eighthCellAttributes = attributes[7]
                
                expect(firstCellAttributes.frame).to(beCloseTo(CGRect(x: hPadding, y: vPadding, width: cellWidth * 2, height: cellWidth)))
                expect(secondCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth * 2 + hPadding, y: vPadding, width: cellWidth, height: cellWidth)))
                expect(thirdCellAttributes.frame).to(beCloseTo(CGRect(x: hPadding, y: cellWidth + vPadding, width: cellWidth, height: cellWidth)))
                expect(fourthCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth + hPadding, y: cellWidth + vPadding, width: cellWidth, height: cellWidth)))
                expect(fifthCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth * 2 + hPadding, y: cellWidth + vPadding, width: cellWidth, height: cellWidth)))
                expect(sixthCellAttributes.frame).to(beCloseTo(CGRect(x: hPadding, y: cellWidth * 2 + vPadding, width: cellWidth, height: cellWidth)))
                expect(seventhCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth + hPadding, y: cellWidth * 2 + vPadding, width: cellWidth, height: cellWidth)))
                expect(eighthCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth * 2 + hPadding, y: cellWidth * 2 + vPadding, width: cellWidth, height: cellWidth)))
            }
            
            it("should have valid cells paddings") {
                let items = ["1", "2", "3", "4", "5", "6", "7", "8"]
                let hPadding: CGFloat = 8
                let vPadding: CGFloat = 8
                let cellsPadding = ItemsPadding(horizontal: hPadding, vertical: vPadding)
                
                let flipboardFlowLayout = self.configureFlipboardFlowLayout(cellsPadding: cellsPadding, items: items)
                let attributes = flipboardFlowLayout.cachedLayoutAttributes
                
                let cellWidth = (UIScreen.main.bounds.width - 2 * hPadding) / 3
                
                let firstCellAttributes = attributes[0]
                let secondCellAttributes = attributes[1]
                let thirdCellAttributes = attributes[2]
                let fourthCellAttributes = attributes[3]
                let fifthCellAttributes = attributes[4]
                let sixthCellAttributes = attributes[5]
                let seventhCellAttributes = attributes[6]
                let eighthCellAttributes = attributes[7]
                
                expect(firstCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: 0, width: cellWidth * 2 + hPadding, height: cellWidth)))
                expect(secondCellAttributes.frame).to(beCloseTo(CGRect(x: (cellWidth + hPadding) * 2, y: 0, width: cellWidth, height: cellWidth)))
                expect(thirdCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: cellWidth + hPadding, width: cellWidth, height: cellWidth)))
                expect(fourthCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth + hPadding, y: cellWidth + vPadding, width: cellWidth, height: cellWidth)))
                expect(fifthCellAttributes.frame).to(beCloseTo(CGRect(x: (cellWidth + hPadding) * 2, y: cellWidth + vPadding, width: cellWidth, height: cellWidth)))
                expect(sixthCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: (cellWidth + vPadding) * 2, width: cellWidth, height: cellWidth)))
                expect(seventhCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth + hPadding, y: (cellWidth + vPadding) * 2, width: cellWidth, height: cellWidth)))
                expect(eighthCellAttributes.frame).to(beCloseTo(CGRect(x: (cellWidth + hPadding) * 2, y: (cellWidth + vPadding) * 2, width: cellWidth, height: cellWidth)))
            }
        }
    }
    
    private func configureFlipboardFlowLayout(contentPadding: ItemsPadding = ItemsPadding(), cellsPadding: ItemsPadding = ItemsPadding(), align: DynamicContentAlign = .left, items: [String]) -> FlipboardStyleFlowLayout {
        let flowDelegate = FlipboardFlowDelegateMock(items: items)
        let flipboardFlowLayout = FlipboardStyleFlowLayout()
        flipboardFlowLayout.delegate = flowDelegate
        
        flipboardFlowLayout.contentPadding = contentPadding
        flipboardFlowLayout.cellsPadding = cellsPadding
        flipboardFlowLayout.contentAlign = align
        
        let dataSource = ContentDataSource()
        dataSource.items = items
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: flipboardFlowLayout)
        collectionView.dataSource = dataSource
        
        flipboardFlowLayout.calculateCollectionViewCellsFrames()
        
        expect(flipboardFlowLayout.collectionView).notTo(beNil())
        
        _ = flowDelegate.cellSize(indexPath: IndexPath(row: 0, section: 0))
        expect(flowDelegate.isCellSizeWasCalled).to(beTrue())
        
        expect(flipboardFlowLayout.delegate).notTo(beNil())
        expect(flipboardFlowLayout.delegate).to(beAKindOf(ContentDynamicLayoutDelegate.self))
        
        return flipboardFlowLayout
    }
}
