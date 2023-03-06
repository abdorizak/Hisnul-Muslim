//
//  Label.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/5/23.
//

import Foundation
import UIKit

class Label: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(_ textAlignment: NSTextAlignment, _ fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        textColor                    = .label
        minimumScaleFactor           = 0.9
        lineBreakMode                = .byTruncatingTail
    }
    
    private func config() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor                                 = .secondaryLabel
        adjustsFontSizeToFitWidth                 = true
    }
    
}
