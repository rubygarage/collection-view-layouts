//
//  Px500LayoutSpec.swift
//  collection-view-layouts_Example
//
//  Created by Radyslav Krechet on 7/16/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble

@testable import collection_view_layouts

class Px500LayoutSpec: QuickSpec {
    override func spec() {
        describe("Tags layout") {
            var layout: Px500LayoutMock!

            beforeEach {
                layout = Px500LayoutMock()
            }

            it("should have valid stored properties") {
                expect(layout.minCellsInRow).to(beAKindOf(MinCellsInRow.self))
                expect(layout.minCellsInRow) == .one

                expect(layout.maxCellsInRow).to(beAKindOf(MaxCellsInRow.self))
                expect(layout.maxCellsInRow) == .three

                expect(layout.visibleRowsCount).to(beAKindOf(Int.self))
                expect(layout.visibleRowsCount) == 5

                expect(layout.layoutConfiguration).to(beAKindOf([[Int]].self))
                expect(layout.layoutConfiguration) == [[Int]]()
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
                    it("adds attributes with layout configuration") {
                        layout.layoutConfiguration = [[1, 2, 2, 3, 3, 3, 3]]
                        
                        layout.contentPadding = ItemsPadding(horizontal: 15, vertical: 15)
                        layout.cellsPadding = ItemsPadding(horizontal: 10, vertical: 10)

                        let items = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
                                     "elevent", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen"]
                        
                        let supplementaryItems = ["numbers"]
                        let collectionViewProvider = CollectionViewProvider()
                        collectionViewProvider.items = [items]
                        collectionViewProvider.supplementaryItems = supplementaryItems

                        let frame = CGRect(x: 0, y: 0, width: 320, height: 568)
                        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
                        collectionView.dataSource = collectionViewProvider

                        let delegate = Px500LayoutDelegate()
                        layout.delegate = delegate

                        layout.calculateCollectionViewFrames()

                        expect(layout.cachedAttributes.count) == items.count
                        expect(layout.calledFunctions.count) == supplementaryItems.count * 2

                        let cellHeight = collectionView.frame.height / CGFloat(layout.visibleRowsCount)

                        let rowsCount = CGFloat(layout.layoutConfiguration.reduce(0, { (result, items) -> Int in
                            return result + items.count
                        }))

                        let height = layout.contentPadding.vertical * 2 + cellHeight * rowsCount
                            + layout.cellsPadding.vertical * (rowsCount - 1)

                        expect(layout.contentSize.width) == frame.size.width
                        expect(layout.contentSize.height).to(beCloseTo(height))
                    }

                    it("adds attributes without layout configuration") {
                        layout.contentPadding = ItemsPadding(horizontal: 15, vertical: 15)
                        layout.cellsPadding = ItemsPadding(horizontal: 10, vertical: 10)

                        let items = ["one", "two", "three", "four", "five", "six"]
                        let supplementaryItems = ["numbers"]
                        let collectionViewProvider = CollectionViewProvider()
                        collectionViewProvider.items = [items]
                        collectionViewProvider.supplementaryItems = supplementaryItems

                        let frame = CGRect(x: 0, y: 0, width: 320, height: 568)
                        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
                        collectionView.dataSource = collectionViewProvider

                        let delegate = Px500LayoutDelegate()
                        layout.delegate = delegate

                        layout.calculateCollectionViewFrames()

                        expect(layout.cachedAttributes.count) == items.count
                        expect(layout.calledFunctions.count) == supplementaryItems.count * 2
                        
                        expect(layout.layoutConfiguration.count) == 1
                        expect(layout.layoutConfiguration[0].reduce(0, +)) == items.count
                    }
                }
            }
        }
    }
}

class Px500LayoutMock: Px500Layout {
    var calledFunctions = [String]()

    override func addAttributesForSupplementaryView(ofKind kind: String, section: Int, yOffset: inout CGFloat) {
        calledFunctions.append("addAttributesForSupplementaryView")
    }
}

class Px500LayoutDelegate: NSObject, LayoutDelegate {
    let sizes: [CGSize] = [
        CGSize(width: 290, height: 0.1),

        CGSize(width: 100, height: 0.1),
        CGSize(width: 180, height: 0.1),

        CGSize(width: 180, height: 0.1),
        CGSize(width: 100, height: 0.1),

        CGSize(width: 90, height: 45),
        CGSize(width: 90, height: 45),
        CGSize(width: 90, height: 45),

        CGSize(width: 90, height: 180),
        CGSize(width: 90, height: 45),
        CGSize(width: 90, height: 45),

        CGSize(width: 90, height: 45),
        CGSize(width: 90, height: 180),
        CGSize(width: 90, height: 45),

        CGSize(width: 90, height: 45),
        CGSize(width: 90, height: 45),
        CGSize(width: 90, height: 180)
    ]

    func cellSize(indexPath: IndexPath) -> CGSize {
        return sizes[indexPath.row]
    }
}
