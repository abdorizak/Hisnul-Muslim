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
    
    @objc func didSchedule() {
        let selectedTime = timePicker.date
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "h:mm a" // Use 12-hour format with AM/PM
        let selectedTimeString = timeFormat.string(from: selectedTime)
        
        let components = selectedTimeString.split(separator: " ")
        let timeComponents = components[0].split(separator: ":")
        let hour = Int(timeComponents[0]) ?? 0
        let minute = Int(timeComponents[1]) ?? 0
        let amPm = components[1]
        
        // Adjust hour for 24-hour format
        let adjustedHour = amPm == "PM" ? (hour % 12) + 12 : hour % 12
        
        Task {
            do {
                let result = try await HSMCoreDataHelper.shared.insert(adkarName: content.title, hour: String(adjustedHour), minute: String(minute))
                if result.success {
                    // Schedule daily notification
                    let savedId = result.id!
                    let message = try await SchedulerNotifications.shared.scheduleDailyNotification(identifier: savedId, hour: adjustedHour, minute: minute, AdkarContent: content.title)
                    self.presentAlertOnMainThread(title: "نجاح", message: message) { [weak self] in
                        guard let self = self else { return }
                        self.dismiss(animated: true)
                    }
                } else {
                    // present Alert if there is an error saving data to CoreData
                    self.presentAlertOnMainThread(title: "هل هناك خطأ ما!", message: result.message)  { [weak self] in
                        guard let self = self else { return }
                        self.dismiss(animated: true)
                    }
                }
            } catch {
                self.presentAlertOnMainThread(title: "هل هناك خطأ ما!", message: error.localizedDescription)  { [weak self] in
                    guard let self = self else { return }
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
}
