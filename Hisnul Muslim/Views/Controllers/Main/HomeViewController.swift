//
//  HomeViewController.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 2/11/23.
//

import UIKit

class HomeViewController: UIViewController {
    private var vm = HSMViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HisnulMuslimCell.self, forCellReuseIdentifier: HisnulMuslimCell.identifier)
        tableView.separatorStyle = .singleLine
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeVC()
    }
    
    private func configureHomeVC() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        configNavBar()
        configTableView()
        vm.delegate = self
        vm.getHSMData()
        
    }
    
    private func configNavBar() {
        navigationItem.title = "حِصن المسلمِ"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate, HSMDelegate {
    
    func didFinish() {
        tableView.reloadDataOnMainThread()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let FAction = UIContextualAction(style: .normal, title: "Favorite") { _, _, completionHandler in
            print("didTap.")
            completionHandler(true)
        }
        
        FAction.image = UIImage(named: "bookmark")
        
        FAction.backgroundColor = .orange.withAlphaComponent(0.4)
        let configuration = UISwipeActionsConfiguration(actions: [FAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("current Index: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.hs_mslm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HisnulMuslimCell.identifier, for: indexPath) as! HisnulMuslimCell
        let hsm_Contents = self.vm.index(indexPath.row)
        cell.displayData(list: hsm_Contents)
        cell.selectionStyle = .none
        return cell
    }
    

}



