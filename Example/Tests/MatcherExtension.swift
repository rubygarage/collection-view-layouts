//
//  MatcherExtension.swift
//  collection-view-layouts_Example
//
//  Created by sergey on 3/20/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Nimble

public func beCloseTo(_ expectedValue: CGRect, within delta: Double = DefaultDelta) -> Predicate<CGRect> {
    return Predicate.define { actualExpression in
        return isCloseRectTo((try actualExpression.evaluate())!, expectedValue: expectedValue, delta: delta)
    }
}

internal func isCloseRectTo(_ actualValue: CGRect,
                        expectedValue: CGRect,
                        delta: Double)
    -> PredicateResult {
        let errorMessage = "be close to <\(stringify(expectedValue))> (within \(stringify(delta)))"
        
        let xValid = abs(actualValue.origin.x - expectedValue.origin.x) < CGFloat(delta)
        let yValid = abs(actualValue.origin.y - expectedValue.origin.y) < CGFloat(delta)
        let widthValid = abs(actualValue.size.width - expectedValue.size.width) < CGFloat(delta)
        let heightValid = abs(actualValue.size.height - expectedValue.size.height) < CGFloat(delta)
        
        return PredicateResult(
            bool: xValid && yValid && widthValid && heightValid,
            message: .expectedCustomValueTo(errorMessage, "<\(stringify(actualValue))>")
        )
}
