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

class ViewController: UIViewController, PickerViewProviderDelegate, ContentDynamicLayoutDelegate {
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    @IBOutlet private(set) weak var pickerView: UIPickerView!

    private let pickerViewProvider = PickerViewProvider()
    private let collectionViewProvider = CollectionViewProvider()

    private var cellSizes = [[CGSize]]()
    private var contentDynamicLayout: ContentDynamicLayout!

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
            contentDynamicLayout = TagsLayout()
            if let tagsLayout = contentDynamicLayout as? TagsLayout {
                tagsLayout.scrollDirection = .horizontal
            }
        case .pinterest:
            contentDynamicLayout = PinterestLayout()
            if let pinterestLayout = contentDynamicLayout as? PinterestLayout {
                pinterestLayout.columnsCount = 3
            }
        case .px500:
            contentDynamicLayout = Px500Layout()
            if let px500Layout = contentDynamicLayout as? Px500Layout {
                px500Layout.minCellsInRow = .two
                px500Layout.maxCellsInRow = .two
                px500Layout.visibleRowsCount = 6
            }
        case .instagram:
            contentDynamicLayout = InstagramLayout()
            if let instagramLayout = contentDynamicLayout as? InstagramLayout {
                instagramLayout.gridType = .onePreviewCell
            }
        case .flipboard:
            contentDynamicLayout = FlipboardLayout()
        case .facebook:
            contentDynamicLayout = FacebookLayout()
        case .flickr:
            contentDynamicLayout = FlickrLayout()
        }

        contentDynamicLayout.delegate = self
        contentDynamicLayout.contentAlign = .right
        contentDynamicLayout.contentPadding = ItemsPadding(horizontal: 10, vertical: 10)
        contentDynamicLayout.cellsPadding = ItemsPadding(horizontal: 8, vertical: 8)

        collectionView.collectionViewLayout = contentDynamicLayout
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

    // MARK: - ContentDynamicLayoutDelegate

    func cellSize(indexPath: IndexPath) -> CGSize {
        return cellSizes[indexPath.section][indexPath.row]
    }

    func headerHeight(indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
