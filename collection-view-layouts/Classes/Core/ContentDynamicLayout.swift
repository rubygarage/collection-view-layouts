//
//  ContentDynamicLayout.swift
//  collection-view-layouts
//
//  Created by sergey on 2/12/18.
//  Copyright © 2018 rubygarage. All rights reserved.
//

import UIKit

public protocol ContentDynamicLayoutDelegate: class {
    func cellSize(indexPath: IndexPath) -> CGSize
}

public enum DynamicContentAlign {
    case left
    case right
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

public class ContentDynamicLayout: UICollectionViewFlowLayout {
    public private(set) var cachedLayoutAttributes = [UICollectionViewLayoutAttributes]()
    
    public var contentAlign: DynamicContentAlign = .left
    public var contentPadding: ItemsPadding = .zero
    public var cellsPadding: ItemsPadding = .zero
    public var contentSize: CGSize = .zero
    public weak var delegate: ContentDynamicLayoutDelegate?

    public var contentWidthWithoutPadding: CGFloat {
        return contentSize.width - 2 * contentPadding.horizontal
    }

    // MARK: - UICollectionViewFlowLayout

    override public func prepare() {
        super.prepare()

        cachedLayoutAttributes.removeAll()
        calculateCollectionViewCellsFrames()
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedLayoutAttributes.filter { $0.frame.intersects(rect) }
    }

    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedLayoutAttributes.first { $0.indexPath == indexPath }
    }

    override public var collectionViewContentSize: CGSize {
        return contentSize
    }

    // MARK: - Methods for subclasses

    func calculateCollectionViewCellsFrames() {
        fatalError("Method must be overriden")
    }
    
    func addCachedLayoutAttributes(attributes: UICollectionViewLayoutAttributes) {
        cachedLayoutAttributes.append(attributes)
    }
}
