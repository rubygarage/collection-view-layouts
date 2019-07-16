//
//  FlickrLayoutSpec.swift
//  collection-view-layouts_Tests
//
//  Created by Radyslav Krechet on 6/21/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble

@testable import collection_view_layouts

class FlickrLayoutSpec: QuickSpec {
    override func spec() {
        describe("Flickr layout") {
            var layout: FlickrLayoutMock!

            beforeEach {
                layout = FlickrLayoutMock()
            }

            describe("should calculate frames") {
                context("when layout does not have collection view") {
                    it("can not add attributes") {
                        layout.calculateCollectionViewFrames()

                        expect(layout.cachedAttributes).to(beEmpty())
                        expect(layout.calledFunctions).to(beEmpty())
                    }
                }

                context("when layout has collection view") {
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

                        layout.calculateCollectionViewFrames()

                        expect(layout.cachedAttributes.count) == items.count
                        expect(layout.calledFunctions.count) == supplementaryItems.count * 2

                        let heightWithoutPadding = collectionView.frame.height - 2 * layout.contentPadding.vertical
                            - layout.cellsPadding.vertical

                        let largeHorizontalCellHeight = heightWithoutPadding / CGFloat(4)
                        let smallHorizontalCellHeight = heightWithoutPadding / CGFloat(5)
                        let smallVerticalCellHeight = 2 * smallHorizontalCellHeight + layout.cellsPadding.vertical
                        let smallCellWidth = (layout.contentWidthWithoutPadding - layout.cellsPadding.horizontal)
                            / CGFloat(2)

                        let firstCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                    y: layout.contentPadding.vertical,
                                                    width: smallCellWidth,
                                                    height: smallHorizontalCellHeight)

                        let secondCellX = layout.contentPadding.horizontal + smallCellWidth
                            + layout.cellsPadding.horizontal

                        let secondCellFrame = CGRect(x: secondCellX,
                                                     y: layout.contentPadding.vertical,
                                                     width: smallCellWidth,
                                                     height: smallVerticalCellHeight)

                        let thirdCellY = layout.contentPadding.vertical + smallHorizontalCellHeight
                            + layout.cellsPadding.vertical

                        let thirdCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                    y: thirdCellY,
                                                    width: smallCellWidth,
                                                    height: smallHorizontalCellHeight)

                        let fourthCellY = layout.contentPadding.vertical + smallVerticalCellHeight
                            + layout.cellsPadding.vertical

                        let fourthCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                     y: fourthCellY,
                                                     width: layout.contentWidthWithoutPadding,
                                                     height: largeHorizontalCellHeight)

                        let cellsFrames = [firstCellFrame, secondCellFrame, thirdCellFrame, fourthCellFrame]

                        for index in 0..<layout.cachedAttributes.count {
                            expect(layout.cachedAttributes[index].frame).to(beCloseTo(cellsFrames[index]))
                        }

                        let height = fourthCellY + largeHorizontalCellHeight + layout.contentPadding.vertical
                        expect(layout.contentSize) == CGSize(width: frame.size.width, height: height)
                    }
                }
            }
        }
    }
}

class FlickrLayoutMock: FlickrLayout {
    var calledFunctions = [String]()

    override func addAttributesForSupplementaryView(ofKind kind: String, section: Int, yOffset: inout CGFloat) {
        calledFunctions.append("addAttributesForSupplementaryView")
    }
}
