//
//  SettingsViewController.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/4/23.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private struct Sections {
        let options: [SettingOptions]
    }
    private struct SettingOptions {
        let icon: UIImage?
        let title: String
        let handler: () -> Void?

    }
    private var models: [Sections] = []
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
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
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        configTableView()
        configTableHeaderView()
    }
    
    private func configTableView() {
        models.append(Sections(options: [
            SettingOptions(icon: Images.timeScheduled, title: "إشعارات", handler: {
                // Go to the Schedulers Notifications
                let schedulersVC = SchedulersListVC()
                return self.navigationController?.pushViewController(schedulersVC, animated: true)
                
            }),
            SettingOptions(icon: Images.bookInfo, title: "معلومات الكتاب", handler: {
                //
            })
        ]))
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configTableHeaderView() {
        let headerView = SettingTableHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 250))
        tableView.tableHeaderView = headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as! SettingsTableViewCell
        cell.displayData(title: model.title, Image: model.icon)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        45
    }
    
}
