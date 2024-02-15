//
//  SchedulersListVC.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/24/23.
//

import UIKit

class SchedulersListVC: HSDataLoadingVC, SchedulerDelegate  {
    
    private let tableView                     = UITableView(frame: .zero)
    private let vm                            = HSMSchedulerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSchedulers()
    }
    
    
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if vm.schedulers.isEmpty {
            var config = UIContentUnavailableConfiguration.empty()
            config.image = UIImage(systemName: "bookmark.fill")
            config.text = "لا يوجد أي إشعار جدولة"
            config.secondaryText = "للحصول على ما عليك القيام به جدولة لأي دعاء داخل القائمة"
            contentUnavailableConfiguration = config
        } else {
            contentUnavailableConfiguration = nil
        }
    }
    
    func configureViewController() {
        view.backgroundColor    = .systemBackground
        title                   = "إشعارات"
        navigationController?.navigationBar.prefersLargeTitles = true
        vm.delegate = self
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame         = view.bounds
        tableView.rowHeight     = 88
        tableView.delegate      = self
        tableView.dataSource    = self
        tableView.removeExcessCells()
        
        tableView.register(SchedulersListCell.self, forCellReuseIdentifier: SchedulersListCell.identifier)
        
    }
    
    func getSchedulers() {
        vm.fetchSchedulersData { [weak self] result in
            switch result {
            case .success(let schedulers):
                self?.updateUI(with: schedulers)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.presentAlert(title: "⛔️", message: error.localizedDescription, buttonTitle: "Ok")
                }
            }
        }
    }
    
    func didFinishLoadingSchedulers() {
        updateUI(with: vm.schedulers)
    }
    
    
    func updateUI(with schedulersList: [HSMSchedulers]) {
        setNeedsUpdateContentUnavailableConfiguration()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.bringSubviewToFront(self.tableView)
        }
    }
}


extension SchedulersListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.schedulers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SchedulersListCell.identifier) as! SchedulersListCell
        cell.displayData(list: self.vm.index(indexPath.row))
        return cell
    }
 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let selectedObj = vm.schedulers[indexPath.item]
        vm.deleteNotification(withID: selectedObj.id!) { [weak self] result in
            switch result {
            case .success( _):
                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [selectedObj.id!.uuidString])
                self?.vm.schedulers.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .right)
                self?.setNeedsUpdateContentUnavailableConfiguration()
                DispatchQueue.main.async {
                    self?.presentAlert(title: "نجاح", message: "لقد تم إلغاء الاشتراك في إرسال الإشعارات لهذا الدعاء: \(selectedObj.adkarName ?? "N/A")", buttonTitle: "OK")


                }
            case .failure(let err):
                DispatchQueue.main.async {
                    self?.presentAlert(title: "⛔️", message: err.localizedDescription, buttonTitle: "OK!")
                }
            }
        }
        
    }
    
}
