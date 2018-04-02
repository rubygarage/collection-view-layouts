//
//  500pxStyleDelegateMock.swift
//  collection-view-layouts_Example
//
//  Created by sergey on 3/19/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import collection_view_layouts

class Px500FlowDelegateMock: ContentDynamicLayoutDelegate {
    private var items = [String]()
    private var cellSizes = [CGSize]()
    
    public var isCellSizeWasCalled = false
    
    init(items: [String]) {
        self.items = items
        
        cellSizes = CellSizeProvider.provideSizes(items: items, flowType: .px500)
    }
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        isCellSizeWasCalled = true
        
        return (indexPath.row < items.count) ? cellSizes[indexPath.row] : .zero
    }
}

