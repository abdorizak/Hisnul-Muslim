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
        notifyMeBtn.addTarget(self, action: #selector(didSchedule), for: .touchUpInside)
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
    
    @objc func g() {
        let selectedTime = timePicker.date
        let timeFormat = DateFormatter()
        timeFormat.timeStyle = .short
        let selectedTimeString = timeFormat.string(from: selectedTime)
        let components = selectedTimeString.split([":", " "])
        let hour = components[0]
        let minute = components[1]
        let amPm = components[2]
        print(hour)
        print(minute)
        print(amPm)
        
    }
    
}
