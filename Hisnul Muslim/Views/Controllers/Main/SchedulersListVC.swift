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
        fetchSchedulers()
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
    
    func fetchSchedulers() {
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
        if schedulersList.isEmpty {
            self.showEmptyStateView(with: "لا يوجد أي إشعار هنا", in: self.view)
        } else  {
//            self.schedulersList = schedulersList
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
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
                DispatchQueue.main.async {
                    self?.presentAlert(title: "Sucess", message: "you have unsubscribe to send notification of this dua: \(selectedObj.adkarName ?? "N/A")", buttonTitle: "OK!")
                }
            case .failure(let err):
                DispatchQueue.main.async {
                    self?.presentAlert(title: "⛔️", message: err.localizedDescription, buttonTitle: "OK!")
                }
            }
        }
        
    }
    
}
