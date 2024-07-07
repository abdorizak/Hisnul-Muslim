//
//  UIStackView+Ext.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 7/6/24.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
