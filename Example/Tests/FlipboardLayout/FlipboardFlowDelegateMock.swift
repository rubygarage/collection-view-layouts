//
//  FlipboardStyleFlowLayout.swift
//  collection-view-layouts_Example
//
//  Created by sergey on 4/6/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import collection_view_layouts

class FlipboardFlowDelegateMock: ContentDynamicLayoutDelegate {
    private var items = [String]()
    private var cellSizes = [CGSize]()
    
    public var isCellSizeWasCalled = false
    
    init(items: [String]) {
        self.items = items
        
        cellSizes = CellSizeProvider.provideSizes(items: items, flowType: .tags)
    }
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        isCellSizeWasCalled = true
        
        return cellSizes[indexPath.row]
    }
}

