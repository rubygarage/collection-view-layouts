//
//  ContentDynamicFlowLayoutTest.swift
//  collection-view-layouts_Example
//
//  Created by sergey on 2/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Nimble
import Quick
@testable import collection_view_layouts

class ContentDynamicLayoutSpec: QuickSpec {
    override func spec() {
        describe("Check base flow layout") {
            let baseFlowLayout = ContentDynamicLayout()
            
            it("base flow layout fields validation") {
                expect(baseFlowLayout.contentAlign).to(beAKindOf(DynamicContentAlign.self))
                expect(baseFlowLayout.contentAlign).to(equal(DynamicContentAlign.left))
                
                expect(baseFlowLayout.cellsPadding).to(beAKindOf(ItemsPadding.self))
                expect(baseFlowLayout.cellsPadding.horizontal).to(equal(0))
                expect(baseFlowLayout.cellsPadding.vertical).to(equal(0))
                
                expect(baseFlowLayout.contentPadding).to(beAKindOf(ItemsPadding.self))
                expect(baseFlowLayout.contentPadding.horizontal).to(equal(0))
                expect(baseFlowLayout.contentPadding.vertical).to(equal(0))
                
                expect(baseFlowLayout.contentSize).to(beAKindOf(CGSize.self))
                expect(baseFlowLayout.contentSize).to(equal(CGSize.zero))
                
                expect(baseFlowLayout.delegate).to(beNil())
            }
        }
    }
}
