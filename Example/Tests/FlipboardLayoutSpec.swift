//
//  FlipboardLayoutSpec.swift
//  collection-view-layouts_Example
//
//  Created by Radyslav Krechet on 6/21/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble

@testable import collection_view_layouts

class FlipboardLayoutSpec: QuickSpec {
    override func spec() {
        describe("Flipboard layout") {
            var layout: FlipboardLayoutMock!

            beforeEach {
                layout = FlipboardLayoutMock()
            }

            describe("should calculate frames") {
                context("when layout does not have collection view") {
                    it("can not add attributes") {
                        layout.calculateCollectionViewFrames()

                        expect(layout.cachedAttributes).to(beEmpty())
                        expect(layout.calledFunctions).to(beEmpty())
                    }
                }

                context("when layout has collection view and content align is left") {
                    it("adds attributes") {
                        layout.contentPadding = ItemsPadding(horizontal: 15, vertical: 15)
                        layout.cellsPadding = ItemsPadding(horizontal: 10, vertical: 10)

                        let items = ["one", "two", "three", "four", "five", "six", "seven", "eight"]
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

                        let cellSide = (layout.contentWidthWithoutPadding - 2 * layout.cellsPadding.horizontal)
                            / CGFloat(3)

                        let firstCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                    y: layout.contentPadding.vertical,
                                                    width: cellSide * 2 + layout.cellsPadding.horizontal,
                                                    height: cellSide)

                        let secondCellX = layout.contentPadding.horizontal + firstCellFrame.width
                            + layout.cellsPadding.horizontal

                        let secondCellFrame = CGRect(x: secondCellX,
                                                     y: layout.contentPadding.vertical,
                                                     width: cellSide,
                                                     height: cellSide)

                        let (commonCellsFrames, y) = self.commonCellsFrames(forLayout: layout, with: cellSide)
                        let cellsFrames = [firstCellFrame, secondCellFrame] + commonCellsFrames

                        for index in 0..<layout.cachedAttributes.count {
                            expect(layout.cachedAttributes[index].frame).to(beCloseTo(cellsFrames[index]))
                        }

                        let height = y + cellSide + layout.contentPadding.vertical
                        expect(layout.contentSize) == CGSize(width: frame.size.width, height: height)
                    }
                }

                context("when layout has collection view and content align is right") {
                    it("adds attributes") {
                        layout.contentPadding = ItemsPadding(horizontal: 15, vertical: 15)
                        layout.cellsPadding = ItemsPadding(horizontal: 10, vertical: 10)
                        layout.contentAlign = .right

                        let items = ["one", "two", "three", "four", "five", "six", "seven", "eight"]
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

                        let cellSide = (layout.contentWidthWithoutPadding - 2 * layout.cellsPadding.horizontal)
                            / CGFloat(3)

                        let firstCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                    y: layout.contentPadding.vertical,
                                                    width: cellSide,
                                                    height: cellSide)

                        let secondCellX = layout.contentPadding.horizontal + cellSide + layout.cellsPadding.horizontal
                        let secondCellFrame = CGRect(x: secondCellX,
                                                     y: layout.contentPadding.vertical,
                                                     width: cellSide * 2 + layout.cellsPadding.horizontal,
                                                     height: cellSide)

                        let (commonCellsFrames, y) = self.commonCellsFrames(forLayout: layout, with: cellSide)
                        let cellsFrames = [firstCellFrame, secondCellFrame] + commonCellsFrames

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

    private func commonCellsFrames(forLayout layout: FlipboardLayoutMock,
                                   with cellSide: CGFloat) -> ([CGRect], CGFloat) {

        let secondRowY = layout.contentPadding.vertical + cellSide + layout.cellsPadding.vertical
        let thirdRowY = secondRowY + cellSide + layout.cellsPadding.vertical

        let secondColumnX = layout.contentPadding.horizontal + cellSide + layout.cellsPadding.horizontal
        let thirdColumnX = secondColumnX + cellSide + layout.cellsPadding.horizontal

        let thirdCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                    y: secondRowY,
                                    width: cellSide,
                                    height: cellSide)

        let fourthCellFrame = CGRect(x: secondColumnX, y: secondRowY, width: cellSide, height: cellSide)
        let fifthCellFrame = CGRect(x: thirdColumnX, y: secondRowY, width: cellSide, height: cellSide)

        let sixthCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                    y: thirdRowY,
                                    width: cellSide,
                                    height: cellSide)

        let seventhCellFrame = CGRect(x: secondColumnX, y: thirdRowY, width: cellSide, height: cellSide)
        let eighthCellFrame = CGRect(x: thirdColumnX, y: thirdRowY, width: cellSide, height: cellSide)

        return ([thirdCellFrame, fourthCellFrame, fifthCellFrame, sixthCellFrame, seventhCellFrame, eighthCellFrame],
                thirdRowY)
    }
}

class FlipboardLayoutMock: FlipboardLayout {
    var calledFunctions = [String]()
    
    override func addAttributesForSupplementaryView(ofKind kind: String, section: Int, yOffset: inout CGFloat) {
        calledFunctions.append("addAttributesForSupplementaryView")
    }
}
