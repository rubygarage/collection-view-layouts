//
//  ContentAlignableLayoutSpec.swift
//  collection-view-layouts_Tests
//
//  Created by Radyslav Krechet on 6/13/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Quick
import Nimble

@testable import collection_view_layouts

class ContentAlignableLayoutSpec: QuickSpec {
    override func spec() {
        describe("Content alignable layout") {
            var layout: ContentAlignableLayout!

            beforeEach {
                layout = ContentAlignableLayout()
            }

            it("should have valid stored properties") {
                expect(layout.contentAlign).to(beAKindOf(ContentAlign.self))
                expect(layout.contentAlign) == .left
            }
        }
    }
}
