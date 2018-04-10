//
//  FacebookStyleFlowLayout.swift
//  collection-view-layouts
//
//  Created by sergey on 4/10/18.
//

import UIKit

public class FacebookStyleFlowLayout: ContentDynamicLayout {
    private let kColumnsCount: Int = 3
    private let kCellsInSection: Int = 8
    
    override public func calculateCollectionViewCellsFrames() {
        guard let contentCollectionView = collectionView, delegate != nil else {
            return
        }
        
        contentSize.width = contentCollectionView.frame.size.width
        
        var yOffset: CGFloat = contentPadding.vertical
        
        let cellWidth = (contentCollectionView.frame.size.width - 2 * (contentPadding.horizontal + cellsPadding.horizontal)) / CGFloat(kColumnsCount)
        let itemsCount = contentCollectionView.numberOfItems(inSection: 0)
        
        for item in 0 ..< itemsCount  {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            addCachedLayoutAttributes(attributes: attributes)
        }
    }
}
