//
//  SchedulersListCell.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/24/23.
//

import UIKit

class SchedulersListCell: UITableViewCell {
    
    private var adkar_title = Label(textAlignment: .right, 30)
    private var timeView = UIView()
    private var hourLabel = Label(textAlignment: .center, 16)
    private var minuteLabel = Label(textAlignment: .center, 16)
    private let separatorLabel = Label(textAlignment: .center, 16)
    private let timeStackView = {
        $0.axis = .horizontal
        $0.spacing = 8 // Adjust the spacing as needed
        $0.alignment = .center
        return $0.withoutAutoresizingMask
    }(UIStackView(frame: .zero))
    
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
        contentView.addSubViews(adkar_title, timeView)
        adkar_title.numberOfLines = 0

        timeView.translatesAutoresizingMaskIntoConstraints = false
        timeView.backgroundColor = .tertiarySystemGroupedBackground
        timeView.layer.cornerRadius = 12
        timeStackView.addArrangedSubviews(hourLabel, separatorLabel, minuteLabel)
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


    func displayData(list of: HSMSchedulers) {
        adkar_title.text = of.adkarName
        hourLabel.text = of.hour
        minuteLabel.text = of.minute
    }
}
