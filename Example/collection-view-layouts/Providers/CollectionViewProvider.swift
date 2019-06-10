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
    private var items = [[String]]()

    func insert(_ items: [String], inSection section: Int = 0) {
        self.items.insert(items, at: section)
    }

    // MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)

        if let cell = cell as? ContentCell {
            let item = items[indexPath.section][indexPath.row]
            cell.populate(with: item)

            // TODO: Remove it
            if indexPath.section == 1 {
                cell.backgroundColor = .gray
            }
        }
        
        return cell
    }
}
