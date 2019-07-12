//
//  PinterestLayoutSpec.swift
//  collection-view-layouts_Example
//
//  Created by Radyslav Krechet on 7/12/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble

@testable import collection_view_layouts

class PinterestLayoutSpec: QuickSpec {
    override func spec() {
        describe("Pinterest layout") {
            var layout: PinterestLayoutMock!

            beforeEach {
                layout = PinterestLayoutMock()
            }

            it("should have valid stored properties") {
                expect(layout.columnsCount).to(beAKindOf(Int.self))
                expect(layout.columnsCount) == 2
            }

            describe("should calculate frames") {
                context("when layout does not have collection view and delegate") {
                    it("can not add attributes") {
                        layout.calculateCollectionViewFrames()

                        expect(layout.cachedAttributes).to(beEmpty())
                        expect(layout.calledFunctions).to(beEmpty())
                    }
                }

                context("when layout has collection view and delegate") {
                    it("adds attributes") {
                        layout.contentPadding = ItemsPadding(horizontal: 15, vertical: 15)
                        layout.cellsPadding = ItemsPadding(horizontal: 10, vertical: 10)

                        let items = ["one", "two", "three", "four"]
                        let supplementaryItems = ["numbers"]
                        let collectionViewProvider = CollectionViewProvider()
                        collectionViewProvider.items = [items]
                        collectionViewProvider.supplementaryItems = supplementaryItems

                        let frame = CGRect(x: 0, y: 0, width: 320, height: 568)
                        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
                        collectionView.dataSource = collectionViewProvider

                        let delegate = PinterestLayoutDelegate()
                        layout.delegate = delegate

                        layout.calculateCollectionViewFrames()

                        expect(layout.cachedAttributes.count) == items.count
                        expect(layout.calledFunctions.count) == supplementaryItems.count * 2

                        let cellsPaddingWidth = CGFloat(layout.columnsCount - 1) * layout.cellsPadding.vertical
                        let cellWidth = (layout.contentWidthWithoutPadding - cellsPaddingWidth)
                            / CGFloat(layout.columnsCount)

                        let firstCellHeight = delegate.heights[0]

                        let firstCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                    y: layout.contentPadding.vertical,
                                                    width: cellWidth,
                                                    height: firstCellHeight)

                        let secondColumnX = layout.contentPadding.horizontal
                            + (cellWidth + layout.cellsPadding.vertical) * CGFloat(layout.columnsCount - 1)

                        let secondCellHeight = delegate.heights[1]

                        let secondCellFrame = CGRect(x: secondColumnX,
                                                     y: layout.contentPadding.vertical,
                                                     width: cellWidth,
                                                     height: secondCellHeight)

                        let thirdCellY = layout.contentPadding.vertical + firstCellHeight
                            + layout.cellsPadding.horizontal

                        let thirdCellHeight = delegate.heights[2]

                        let thirdCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                    y: thirdCellY,
                                                    width: cellWidth,
                                                    height: thirdCellHeight)

                        let fourthCellY = layout.contentPadding.vertical + secondCellHeight
                            + layout.cellsPadding.horizontal

                        let fourthCellHeight = delegate.heights[3]

                        let fourthCellFrame = CGRect(x: secondColumnX,
                                                     y: fourthCellY,
                                                     width: cellWidth,
                                                     height: fourthCellHeight)

                        let cellsFrames = [firstCellFrame, secondCellFrame, thirdCellFrame, fourthCellFrame]

                        for index in 0..<layout.cachedAttributes.count {
                            expect(layout.cachedAttributes[index].frame).to(beCloseTo(cellsFrames[index]))
                        }

                        let height = fourthCellY + fourthCellHeight + layout.contentPadding.vertical
                        expect(layout.contentSize) == CGSize(width: frame.size.width, height: height)
                    }
                }
            }
        }
    }
}

class PinterestLayoutMock: PinterestLayout {
    var calledFunctions = [String]()

    override func addAttributesForSupplementaryView(ofKind kind: String, section: Int, yOffset: inout CGFloat) {
        calledFunctions.append("addAttributesForSupplementaryView")
    }
}

class PinterestLayoutDelegate: NSObject, LayoutDelegate {
    let heights: [CGFloat] = [60, 120, 80, 100]

    func cellSize(indexPath: IndexPath) -> CGSize {
        let height = heights[indexPath.row]
        return CGSize(width: 0.1, height: height)
    }
}
