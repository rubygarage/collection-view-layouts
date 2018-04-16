//
//  PickerDataSource.swift
//  CollectionDemoApp
//
//  Created by sergey on 2/23/18.
//  Copyright © 2018 rubygarage. All rights reserved.
//

import UIKit

class PickerDataSource: NSObject, UIPickerViewDataSource {
    private let kNumberOfComponents: Int = 1
    
    public var items = [String]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return kNumberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
}
