//
//  CollectionViewDataSource.swift
//  CollectionDemoApp
//
//  Created by sergey on 2/23/18.
//  Copyright © 2018 rubygarage. All rights reserved.
//

import UIKit

class ContentDataSource: NSObject, UICollectionViewDataSource {
    private let kContenCellIdentifier = "ContentCellIdentifier"
    
    public var items = [String]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContenCellIdentifier, for: indexPath)
        (cell as! ContentCell).configureCell(item: items[indexPath.row])
        
        return cell
    }
}
