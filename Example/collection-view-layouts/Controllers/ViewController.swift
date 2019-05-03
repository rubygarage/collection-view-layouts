//
//  ViewController.swift
//  CollectionDemoApp
//
//  Created by sergey on 2/22/18.
//  Copyright © 2018 rubygarage. All rights reserved.
//

import UIKit
import collection_view_layouts

private let fontSize: CGFloat = 17
private let tagsPadding: CGFloat = 15
private let minCellSize = 50
private let maxCellSize = 150
private let contentPadding: CGFloat = 10
private let cellsPadding: CGFloat = 8

class ViewController: UIViewController, PickerViewProviderDelegate, ContentDynamicLayoutDelegate {
    @IBOutlet private(set) weak var collectionView: UICollectionView!
    @IBOutlet private(set) weak var pickerView: UIPickerView!

    private let pickerViewProvider = PickerViewProvider()
    private let collectionViewProvider = CollectionViewProvider()

    private var cellSizes = [CGSize]()
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
        pickerViewProvider.insert(Items.forPickerView)
    }

    private func setupCollectionView() {
        collectionView.dataSource = collectionViewProvider

        collectionViewProvider.insert(Items.forCollectionView)
    }

    private func prepareCellSizes(withType type: LayoutType) {
        cellSizes = Items.forCollectionView.map {
            switch type {
            case .tags:
                let width = Double(collectionView.bounds.width)
                var size = UIFont.systemFont(ofSize: fontSize).sizeOfString(string: $0, constrainedToWidth: width)
                size.width += tagsPadding
                size.height += tagsPadding
                return size
            case .pinterest:
                let height = CGFloat(Int.random(in: minCellSize...maxCellSize))
                return CGSize(width: 0.1, height: height)
            case .px500:
                let width = CGFloat(Int.random(in: minCellSize...maxCellSize))
                let height = CGFloat(Int.random(in: minCellSize...maxCellSize))
                return CGSize(width: width, height: height)
            default:
                return CGSize(width: 0.1, height: 0.1)
            }
        }
    }

    private func showLayout(withType type: LayoutType) {
        switch type {
        case .tags:
            contentDynamicLayout = TagsLayout()
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
        case .flipboard:
            contentDynamicLayout = FlipboardLayout()
        case .facebook:
            contentDynamicLayout = FacebookLayout()
        case .flickr:
            contentDynamicLayout = FlickrLayout()
        }

        contentDynamicLayout.delegate = self
        contentDynamicLayout.contentAlign = .right
        contentDynamicLayout.contentPadding = ItemsPadding(horizontal: contentPadding, vertical: contentPadding)
        contentDynamicLayout.cellsPadding = ItemsPadding(horizontal: cellsPadding, vertical: cellsPadding)

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
        return cellSizes[indexPath.row]
    }
}
