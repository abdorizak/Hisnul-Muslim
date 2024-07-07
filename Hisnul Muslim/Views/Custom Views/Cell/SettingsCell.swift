//
//  SettingsCell.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/24/23.
//

import Foundation
import UIKit

class SettingsTableViewCell: UITableViewCell {

    private var title = Label(textAlignment: .right, 15)
    private var img   = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellConfig()
    }
    
    private func cellConfig() {
        contentView.addSubViews(img, title)
        title.textAlignment = .right
        img.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // align top and bottom of content view with cell's contentView
            contentView.topAnchor.constraint(equalTo: title.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: title.bottomAnchor),
            
            // constraints for image view and title label
            img.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            img.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            img.heightAnchor.constraint(equalToConstant: 30),
            img.widthAnchor.constraint(equalToConstant: 30),
            title.trailingAnchor.constraint(equalTo: img.leadingAnchor, constant: -8),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
    }
    
    func displayData(title: String, Image: UIImage?) {
        self.title.text = title
        self.img.image = Image
    }
}

