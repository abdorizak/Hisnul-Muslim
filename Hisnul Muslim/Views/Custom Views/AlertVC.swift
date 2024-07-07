//
//  AlertVC.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/14/23.
//

import Foundation
import UIKit

class AlertVC: UIViewController {
    
    enum AlertAction {
        case ok
        case okWithSettings
        // Add more cases as needed
    }

    let containerView = AlertContainerView()
    let titleLabel = Label(textAlignment: .center, 20)
    let messageLabel = Label(textAlignment: .center)
    
    var alertTitle: String?
    var message: String?
    var actions: [AlertAction]?
    
    let padding: CGFloat = 20
    
    init(title: String, message: String, actions: [AlertAction]) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.message = message
        self.actions = actions
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addSubViews(containerView, titleLabel, messageLabel)
        
        configureContainerView()
        configureTitleLabel()
        configureMessageLabel()
        configureButtons()
    }
    
    func configureContainerView() {
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    func configureTitleLabel() {
        titleLabel.text = alertTitle ?? "Something went wrong"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configureMessageLabel() {
        messageLabel.text = message ?? "Unable to complete request"
        messageLabel.numberOfLines = 4
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -64)
        ])
    }
    
    func configureButtons() {
        guard let actions = actions else { return }
        
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 12
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        for action in actions {
            let button = UIButton(type: .system)
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 10
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
            
            switch action {
            case .ok:
                button.setTitle("OK", for: .normal)
                button.backgroundColor = .systemPink
                button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
                
            case .okWithSettings:
                let settingsButton = UIButton(type: .system)
                settingsButton.setTitle("Settings", for: .normal)
                settingsButton.backgroundColor = .systemBlue
                settingsButton.setTitleColor(.white, for: .normal)
                settingsButton.layer.cornerRadius = 10
                settingsButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
                settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
                buttonStackView.addArrangedSubview(settingsButton)
                
                button.setTitle("OK", for: .normal)
                button.backgroundColor = .systemPink
                button.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
            }
            
            buttonStackView.addArrangedSubview(button)
        }
        
        view.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            buttonStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
