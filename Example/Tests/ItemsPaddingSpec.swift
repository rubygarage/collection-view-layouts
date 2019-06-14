//
//  ItemsPaddingSpec.swift
//  collection-view-layouts_Tests
//
//  Created by Radyslav Krechet on 6/13/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble

@testable import collection_view_layouts

class ItemsPaddingSpec: QuickSpec {
    override func spec() {
        describe("Items padding") {
            let padding = ItemsPadding()

            it("should have valid properties") {
                expect(padding.horizontal) == 0
                expect(padding.vertical) == 0
            }
        }
    }
}
