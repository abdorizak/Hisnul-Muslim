//
//  EmptyStateViewCell.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 6/28/24.
//

import Foundation
import UIKit

class EmptyStateViewCell: UITableViewCell {
    
    private let icon = {
        return $0.withoutAutoresizingMask
    }(UIImageView())
    
    private let title = {
        return $0.withoutAutoresizingMask
    }(Label(textAlignment: .center, 30))
    
    private let message = {
        return $0.withoutAutoresizingMask
    }(Label(textAlignment: .center, 20))
    
    private var iconWidthConstraint: NSLayoutConstraint!
    private var iconHeightConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellConfig()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func cellConfig() {
        contentView.addSubViews(icon, title, message)
        
        iconWidthConstraint = icon.widthAnchor.constraint(equalToConstant: 200)
        iconHeightConstraint = icon.heightAnchor.constraint(equalToConstant: 200)
        
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            icon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 200),
            iconWidthConstraint,
            iconHeightConstraint,
            
            title.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            message.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20),
            message.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            message.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            message.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
        ])
        
        title.numberOfLines = 2
        message.numberOfLines = 0
    }
    
    func displayData(title: String, message: String, image: UIImage = .hisnulMuslimBook, iconSize: CGSize? = nil) {
        self.title.text = title
        self.message.text = message
        self.icon.image = image.withRenderingMode(.alwaysOriginal)
        
        if let size = iconSize {
            iconWidthConstraint.constant = size.width
            iconHeightConstraint.constant = size.height
        } else {
            iconWidthConstraint.constant = 200 // Default width
            iconHeightConstraint.constant = 200 // Default height
        }
    }
}

