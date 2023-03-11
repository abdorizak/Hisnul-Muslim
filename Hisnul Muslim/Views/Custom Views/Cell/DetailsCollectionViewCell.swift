//
//  DetailsCollectionViewCell.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/8/23.
//

import UIKit

class DetailsCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: DetailsViewController.self)
    
    private let detailView: UIView = {
        let detail_view = UIView(frame: .zero)
        detail_view.translatesAutoresizingMaskIntoConstraints = false
        return detail_view
    }()
    
    private let dua_details: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.font = .systemFont(ofSize: 23)
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .label
        textView.isEditable = false
        textView.textAlignment = .right
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configDetailsViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configDetailsViewCell() {
        contentView.addSubview(dua_details)
        dua_details.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            dua_details.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            dua_details.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dua_details.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dua_details.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            
            
        ])
    }
    
    func displayContents(of pages: Page) {
        dua_details.text = "\(pages.content) \r \(pages.reference)"
    }
    
}
