//
//  InstagramStyleBaseDelegateMock.swift
//  collection-view-layouts_Example
//
//  Created by sergey on 3/27/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import collection_view_layouts

class InstagramStyleBaseDelegateMock: ContentDynamicLayoutDelegate {
    public var isCellSizeWasCalled = false
    private var cellSizes = [CGSize]()

    init(items: [String]) {
        cellSizes = CellSizeProvider.provideSizes(items: items, flowType: .instagram)
    }
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        return cellSizes[indexPath.row]
    }
}
