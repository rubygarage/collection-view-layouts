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
