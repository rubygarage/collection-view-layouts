//
//  FacebookFlowDelegateMock.swift
//  collection-view-layouts_Tests
//
//  Created by sergey on 4/10/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import collection_view_layouts

class FacebookFlowDelegateMock: ContentDynamicLayoutDelegate {
    private var items = [String]()
    private var cellSizes = [CGSize]()
    
    public var isCellSizeWasCalled = false
    
    init(items: [String]) {
        self.items = items
        
        cellSizes = CellSizeProvider.provideSizes(items: items, flowType: .facebook)
    }
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        isCellSizeWasCalled = true
        
        return cellSizes[indexPath.row]
    }
}


