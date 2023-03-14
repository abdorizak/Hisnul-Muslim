//
//  Label.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/5/23.
//

import Foundation
import UIKit

/// Custom Label
class Label: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Text Title
    /// - Parameters:
    ///   - textAlignment: Text Tiltle Aligment
    ///   - fontSize: Text Title Font Size
    convenience init(textAlignment: NSTextAlignment, _ fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment           = textAlignment
        self.font                    = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        textColor                    = .label
        minimumScaleFactor           = 0.9
        lineBreakMode                = .byTruncatingTail
    }
    
    
    /// Text Body
    /// - Parameters:
    ///   - textAligment: Text Body Alignment
    ///   - fontSize: Text Body Font Size
    convenience init(textAlignment: NSTextAlignment) {
        self.init(frame: .zero)
        self.textAlignment                  = textAlignment
        font                                = UIFont.preferredFont(forTextStyle: .body)
        textColor                           = .label
        adjustsFontSizeToFitWidth           = true
        minimumScaleFactor                  = 0.9
        lineBreakMode                       = .byTruncatingTail
    }
    
    
    /// Label Config
    private func config() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor                                 = .secondaryLabel
        adjustsFontSizeToFitWidth                 = true
    }
    
}
