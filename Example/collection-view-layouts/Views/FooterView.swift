//
//  FooterView.swift
//  collection-view-layouts_Example
//
//  Created by Radyslav Krechet on 6/10/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class FooterView: UICollectionReusableView {
    @IBOutlet private(set) weak var label: UILabel!

    func populate(with item: String) {
        label.text = item

        backgroundColor = UIColor.random().withAlphaComponent(0.5)
    }
}
