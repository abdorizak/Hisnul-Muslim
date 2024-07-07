//
//  UIView+Ext.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/8/23.
//

import Foundation
import UIKit

extension UIView {
    
    func addSubViews(_ views: UIView...) {
        for i in views { addSubview(i) }
    }
    
    var withoutAutoresizingMask: Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
}
