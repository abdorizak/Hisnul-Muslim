//
//  HisnulMuslimCell.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/5/23.
//

import UIKit
import SwiftUI

class HisnulMuslimCell: UITableViewCell {

    private var adkar_title = Label(textAlignment: .right, 30)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellConfig()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func cellConfig() {
        contentView.addSubview(adkar_title)
        adkar_title.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            adkar_title.topAnchor.constraint(equalToSystemSpacingBelow: contentView.layoutMarginsGuide.topAnchor, multiplier: 1),
            adkar_title.trailingAnchor.constraint(equalToSystemSpacingAfter: contentView.layoutMarginsGuide.trailingAnchor, multiplier: 1),
            adkar_title.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.layoutMarginsGuide.leadingAnchor, multiplier: 1),
            adkar_title.bottomAnchor.constraint(equalToSystemSpacingBelow: contentView.layoutMarginsGuide.bottomAnchor, multiplier: 1)
        ])
    }
    
    func displayData(list of: Content) {
        adkar_title.text = of.title
    }

}

