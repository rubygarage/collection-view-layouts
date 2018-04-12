//
//  FlickrStyleFlowLayoutSpec.swift
//  collection-view-layouts_Example
//
//  Created by sergey on 4/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import collection_view_layouts

class FlickrStyleFlowLayoutSpec: QuickSpec {
    override func spec() {
        describe("Check flickr flow layout") {
            it("should have default values") {
                let flickrFlowLayout = FacebookStyleFlowLayout()
                
                expect(flickrFlowLayout.contentAlign).to(beAKindOf(DynamicContentAlign.self))
                expect(flickrFlowLayout.contentAlign).to(equal(DynamicContentAlign.left))
                
                expect(flickrFlowLayout.cellsPadding).to(beAKindOf(ItemsPadding.self))
                expect(flickrFlowLayout.cellsPadding.horizontal).to(equal(0))
                expect(flickrFlowLayout.cellsPadding.vertical).to(equal(0))
                
                expect(flickrFlowLayout.contentPadding).to(beAKindOf(ItemsPadding.self))
                expect(flickrFlowLayout.contentPadding.horizontal).to(equal(0))
                expect(flickrFlowLayout.contentPadding.vertical).to(equal(0))
                
                expect(flickrFlowLayout.contentSize).to(beAKindOf(CGSize.self))
                
                flickrFlowLayout.calculateCollectionViewCellsFrames()
                
                expect(flickrFlowLayout.cachedLayoutAttributes.count).to(equal(0))
                
                expect(flickrFlowLayout.collectionView).to(beNil())
                expect(flickrFlowLayout.delegate).to(beNil())
            }
        }
        
        describe("Check flickr flow inner items") {
            it("should have valid frames") {
                let items = ["1", "2", "3", "4"]
                let flickrFlowLayout = self.configureFlickrFlowLayout(items: items)
                let attributes = flickrFlowLayout.cachedLayoutAttributes
                
                let smallCellHeight: CGFloat = UIScreen.main.bounds.height / 5
                let largeCellHeight: CGFloat = smallCellHeight * 2
                let cellWidth = UIScreen.main.bounds.width / 2
                let addCellHeight = UIScreen.main.bounds.height / 4
                let addCellWidth = UIScreen.main.bounds.width
                
                let firstCellAttributes = attributes[0]
                let secondCellAttributes = attributes[1]
                let thirdCellAttributes = attributes[2]
                let fourthCellAttributes = attributes[3]
                
                expect(firstCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: 0, width: cellWidth, height: smallCellHeight)))
                expect(secondCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth, y: 0, width: cellWidth, height: largeCellHeight)))
                expect(thirdCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: smallCellHeight, width: cellWidth, height: smallCellHeight)))
                expect(fourthCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: largeCellHeight, width: addCellWidth, height: addCellHeight)))
            }
            
            it("should have valid content paddings") {
                let items = ["1", "2", "3", "4"]
                let hPadding: CGFloat = 10
                let vPadding: CGFloat = 10
                let contentPadding = ItemsPadding(horizontal: hPadding, vertical: vPadding)
                
                let flickrFlowLayout = self.configureFlickrFlowLayout(contentPadding: contentPadding, items: items)
                let attributes = flickrFlowLayout.cachedLayoutAttributes
                
                let smallCellHeight: CGFloat = (UIScreen.main.bounds.height - 2 * contentPadding.vertical) / 5
                let largeCellHeight: CGFloat = smallCellHeight * 2
                let cellWidth = (UIScreen.main.bounds.width - 2 * contentPadding.horizontal) / 2
                let addCellHeight = (UIScreen.main.bounds.height - 2 * contentPadding.vertical) / 4
                let addCellWidth = UIScreen.main.bounds.width - 2 * contentPadding.vertical
                
                let firstCellAttributes = attributes[0]
                let secondCellAttributes = attributes[1]
                let thirdCellAttributes = attributes[2]
                let fourthCellAttributes = attributes[3]
                
                expect(firstCellAttributes.frame).to(beCloseTo(CGRect(x: hPadding, y: vPadding, width: cellWidth, height: smallCellHeight)))
                expect(secondCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth + hPadding, y: vPadding, width: cellWidth, height: largeCellHeight)))
                expect(thirdCellAttributes.frame).to(beCloseTo(CGRect(x: hPadding, y: smallCellHeight + vPadding, width: cellWidth, height: smallCellHeight)))
                expect(fourthCellAttributes.frame).to(beCloseTo(CGRect(x: hPadding, y: largeCellHeight + vPadding, width: addCellWidth, height: addCellHeight)))
            }
            
            it("should have valid cells paddings") {
                let items = ["1", "2", "3", "4"]
                let hPadding: CGFloat = 10
                let vPadding: CGFloat = 10
                let cellsPadding = ItemsPadding(horizontal: hPadding, vertical: vPadding)
                
                let flickrFlowLayout = self.configureFlickrFlowLayout(cellsPadding: cellsPadding, items: items)
                let attributes = flickrFlowLayout.cachedLayoutAttributes
                
                let smallCellHeight: CGFloat = (UIScreen.main.bounds.height - cellsPadding.vertical) / 5
                let largeCellHeight: CGFloat = smallCellHeight * 2 + cellsPadding.vertical
                let cellWidth = (UIScreen.main.bounds.width - cellsPadding.horizontal) / 2
                let addCellHeight = (UIScreen.main.bounds.height - cellsPadding.vertical) / 4
                let addCellWidth = UIScreen.main.bounds.width
                
                let firstCellAttributes = attributes[0]
                let secondCellAttributes = attributes[1]
                let thirdCellAttributes = attributes[2]
                let fourthCellAttributes = attributes[3]
                
                expect(firstCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: 0, width: cellWidth, height: smallCellHeight)))
                expect(secondCellAttributes.frame).to(beCloseTo(CGRect(x: cellWidth + cellsPadding.horizontal, y: 0, width: cellWidth, height: largeCellHeight)))
                expect(thirdCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: smallCellHeight + cellsPadding.vertical, width: cellWidth, height: smallCellHeight)))
                expect(fourthCellAttributes.frame).to(beCloseTo(CGRect(x: 0, y: largeCellHeight + cellsPadding.vertical, width: addCellWidth, height: addCellHeight)))
            }
        }
    }
    
    private func configureFlickrFlowLayout(contentPadding: ItemsPadding = ItemsPadding(), cellsPadding: ItemsPadding = ItemsPadding(), align: DynamicContentAlign = .left, items: [String]) -> FlickrStyleFlowLayout {
        let flowDelegate = FlickrFlowDelegateMock(items: items)
        let flickrFlowLayout = FlickrStyleFlowLayout()
        flickrFlowLayout.delegate = flowDelegate
        
        flickrFlowLayout.contentPadding = contentPadding
        flickrFlowLayout.cellsPadding = cellsPadding
        flickrFlowLayout.contentAlign = align
        
        let dataSource = ContentDataSource()
        dataSource.items = items
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: flickrFlowLayout)
        collectionView.dataSource = dataSource
        
        flickrFlowLayout.calculateCollectionViewCellsFrames()
        
        expect(flickrFlowLayout.collectionView).notTo(beNil())
        
        _ = flowDelegate.cellSize(indexPath: IndexPath(row: 0, section: 0))
        expect(flowDelegate.isCellSizeWasCalled).to(beTrue())
        
        expect(flickrFlowLayout.delegate).notTo(beNil())
        expect(flickrFlowLayout.delegate).to(beAKindOf(ContentDynamicLayoutDelegate.self))
        
        return flickrFlowLayout
    }
}
