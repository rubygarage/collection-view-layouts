//
//  CollectionViewProvider.swift
//  CollectionDemoApp
//
//  Created by sergey on 2/23/18.
//  Copyright © 2018 rubygarage. All rights reserved.
//

import UIKit

private let cellIdentifier = "ContentCellIdentifier"

class CollectionViewProvider: NSObject, UICollectionViewDataSource {
    private var items = [String]()

    func insert(_ items: [String]) {
        self.items += items
    }

    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)

        if let cell = cell as? ContentCell {
            let item = items[indexPath.row]
            cell.populate(with: item)
        }
        
        return cell
    }
}
