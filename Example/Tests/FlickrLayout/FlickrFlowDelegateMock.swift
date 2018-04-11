//
//  FlickrFlowDelegateMock.swift
//  collection-view-layouts_Tests
//
//  Created by jowkame on 4/11/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import collection_view_layouts

class FlickrFlowDelegateMock: ContentDynamicLayoutDelegate {
    private var items = [String]()
    private var cellSizes = [CGSize]()
    
    public var isCellSizeWasCalled = false
    
    init(items: [String]) {
        self.items = items
        
        cellSizes = CellSizeProvider.provideSizes(items: items, flowType: .flickr)
    }
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        isCellSizeWasCalled = true
        
        return cellSizes[indexPath.row]
    }
}
