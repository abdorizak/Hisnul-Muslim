//
//  SchedulerNotificationViewController.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/19/23.
//

import UIKit

class SchedulerNotificationViewController: UIViewController {

    var content: Content!
    private lazy var timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.locale = .current
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.timeZone = .autoupdatingCurrent
        picker.backgroundColor = .systemBackground
        return picker
    }()
    private lazy var notifyMeBtn = Button(color: .systemRed, title: "Notify Me", systemImageName: "bell.badge")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configSchedulerNotificationVC()
    }
    
    private func configSchedulerNotificationVC() {
        view.backgroundColor = .systemBackground
        view.addSubViews(timePicker, notifyMeBtn)
        configTimePickerAndButton()
    }
    
    private func configTimePickerAndButton() {
        
        NSLayoutConstraint.activate([
            timePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            notifyMeBtn.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 30),
            notifyMeBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            notifyMeBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            notifyMeBtn.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
}
