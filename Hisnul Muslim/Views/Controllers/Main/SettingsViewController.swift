//
//  SettingsViewController.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/4/23.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private lazy var dataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, row in
        switch row {
            
        case .notification:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
            cell.displayData(title: "إشعارات", Image: Images.timeScheduled)
            return cell
            
        case .about:
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
            cell.displayData(title: "معلومات الكتاب", Image: Images.bookInfo)
            return cell
            
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SettingsTableViewCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSVC()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        configTableHeaderView()
    }
    
    private func configureSVC() {
        view.backgroundColor = .systemBackground
        title = "اختيارات"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate = self
        configTableView()
        configTableHeaderView()
    }
    
    private func configTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems([.notification, .about])
        dataSource.applyOnMainThread(snapshot, animatingDifferences: true)
    }
    
    
    
    
    
}

extension SettingsViewController {
    typealias DataSource = UITableViewDiffableDataSource<Section, Row>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    
    enum Section: CaseIterable {
        case main
    }
    
    enum Row: Hashable {
        case notification
        case about
        
        static func == (lhs: Row, rhs: Row) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .notification:
                hasher.combine("notification")
            case .about:
                hasher.combine("about")
            }
        }
    }
    //    struct SettingOptions: Hashable {
    //        let icon: UIImage?
    //        let title: String
    //        let handler: () -> Void?
    //    }
}

extension SettingsViewController: UITableViewDelegate {
    private func configTableHeaderView() {
        let headerView = SettingTableHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 250))
        tableView.tableHeaderView = headerView
    }
    
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        models.count
    //    }
    
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        models[section].options.count
    //    }
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let model = models[indexPath.section].options[indexPath.row]
    //        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
    //        cell.displayData(title: model.title, Image: model.icon)
    //        cell.selectionStyle = .none
    //
    //        return cell
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let row = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch row {
        case .notification:
            let schedulersVC = SchedulersListVC()
            let nv = UINavigationController(rootViewController: schedulersVC)
            self.present(nv, animated: true)
        case .about:
            let aboutVC = AboutViewController()
            aboutVC.modalTransitionStyle = .crossDissolve
            aboutVC.modalPresentationStyle = .pageSheet
            self.present(aboutVC, animated: true)
        }
            
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        45
    }
}
