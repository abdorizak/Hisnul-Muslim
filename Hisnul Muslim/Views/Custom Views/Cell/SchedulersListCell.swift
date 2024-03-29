//
//  SchedulersListCell.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/24/23.
//

import UIKit

//class SchedulersListCell: UITableViewCell {
//
//    static let identifier = String(describing: SchedulersListCell.self)
//    private var adkar_title = Label(textAlignment: .right, 30)
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        cellConfig()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//    }
//
//    private func cellConfig() {
//        contentView.addSubview(adkar_title)
//        adkar_title.numberOfLines = 0
//
//        NSLayoutConstraint.activate([
//            adkar_title.topAnchor.constraint(equalToSystemSpacingBelow: contentView.layoutMarginsGuide.topAnchor, multiplier: 1),
//            adkar_title.trailingAnchor.constraint(equalToSystemSpacingAfter: contentView.layoutMarginsGuide.trailingAnchor, multiplier: 1),
//            adkar_title.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.layoutMarginsGuide.leadingAnchor, multiplier: 1),
//            adkar_title.bottomAnchor.constraint(equalToSystemSpacingBelow: contentView.layoutMarginsGuide.bottomAnchor, multiplier: 1)
//        ])
//    }
//
//    func displayData(list of: HSMSchedulers) {
//        adkar_title.text = of.adkarName
//    }
//
//}

class SchedulersListCell: UITableViewCell {
    
    static let identifier = String(describing: SchedulersListCell.self)
    private var adkar_title = Label(textAlignment: .right, 30)
    private var timeView = UIView()
    private var hourLabel = Label(textAlignment: .center, 16)
    private var minuteLabel = Label(textAlignment: .center, 16)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        timeView.layer.cornerRadius = 12
    }
    
    private func cellConfig() {
        contentView.addSubview(adkar_title)
        adkar_title.numberOfLines = 0

        contentView.addSubview(timeView)
        timeView.translatesAutoresizingMaskIntoConstraints = false
        timeView.backgroundColor = UIColor.random()
        timeView.layer.cornerRadius = 12

        // Initialize the separator label
        let separatorLabel = UILabel()
        separatorLabel.text = ":"
        separatorLabel.font = UIFont.systemFont(ofSize: 16)
        separatorLabel.textColor = .white
        separatorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let timeStackView = UIStackView(arrangedSubviews: [hourLabel, separatorLabel, minuteLabel])
        timeStackView.axis = .horizontal
        timeStackView.spacing = 8 // Adjust the spacing as needed
        timeStackView.alignment = .center
        timeStackView.translatesAutoresizingMaskIntoConstraints = false
        timeView.addSubview(timeStackView)

        NSLayoutConstraint.activate([
            adkar_title.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            adkar_title.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            adkar_title.leadingAnchor.constraint(equalTo: timeView.trailingAnchor, constant: 8),
            
            timeView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            timeView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            // Remove the fixed width constraint to allow the timeView to resize based on content
            timeView.widthAnchor.constraint(equalToConstant: 100),
            timeView.heightAnchor.constraint(equalToConstant: 30),
            
            // Constraints for the stack view
            timeStackView.topAnchor.constraint(equalTo: timeView.topAnchor),
            timeStackView.leadingAnchor.constraint(equalTo: timeView.leadingAnchor, constant: 8),
            timeStackView.trailingAnchor.constraint(equalTo: timeView.trailingAnchor, constant: -8),
            timeStackView.bottomAnchor.constraint(equalTo: timeView.bottomAnchor),
        ])
    }


    
//    private func cellConfig() {
//        contentView.addSubview(adkar_title)
//        adkar_title.numberOfLines = 0
//        
//        contentView.addSubview(timeView)
//        timeView.translatesAutoresizingMaskIntoConstraints = false
//        timeView.backgroundColor = UIColor.random()
//        timeView.addSubview(hourLabel)
//        timeView.addSubview(minuteLabel)
//        
//        NSLayoutConstraint.activate([
//            adkar_title.topAnchor.constraint(equalToSystemSpacingBelow: contentView.layoutMarginsGuide.topAnchor, multiplier: 1),
//            adkar_title.trailingAnchor.constraint(equalToSystemSpacingAfter: contentView.layoutMarginsGuide.trailingAnchor, multiplier: 1),
//            adkar_title.leadingAnchor.constraint(equalToSystemSpacingAfter: timeView.layoutMarginsGuide.trailingAnchor, multiplier: 1),
//            
//            timeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            timeView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            timeView.widthAnchor.constraint(equalToConstant: 100),
//            timeView.heightAnchor.constraint(equalToConstant: 35),
//            
//            hourLabel.centerXAnchor.constraint(equalTo: timeView.centerXAnchor, constant: -10),
//            hourLabel.centerYAnchor.constraint(equalTo: timeView.centerYAnchor),
//            
//            minuteLabel.centerXAnchor.constraint(equalTo: timeView.centerXAnchor, constant: 10),
//            minuteLabel.centerYAnchor.constraint(equalTo: timeView.centerYAnchor),
//        ])
//        
//        // Add ":" between hour and minute labels
//        let separatorLabel = UILabel()
//        separatorLabel.text = ":"
//        separatorLabel.font = UIFont.systemFont(ofSize: 15)
//        separatorLabel.textColor = .white
//        separatorLabel.translatesAutoresizingMaskIntoConstraints = false
//        timeView.addSubview(separatorLabel)
//        separatorLabel.centerXAnchor.constraint(equalTo: timeView.centerXAnchor).isActive = true
//        separatorLabel.centerYAnchor.constraint(equalTo: timeView.centerYAnchor).isActive = true
//    }

    func displayData(list of: HSMSchedulers) {
        adkar_title.text = of.adkarName
        hourLabel.text = of.hour
        minuteLabel.text = of.minute
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}
