//
//  FacebookLayoutSpec.swift
//  collection-view-layouts_Tests
//
//  Created by Radyslav Krechet on 6/13/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble

@testable import collection_view_layouts

class FacebookLayoutSpec: QuickSpec {
    override func spec() {
        describe("Facebook layout") {
            var layout: FacebookLayoutMock!

            beforeEach {
                layout = FacebookLayoutMock()
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

                        let items = ["one", "two", "three", "four", "five"]
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

                        let largeCellSide = (layout.contentWidthWithoutPadding - layout.cellsPadding.horizontal)
                            / CGFloat(2)

                        let smallCellSide = (layout.contentWidthWithoutPadding - 2 * layout.cellsPadding.horizontal)
                            / CGFloat(3)

                        let firstCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                    y: layout.contentPadding.vertical,
                                                    width: largeCellSide,
                                                    height: largeCellSide)

                        let secondCellX = layout.contentPadding.horizontal + largeCellSide
                            + layout.cellsPadding.horizontal

                        let secondCellFrame = CGRect(x: secondCellX,
                                                     y: layout.contentPadding.vertical,
                                                     width: largeCellSide,
                                                     height: largeCellSide)

                        let smallCellsY = layout.contentPadding.vertical + largeCellSide + layout.cellsPadding.vertical
                        
                        let thirdCellFrame = CGRect(x: layout.contentPadding.horizontal,
                                                    y: smallCellsY,
                                                    width: smallCellSide,
                                                    height: smallCellSide)

                        let fourthCellX = layout.contentPadding.horizontal + smallCellSide
                            + layout.cellsPadding.horizontal

                        let fourthCellFrame = CGRect(x: fourthCellX,
                                                     y: smallCellsY,
                                                     width: smallCellSide,
                                                     height: smallCellSide)

                        let fifthCellFrame = CGRect(x: fourthCellX + smallCellSide + layout.cellsPadding.horizontal,
                                                    y: smallCellsY,
                                                    width: smallCellSide,
                                                    height: smallCellSide)

                        let cellsFrames = [firstCellFrame, secondCellFrame, thirdCellFrame, fourthCellFrame,
                                           fifthCellFrame]

                        for index in 0..<layout.cachedAttributes.count {
                            expect(layout.cachedAttributes[index].frame).to(beCloseTo(cellsFrames[index]))
                        }

                        let height = smallCellsY + smallCellSide + layout.contentPadding.vertical
                        expect(layout.contentSize) == CGSize(width: frame.size.width, height: height)
                    }
                }
            }
        }
    }
}

class FacebookLayoutMock: FacebookLayout {
    var calledFunctions = [String]()

    override func addAttributesForSupplementaryView(ofKind kind: String, section: Int, yOffset: inout CGFloat) {
        calledFunctions.append("addAttributesForSupplementaryView")
    }
}
