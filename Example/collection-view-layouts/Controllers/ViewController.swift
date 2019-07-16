//
//  ViewController.swift
//  CollectionDemoApp
//
//  Created by sergey on 2/22/18.
//  Copyright © 2018 rubygarage. All rights reserved.
//

import UIKit
import collection_view_layouts

enum LayoutType: Int {
    case tags
    case pinterest
    case px500
    case instagram
    case flipboard
    case facebook
    case flickr
}

class ViewController: UIViewController, PickerViewProviderDelegate, LayoutDelegate {
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    @IBOutlet private(set) weak var pickerView: UIPickerView!

    private let pickerViewProvider = PickerViewProvider()
    private let collectionViewProvider = CollectionViewProvider()

    private var cellSizes = [[CGSize]]()
    private var layout: BaseLayout!

    // MARK: - View controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickerView()
        setupCollectionView()

        prepareCellSizes(withType: .tags)
        showLayout(withType: .tags)
    }

    // MARK: - Setup
    
    private func setupPickerView() {
        pickerView.dataSource = pickerViewProvider
        pickerView.delegate = pickerViewProvider

        pickerViewProvider.delegate = self
        pickerViewProvider.items = ["Tags", "Pinterest", "500px", "Instagram", "Flipboard", "Facebook", "Flickr"]
    }

    private func setupCollectionView() {
        collectionView.dataSource = collectionViewProvider

        let firstSectionItems = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
                                 "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen",
                                 "eighteen", "nineteen", "twenty"]

        let secondSectionItems = ["activity", "appstore", "calculator", "camera", "contacts", "clock", "facetime",
                                 "health", "mail", "messages", "music", "notes", "phone", "photos", "podcasts",
                                 "reminders", "safari", "settings", "shortcuts", "testflight", "wallet", "watch",
                                 "weather"]


        collectionViewProvider.items = [firstSectionItems, secondSectionItems]
        collectionViewProvider.supplementaryItems = ["numbers", "apps"]
    }

    private func prepareCellSizes(withType type: LayoutType) {
        let range = 50...150
        cellSizes.removeAll()

        collectionViewProvider.items.forEach { items in
            let sizes = items.map { item -> CGSize in
                switch type {
                case .tags:
                    let width = Double(self.collectionView.bounds.width)
                    var size = UIFont.systemFont(ofSize: 17).sizeOfString(string: item, constrainedToWidth: width)
                    size.width += 30
                    size.height += 20
                    return size
                case .pinterest:
                    let height = CGFloat(Int.random(in: range))
                    return CGSize(width: 0.1, height: height)
                case .px500:
                    let width = CGFloat(Int.random(in: range))
                    let height = CGFloat(Int.random(in: range))
                    return CGSize(width: width, height: height)
                default:
                    return CGSize(width: 0.1, height: 0.1)
                }
            }

            cellSizes.append(sizes)
        }
    }

    private func showLayout(withType type: LayoutType) {
        switch type {
        case .tags:
            layout = TagsLayout()
            // Tags layout supports next configs
            // layout.contentAlign = .right
            // layout.scrollDirection = .horizontal
        case .pinterest:
            layout = PinterestLayout()
            // Pinterest layout supports next configs
            // layout.columnsCount = 3
        case .px500:
            layout = Px500Layout()
            // 500px layout supports next configs
            // layout.minCellsInRow = .two
            // layout.maxCellsInRow = .two
            // layout.visibleRowsCount = 6
        case .instagram:
            layout = InstagramLayout()
            // Instagram layout supports next configs
            // layout.gridType = .onePreviewCell
        case .flipboard:
            layout = FlipboardLayout()
            // Flipboard layout supports next configs
            // layout.contentAlign = .right
        case .facebook:
            layout = FacebookLayout()
        case .flickr:
            layout = FlickrLayout()
        }

        layout.delegate = self

        // All layouts support this configs
        layout.contentPadding = ItemsPadding(horizontal: 15, vertical: 15)
        layout.cellsPadding = ItemsPadding(horizontal: 10, vertical: 10)

        collectionView.collectionViewLayout = layout
        collectionView.setContentOffset(CGPoint.zero, animated: false)
        collectionView.reloadData()
    }

    // MARK: - PickerViewProviderDelegate

    func provider(_ provider: PickerViewProvider, didSelect row: Int) {
        if let type = LayoutType(rawValue: row) {
            prepareCellSizes(withType: type)
            showLayout(withType: type)
        }
    }

    // MARK: - LayoutDelegate

    func cellSize(indexPath: IndexPath) -> CGSize {
        return cellSizes[indexPath.section][indexPath.row]
    }

    func headerHeight(indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func footerHeight(indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
