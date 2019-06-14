//
//  BaseLayout.swift
//  collection-view-layouts
//
//  Created by sergey on 2/12/18.
//  Copyright © 2018 rubygarage. All rights reserved.
//

import UIKit

@objc public protocol LayoutDelegate: class {
    func cellSize(indexPath: IndexPath) -> CGSize
    @objc optional func headerHeight(indexPath: IndexPath) -> CGFloat
    @objc optional func headerWidth(indexPath: IndexPath) -> CGFloat
    @objc optional func footerHeight(indexPath: IndexPath) -> CGFloat
    @objc optional func footerWidth(indexPath: IndexPath) -> CGFloat
}

public struct ItemsPadding {
    public let horizontal: CGFloat
    public let vertical: CGFloat
    
    public init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
    
    static var zero: ItemsPadding {
        return ItemsPadding()
    }
}

public class BaseLayout: UICollectionViewLayout {
    public var contentPadding: ItemsPadding = .zero
    public var cellsPadding: ItemsPadding = .zero

    public weak var delegate: LayoutDelegate?

    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    var contentSize: CGSize = .zero

    var contentWidthWithoutPadding: CGFloat {
        return contentSize.width - 2 * contentPadding.horizontal
    }

    // MARK: - UICollectionViewFlowLayout

    override public var collectionViewContentSize: CGSize {
        return contentSize
    }

    override public func prepare() {
        super.prepare()

        cachedAttributes.removeAll()
        calculateCollectionViewFrames()
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes.filter { $0.frame.intersects(rect) }
    }

    // MARK: - Methods for subclasses

    func calculateCollectionViewFrames() {
        fatalError("Method must be overriden")
    }

    func addAttributesForSupplementaryView(ofKind kind: String, section: Int, yOffset: inout CGFloat) {
        guard let delegate = delegate else {
            return
        }

        let indexPath = IndexPath(item: 0, section: section)
        var delegateHeight: CGFloat?
        var delegateWidth: CGFloat?

        if kind == UICollectionView.elementKindSectionHeader {
            delegateHeight = delegate.headerHeight?(indexPath: indexPath)
            delegateWidth = delegate.headerWidth?(indexPath: indexPath)
        } else if kind == UICollectionView.elementKindSectionFooter {
            delegateHeight = delegate.footerHeight?(indexPath: indexPath)
            delegateWidth = delegate.footerWidth?(indexPath: indexPath)
        }

        guard let height = delegateHeight, height > 0 else {
            return
        }

        let x = delegateWidth == nil ? contentPadding.horizontal : contentSize.width / 2 - delegateWidth! / 2
        let origin = CGPoint(x: x, y: yOffset)
        let width = delegateWidth ?? contentWidthWithoutPadding
        let size = CGSize(width: width, height: height)

        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
        attributes.frame = CGRect(origin: origin, size: size)
        cachedAttributes.append(attributes)

        yOffset += height + cellsPadding.vertical
    }

    func addAttributesForSupplementaryView(ofKind kind: String, section: Int, yOffsets: inout [CGFloat]) {
        addAttributesForSupplementaryView(ofKind: kind, section: section, yOffset: &yOffsets[0])

        let y = yOffsets[0]
        for index in 0..<yOffsets.count {
            yOffsets[index] = y
        }
    }
}
