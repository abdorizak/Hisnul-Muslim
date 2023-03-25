//
//  SchedulersListVC.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/24/23.
//

import UIKit

class SchedulersListVC: HSDataLoadingVC, SchedulerDelegate  {

    private let tableView                     = UITableView()
    private var schedulersList                = [HSMSchedulers]()
    private let vm                            = HSMSchedulerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    
    func configureViewController() {
        view.backgroundColor    = .systemBackground
        title                   = "المفضلات"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        vm.delegate = self
    }
    
    
    func configureTableView() {
        tableView.frame         = view.bounds
        tableView.rowHeight     = 44
        tableView.delegate      = self
        tableView.dataSource    = self
        tableView.removeExcessCells()
        
        tableView.register(SchedulersListCell.self, forCellReuseIdentifier: SchedulersListCell.identifier)
    }
    
    func didFinishLoadingSchedulers() {
        updateUI(with: vm.schedulers)
    }

    
    func updateUI(with schedulersList: [HSMSchedulers]) {
        if schedulersList.isEmpty {
            self.showEmptyStateView(with: "لا يوجد أي إشعار هنا", in: self.view)
        } else  {
            self.schedulersList = schedulersList
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
       
    }
    
}
