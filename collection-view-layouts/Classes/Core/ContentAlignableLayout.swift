//
//  ContentAlignableLayout.swift
//  collection-view-layouts
//
//  Created by Radyslav Krechet on 6/13/19.
//

import Foundation

public enum ContentAlign {
    case left
    case right
}

public class ContentAlignableLayout: BaseLayout {
    public var contentAlign: ContentAlign = .left
}
