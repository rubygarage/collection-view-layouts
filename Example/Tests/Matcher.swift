//
//  Matchers.swift
//  collection-view-layouts_Example
//
//  Created by Radyslav Krechet on 6/13/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Nimble

func beCloseTo(_ expectedValue: CGRect, within delta: CGFloat = CGFloat(DefaultDelta)) -> Predicate<CGRect> {
    return Predicate.define { actual in
        let actualValue = try actual.evaluate()!

        let isXValid = abs(actualValue.origin.x - expectedValue.origin.x) < delta
        let isYValid = abs(actualValue.origin.y - expectedValue.origin.y) < delta
        let isWidthValid = abs(actualValue.size.width - expectedValue.size.width) < delta
        let isHeightValid = abs(actualValue.size.height - expectedValue.size.height) < delta
        let isRectValid = isXValid && isYValid && isWidthValid && isHeightValid

        let expectedValueMessage = "be close to <\(stringify(expectedValue))> (within \(stringify(delta)))"
        let actualValueMessage = "<\(stringify(actualValue))>"
        let message = ExpectationMessage.expectedCustomValueTo(expectedValueMessage, actualValueMessage)

        return PredicateResult(bool: isRectValid, message: message)
    }
}
