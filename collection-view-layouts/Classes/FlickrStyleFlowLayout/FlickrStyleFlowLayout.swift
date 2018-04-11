//
//  FlickrStyleFlowLayout.swift
//  collection-view-layouts
//
//  Created by sergey on 4/11/18.
//

import UIKit

public class FlickrStyleFlowLayout: ContentDynamicLayout {
    private let kCellsInSection: Int = 5
    private let kLargeColumnsCount: Int = 2
    private let kSmallColumnsCount: Int = 3
    
    override public func calculateCollectionViewCellsFrames() {
        guard let contentCollectionView = collectionView, delegate != nil else {
            return
        }
        
        contentSize.width = contentCollectionView.frame.size.width
        
        let itemsCount = contentCollectionView.numberOfItems(inSection: 0)
        
        for item in 0 ..< itemsCount  {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            addCachedLayoutAttributes(attributes: attributes)
        }
    }
}
