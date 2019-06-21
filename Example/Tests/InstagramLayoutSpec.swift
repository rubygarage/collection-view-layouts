//
//  InstagramLayoutSpec.swift
//  collection-view-layouts_Example
//
//  Created by Radyslav Krechet on 6/21/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble

@testable import collection_view_layouts

class InstagramLayoutSpec: QuickSpec {
    override func spec() {
        describe("Instagram layout") {
            var layout: InstagramLayoutMock!

            beforeEach {
                layout = InstagramLayoutMock()
            }

            describe("should calculate frames") {
                context("when layout does not have collection view") {
                    it("can not add attributes") {
                        layout.calculateCollectionViewFrames()

                        expect(layout.cachedAttributes).to(beEmpty())
                        expect(layout.calledFunctions).to(beEmpty())
                    }
                }

                context("when layout has collection view and grid type is default") {
                    it("adds attributes") {
                        layout.contentPadding = ItemsPadding(horizontal: 15, vertical: 15)
                        layout.cellsPadding = ItemsPadding(horizontal: 10, vertical: 10)
                        layout.gridType = .defaultGrid

                        let items = ["one", "two", "three"]
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

                        let cellSide = (layout.contentWidthWithoutPadding - 2 * layout.cellsPadding.vertical)
                            / CGFloat(3)

                        let firstCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                    y: layout.contentPadding.vertical,
                                                    width: cellSide,
                                                    height: cellSide)

                        let secondCellX = layout.contentPadding.horizontal + cellSide + layout.cellsPadding.horizontal

                        let secondCellFrame = CGRect(x: secondCellX,
                                                     y: layout.contentPadding.vertical,
                                                     width: cellSide,
                                                     height: cellSide)

                        let thirdCellFrame = CGRect(x: secondCellX + cellSide + layout.cellsPadding.horizontal,
                                                    y: layout.contentPadding.vertical,
                                                    width: cellSide,
                                                    height: cellSide)

                        let cellsFrames = [firstCellFrame, secondCellFrame, thirdCellFrame]

                        for index in 0..<layout.cachedAttributes.count {
                            expect(layout.cachedAttributes[index].frame).to(beCloseTo(cellsFrames[index]))
                        }

                        let height = layout.contentPadding.vertical * 2 + cellSide
                        expect(layout.contentSize) == CGSize(width: frame.size.width, height: height)
                    }
                }

                context("when layout has collection view and grid type is one preview cell") {
                    it("adds attributes") {
                        layout.contentPadding = ItemsPadding(horizontal: 15, vertical: 15)
                        layout.cellsPadding = ItemsPadding(horizontal: 10, vertical: 10)
                        layout.gridType = .onePreviewCell

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

                        let cellSide = (layout.contentWidthWithoutPadding - 2 * layout.cellsPadding.vertical)
                            / CGFloat(3)

                        let firstCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                    y: layout.contentPadding.vertical,
                                                    width: cellSide,
                                                    height: cellSide)

                        let secondCellX = layout.contentPadding.horizontal + cellSide + layout.cellsPadding.horizontal

                        let secondCellFrame = CGRect(x: secondCellX,
                                                     y: layout.contentPadding.vertical,
                                                     width: cellSide * 2 + layout.cellsPadding.horizontal,
                                                     height: cellSide * 2 + layout.cellsPadding.vertical)

                        let thirdCellY = layout.contentPadding.vertical + cellSide + layout.cellsPadding.vertical

                        let thirdCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                    y: thirdCellY,
                                                    width: cellSide,
                                                    height: cellSide)

                        let fourthCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                     y: thirdCellY + cellSide + layout.cellsPadding.vertical,
                                                     width: cellSide,
                                                     height: cellSide)

                        let cellsFrames = [firstCellFrame, secondCellFrame, thirdCellFrame, fourthCellFrame]

                        for index in 0..<layout.cachedAttributes.count {
                            expect(layout.cachedAttributes[index].frame).to(beCloseTo(cellsFrames[index]))
                        }

                        let height = fourthCellFrame.origin.y + cellSide + layout.contentPadding.vertical
                        expect(layout.contentSize) == CGSize(width: frame.size.width, height: height)
                    }
                }

                context("when layout has collection view and grid type is regular preview cell") {
                    it("adds attributes") {
                        layout.contentPadding = ItemsPadding(horizontal: 15, vertical: 15)
                        layout.cellsPadding = ItemsPadding(horizontal: 10, vertical: 10)
                        layout.gridType = .regularPreviewCell

                        let items = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
                                     "elevent", "twelve"]
                        
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

                        let cellSide = (layout.contentWidthWithoutPadding - 2 * layout.cellsPadding.vertical)
                            / CGFloat(3)

                        let previewCellWidth = cellSide * 2 + layout.cellsPadding.horizontal
                        let previewCellHeight = cellSide * 2 + layout.cellsPadding.vertical

                        let firstCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                    y: layout.contentPadding.vertical,
                                                    width: cellSide,
                                                    height: cellSide)

                        let secondCellX = layout.contentPadding.horizontal + cellSide + layout.cellsPadding.horizontal

                        let secondCellFrame = CGRect(x: secondCellX,
                                                     y: layout.contentPadding.vertical,
                                                     width: previewCellWidth,
                                                     height: previewCellHeight)

                        let thirdCellY = layout.contentPadding.vertical + cellSide + layout.cellsPadding.vertical

                        let thirdCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                    y: thirdCellY,
                                                    width: cellSide,
                                                    height: cellSide)

                        let thirdRowY = thirdCellY + cellSide + layout.cellsPadding.vertical
                        let fourthRowY = thirdRowY + cellSide + layout.cellsPadding.vertical
                        let fifthRowY = fourthRowY + cellSide + layout.cellsPadding.vertical

                        let fourthCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                     y: thirdRowY,
                                                     width: cellSide,
                                                     height: cellSide)

                        let secondColumnX = layout.contentPadding.horizontal + cellSide + layout.cellsPadding.horizontal
                        let thirdColumnX = secondColumnX + cellSide + layout.cellsPadding.horizontal

                        let fifthCellFrame = CGRect(x: secondColumnX, y: thirdRowY, width: cellSide, height: cellSide)
                        let sixthCellFrame = CGRect(x: thirdColumnX, y: thirdRowY, width: cellSide, height: cellSide)

                        let seventhCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                      y: fourthRowY,
                                                      width: cellSide,
                                                      height: cellSide)

                        let eighthCellFrame = CGRect(x: secondColumnX, y: fourthRowY, width: cellSide, height: cellSide)
                        let ninthCellFrame = CGRect(x: thirdColumnX, y: fourthRowY, width: cellSide, height: cellSide)

                        let tenthCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                    y: fifthRowY,
                                                    width: previewCellWidth,
                                                    height: previewCellHeight)

                        let x = layout.contentPadding.horizontal + previewCellWidth + layout.cellsPadding.horizontal
                        let eleventhCellFrame = CGRect(x: x, y: fifthRowY, width: cellSide, height: cellSide)

                        let y = fifthRowY + cellSide + layout.cellsPadding.vertical
                        let twelvethCellFrame = CGRect(x: x, y: y, width: cellSide, height: cellSide)

                        let cellsFrames = [firstCellFrame, secondCellFrame, thirdCellFrame, fourthCellFrame,
                                           fifthCellFrame, sixthCellFrame, seventhCellFrame, eighthCellFrame,
                                           ninthCellFrame, tenthCellFrame, eleventhCellFrame, twelvethCellFrame]

                        for index in 0..<layout.cachedAttributes.count {
                            expect(layout.cachedAttributes[index].frame).to(beCloseTo(cellsFrames[index]))
                        }

                        let height = y + cellSide + layout.contentPadding.vertical
                        expect(layout.contentSize) == CGSize(width: frame.size.width, height: height)
                    }
                }
            }
        }
    }
}

class InstagramLayoutMock: InstagramLayout {
    var calledFunctions = [String]()

    override func addAttributesForSupplementaryView(ofKind kind: String, section: Int, yOffset: inout CGFloat) {
        calledFunctions.append("addAttributesForSupplementaryView")
    }
}
