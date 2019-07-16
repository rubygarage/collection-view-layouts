//
//  PickerViewProvider.swift
//  collection-view-layouts_Example
//
//  Created by Radyslav Krechet on 4/26/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

protocol PickerViewProviderDelegate: class {
    func provider(_ provider: PickerViewProvider, didSelect row: Int)
}

class PickerViewProvider: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    var items = [String]()

    weak var delegate: PickerViewProviderDelegate?
    
    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.provider(self, didSelect: row)
    }
}
