//
//  FlipboardStyleFlowLayout.swift
//  collection-view-layouts
//
//  Created by sergey on 4/4/18.
//

import UIKit

public class FlipboardStyleFlowLayout: ContentDynamicLayout {
    private let kColumnsCount: Int = 3
    private let kRowsCountInDefaultSection: Int = 2
    
    override public func calculateCollectionViewCellsFrames() {
        guard collectionView != nil, delegate != nil else {
            return
        }
        
       
    }
}
