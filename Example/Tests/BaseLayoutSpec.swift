//
//  BaseLayoutSpec.swift
//  collection-view-layouts_Tests
//
//  Created by Radyslav Krechet on 6/13/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble

@testable import collection_view_layouts

class BaseLayoutSpec: QuickSpec {
    override func spec() {
        describe("Base layout") {
            var layout: BaseLayout!

            beforeEach {
                layout = BaseLayout()
            }

            it("should have valid stored properties") {
                expect(layout.contentPadding).to(beAKindOf(ItemsPadding.self))
                expect(layout.contentPadding.horizontal) == 0
                expect(layout.contentPadding.vertical) == 0

                expect(layout.cellsPadding).to(beAKindOf(ItemsPadding.self))
                expect(layout.cellsPadding.horizontal) == 0
                expect(layout.cellsPadding.vertical) == 0

                expect(layout.delegate).to(beNil())

                expect(layout.cachedAttributes).to(beAKindOf([UICollectionViewLayoutAttributes].self))
                expect(layout.cachedAttributes).to(beEmpty())

                expect(layout.contentSize).to(beAKindOf(CGSize.self))
                expect(layout.contentSize) == .zero
            }

            it("should have valid computed properties") {
                expect(layout.contentWidthWithoutPadding).to(beAKindOf(CGFloat.self))
                expect(layout.contentWidthWithoutPadding) == 0

                expect(layout.collectionViewContentSize).to(beAKindOf(CGSize.self))
                expect(layout.collectionViewContentSize) == .zero

                let contentHorizontalPadding = CGFloat(15)
                layout.contentPadding = ItemsPadding(horizontal: contentHorizontalPadding, vertical: 0)

                let width = CGFloat(320)
                let height = CGFloat(568)
                layout.contentSize = CGSize(width: width, height: height)

                expect(layout.contentWidthWithoutPadding) == width - 2 * contentHorizontalPadding
                expect(layout.collectionViewContentSize) == layout.contentSize
            }

            it("should return attributes in rect") {
                let side = CGFloat(5)

                let rectPoiny = side - 1
                let rect = CGRect(x: rectPoiny, y: rectPoiny, width: side, height: side)

                let attributesInRect = UICollectionViewLayoutAttributes()
                attributesInRect.frame = CGRect(x: 0, y: 0, width: side, height: side)

                let outOfRectPoint = side * 2
                let attributesOutOfRect = UICollectionViewLayoutAttributes()
                attributesOutOfRect.frame = CGRect(x: outOfRectPoint, y: outOfRectPoint, width: side, height: side)

                layout.cachedAttributes = [attributesInRect, attributesOutOfRect]
                let attributes = layout.layoutAttributesForElements(in: rect)

                expect(attributes).to(contain(attributesInRect))
            }

            describe("should add attributes for supplementary view") {
                context("when layout does not have delegate") {
                    it("can not add attributes") {
                        var yOffset = CGFloat(15)
                        layout.addAttributesForSupplementaryView(ofKind: "kind", section: 0, yOffset: &yOffset)

                        expect(layout.cachedAttributes).to(beEmpty())
                    }
                }

                context("when layout has delegate without implemented methods") {
                    it("can not add attributes") {
                        let delegate = BaseLayoutDelegate()
                        layout.delegate = delegate

                        var yOffset = CGFloat(15)
                        layout.addAttributesForSupplementaryView(ofKind: "kind", section: 0, yOffset: &yOffset)

                        expect(layout.cachedAttributes).to(beEmpty())
                    }
                }

                context("when layout has delegate with height methods only") {
                    it("adds attributes") {
                        let delegate = HeightLayoutDelegate()
                        layout.delegate = delegate

                        let contentHorizontalPadding = CGFloat(15)
                        layout.contentPadding = ItemsPadding(horizontal: contentHorizontalPadding, vertical: 15)
                        layout.cellsPadding = ItemsPadding(horizontal: 10, vertical: 10)
                        layout.contentSize = CGSize(width: 320, height: 568)

                        let section = 0
                        let originalYOffset = CGFloat(15)
                        var yOffset = originalYOffset
                        layout.addAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                 section: section,
                                                                 yOffset: &yOffset)

                        let attributes = layout.cachedAttributes.first!
                        let headerHeight = delegate.headerHeight(indexPath: attributes.indexPath)

                        expect(layout.cachedAttributes.count) == 1
                        expect(attributes.representedElementKind!) == UICollectionView.elementKindSectionHeader
                        expect(attributes.indexPath.section) == section
                        expect(attributes.frame) == CGRect(x: contentHorizontalPadding,
                                                           y: originalYOffset,
                                                           width: layout.contentWidthWithoutPadding,
                                                           height: headerHeight)

                        expect(yOffset) == originalYOffset + headerHeight + layout.cellsPadding.vertical
                    }
                }

                context("when layout has delegate with all methods") {
                    it("adds attributes") {
                        let delegate = HeightWidthLayoutDelegate()
                        layout.delegate = delegate
                        layout.contentPadding = ItemsPadding(horizontal: 15, vertical: 15)
                        layout.cellsPadding = ItemsPadding(horizontal: 10, vertical: 10)
                        layout.contentSize = CGSize(width: 320, height: 568)

                        let section = 0
                        let originalYOffset = CGFloat(15)
                        var yOffset = originalYOffset
                        layout.addAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                 section: section,
                                                                 yOffset: &yOffset)

                        let attributes = layout.cachedAttributes.first!
                        let footerHeight = delegate.footerHeight(indexPath: attributes.indexPath)
                        let footerWidth = delegate.footerWidth(indexPath: attributes.indexPath)

                        expect(layout.cachedAttributes.count) == 1
                        expect(attributes.representedElementKind!) == UICollectionView.elementKindSectionFooter
                        expect(attributes.indexPath.section) == section
                        expect(attributes.frame) == CGRect(x: layout.contentSize.width / 2 - footerWidth / 2,
                                                           y: originalYOffset,
                                                           width: footerWidth,
                                                           height: footerHeight)

                        expect(yOffset) == originalYOffset + footerHeight + layout.cellsPadding.vertical
                    }
                }
            }
        }

        describe("Custom layout") {
            var layout: CustomLayout!

            beforeEach {
                layout = CustomLayout()
            }

            it("should make preparations") {
                let attributes = UICollectionViewLayoutAttributes()
                layout.cachedAttributes = [attributes]
                layout.prepare()

                expect(layout.cachedAttributes).to(beEmpty())
                expect(layout.calledFunctions).to(contain("calculateCollectionViewFrames"))
            }

            it("should add attributes for supplementary view") {
                var yOffsets: [CGFloat] = [15, 10, 10]
                layout.addAttributesForSupplementaryView(ofKind: "kind", section: 0, yOffsets: &yOffsets)

                expect(layout.calledFunctions).to(contain("addAttributesForSupplementaryView"))
                expect(yOffsets) == [15, 15, 15]
            }
        }
    }
}

class BaseLayoutDelegate: LayoutDelegate {
    func cellSize(indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
}

class HeightLayoutDelegate: BaseLayoutDelegate {
    func headerHeight(indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

class HeightWidthLayoutDelegate: HeightLayoutDelegate {
    func footerHeight(indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func footerWidth(indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

class CustomLayout: BaseLayout {
    var calledFunctions = [String]()

    override func calculateCollectionViewFrames() {
        calledFunctions.append("calculateCollectionViewFrames")
    }

    override func addAttributesForSupplementaryView(ofKind kind: String, section: Int, yOffset: inout CGFloat) {
        calledFunctions.append("addAttributesForSupplementaryView")
    }
}
