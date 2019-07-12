//
//  TagsLayoutSpec.swift
//  collection-view-layouts_Tests
//
//  Created by Radyslav Krechet on 7/12/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble

@testable import collection_view_layouts

class TagsLayoutSpec: QuickSpec {
    override func spec() {
        describe("Tags layout") {
            var layout: TagsLayoutMock!

            beforeEach {
                layout = TagsLayoutMock()
            }

            it("should have valid stored properties") {
                expect(layout.scrollDirection).to(beAKindOf(ScrollDirection.self))
                expect(layout.scrollDirection) == .vertical
            }

            describe("should calculate frames") {
                context("when layout does not have collection view and delegate") {
                    it("can not add attributes") {
                        layout.scrollDirection = .vertical
                        layout.calculateCollectionViewFrames()

                        expect(layout.cachedAttributes).to(beEmpty())
                        expect(layout.calledFunctions).to(beEmpty())

                        layout.scrollDirection = .horizontal
                        layout.calculateCollectionViewFrames()

                        expect(layout.cachedAttributes).to(beEmpty())
                        expect(layout.calledFunctions).to(beEmpty())
                    }
                }

                context("when layout has collection view and delegate and scroll direction is vertical") {
                    it("adds attributes for left content align") {
                        layout.contentPadding = ItemsPadding(horizontal: 15, vertical: 15)
                        layout.cellsPadding = ItemsPadding(horizontal: 10, vertical: 10)

                        let items = ["one", "two", "three"]
                        let supplementaryItems = ["numbers"]
                        let collectionViewProvider = CollectionViewProvider()
                        collectionViewProvider.items = [items]
                        collectionViewProvider.supplementaryItems = supplementaryItems

                        let frame = CGRect(x: 0, y: 0, width: 320, height: 568)
                        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
                        collectionView.dataSource = collectionViewProvider

                        let delegate = TagsLayoutDelegate()
                        layout.delegate = delegate

                        layout.calculateCollectionViewFrames()

                        expect(layout.cachedAttributes.count) == items.count
                        expect(layout.calledFunctions.count) == supplementaryItems.count * 2

                        let firstCellWidth = delegate.widths[0]

                        let firstCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                    y: layout.contentPadding.vertical,
                                                    width: firstCellWidth,
                                                    height: delegate.height)

                        let secondCellX = layout.contentPadding.horizontal + firstCellWidth
                            + layout.cellsPadding.vertical

                        let secondCellWidth = delegate.widths[1]

                        let secondCellFrame = CGRect(x: secondCellX,
                                                     y: layout.contentPadding.vertical,
                                                     width: secondCellWidth,
                                                     height: delegate.height)

                        let secondRowY = layout.contentPadding.vertical + delegate.height
                            + layout.cellsPadding.horizontal

                        let thirdCellWidth = delegate.widths[2]

                        let thirdCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                    y: secondRowY,
                                                    width: thirdCellWidth,
                                                    height: delegate.height)

                        let cellsFrames = [firstCellFrame, secondCellFrame, thirdCellFrame]

                        for index in 0..<layout.cachedAttributes.count {
                            expect(layout.cachedAttributes[index].frame).to(beCloseTo(cellsFrames[index]))
                        }

                        let height = secondRowY + delegate.height + layout.contentPadding.vertical
                        expect(layout.contentSize) == CGSize(width: frame.size.width, height: height)
                    }

                    it("adds attributes for right content align") {
                        layout.contentAlign = .right
                        layout.contentPadding = ItemsPadding(horizontal: 15, vertical: 15)
                        layout.cellsPadding = ItemsPadding(horizontal: 10, vertical: 10)

                        let items = ["one", "two", "three"]
                        let supplementaryItems = ["numbers"]
                        let collectionViewProvider = CollectionViewProvider()
                        collectionViewProvider.items = [items]
                        collectionViewProvider.supplementaryItems = supplementaryItems

                        let frame = CGRect(x: 0, y: 0, width: 320, height: 568)
                        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
                        collectionView.dataSource = collectionViewProvider

                        let delegate = TagsLayoutDelegate()
                        layout.delegate = delegate

                        layout.calculateCollectionViewFrames()

                        expect(layout.cachedAttributes.count) == items.count
                        expect(layout.calledFunctions.count) == supplementaryItems.count * 2

                        let firstCellWidth = delegate.widths[0]
                        let firstCellX = layout.contentSize.width - layout.contentPadding.horizontal - firstCellWidth

                        let firstCellFrame = CGRect(x: firstCellX,
                                                    y: layout.contentPadding.vertical,
                                                    width: firstCellWidth,
                                                    height: delegate.height)

                        let secondCellWidth = delegate.widths[1]
                        let secondCellX = firstCellX - secondCellWidth - layout.cellsPadding.vertical

                        let secondCellFrame = CGRect(x: secondCellX,
                                                     y: layout.contentPadding.vertical,
                                                     width: secondCellWidth,
                                                     height: delegate.height)

                        let secondRowY = layout.contentPadding.vertical + delegate.height
                            + layout.cellsPadding.horizontal

                        let thirdCellWidth = delegate.widths[2]
                        let thirdCellX = layout.contentSize.width - layout.contentPadding.horizontal - thirdCellWidth

                        let thirdCellFrame = CGRect(x: thirdCellX,
                                                    y: secondRowY,
                                                    width: thirdCellWidth,
                                                    height: delegate.height)

                        let cellsFrames = [firstCellFrame, secondCellFrame, thirdCellFrame]

                        for index in 0..<layout.cachedAttributes.count {
                            expect(layout.cachedAttributes[index].frame).to(beCloseTo(cellsFrames[index]))
                        }

                        let height = secondRowY + delegate.height + layout.contentPadding.vertical
                        expect(layout.contentSize) == CGSize(width: frame.size.width, height: height)
                    }
                }

                context("when layout has collection view and delegate and scroll direction is horizontal") {
                    it("adds attributes") {
                        layout.scrollDirection = .horizontal
                        layout.contentPadding = ItemsPadding(horizontal: 15, vertical: 15)
                        layout.cellsPadding = ItemsPadding(horizontal: 10, vertical: 10)

                        let items = ["one", "two", "three"]
                        let supplementaryItems = ["numbers"]
                        let collectionViewProvider = CollectionViewProvider()
                        collectionViewProvider.items = [items]
                        collectionViewProvider.supplementaryItems = supplementaryItems

                        let frame = CGRect(x: 0, y: 0, width: 568, height: 320)
                        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
                        collectionView.dataSource = collectionViewProvider

                        let delegate = TagsLayoutDelegate()
                        delegate.scrollDirection = .horizontal
                        layout.delegate = delegate

                        layout.calculateCollectionViewFrames()

                        expect(layout.cachedAttributes.count) == items.count
                        expect(layout.calledFunctions.count) == 0

                        let firstCellWidth = delegate.widths[0]

                        let firstCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                    y: layout.contentPadding.vertical,
                                                    width: firstCellWidth,
                                                    height: delegate.height)

                        let secondCellY = layout.contentPadding.vertical + delegate.height
                            + layout.cellsPadding.horizontal

                        let secondCellWidth = delegate.widths[1]

                        let secondCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                     y: secondCellY,
                                                     width: secondCellWidth,
                                                     height: delegate.height)

                        let thirdCellX = layout.contentPadding.horizontal + firstCellWidth
                            + layout.cellsPadding.horizontal

                        let thirdCellWidth = delegate.widths[2]

                        let thirdCellFrame = CGRect(x: thirdCellX,
                                                    y: layout.contentPadding.vertical,
                                                    width: thirdCellWidth,
                                                    height: delegate.height)

                        let cellsFrames = [firstCellFrame, secondCellFrame, thirdCellFrame]

                        for index in 0..<layout.cachedAttributes.count {
                            expect(layout.cachedAttributes[index].frame).to(beCloseTo(cellsFrames[index]))
                        }

                        let width = thirdCellX + thirdCellWidth + layout.contentPadding.horizontal
                        expect(layout.contentSize) == CGSize(width: width, height: frame.size.height)
                    }
                }
            }
        }
    }
}

class TagsLayoutMock: TagsLayout {
    var calledFunctions = [String]()

    override func addAttributesForSupplementaryView(ofKind kind: String, section: Int, yOffset: inout CGFloat) {
        calledFunctions.append("addAttributesForSupplementaryView")
    }
}

class TagsLayoutDelegate: NSObject, LayoutDelegate {
    let widths: [CGFloat] = [140, 120, 100]

    var scrollDirection = ScrollDirection.vertical

    var height: CGFloat {
        return scrollDirection == .vertical ? 50 : 125
    }

    func cellSize(indexPath: IndexPath) -> CGSize {
        let width = widths[indexPath.row]
        return CGSize(width: width, height: height)
    }
}
