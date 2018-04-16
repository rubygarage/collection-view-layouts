//
//  PickerDelegate.swift
//  CollectionDemoApp
//
//  Created by sergey on 2/23/18.
//  Copyright © 2018 rubygarage. All rights reserved.
//

import UIKit

class PickerDelegate: NSObject, UIPickerViewDelegate {
    public var items = [String]()
    public var rowSelectHandler: ((Int) -> Void)?

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rowSelectHandler?(row)
    }
}
