//
//  HomeViewController.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 2/11/23.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {
    
    enum Section { case main }
    private var vm = HSMViewModel()
    private var filterContents = [Content]()
    private var isSearching: Bool = false
    private var tableView: UITableView!
    private var datasource: UITableViewDiffableDataSource<Section, Content>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeVC()
    }
    
    private func configureHomeVC() {
        UNUserNotificationCenter.current().delegate = self
        view.backgroundColor = .systemBackground
        configNavBar()
        ConfigureSearchController()
        configTableView()
        vm.delegate = self
        vm.getHSMData()
        configureDataSource()
    }
    
    private func configNavBar() {
        navigationItem.title = "حِصن المسلمِ"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func ConfigureSearchController() {
        let searchController                                    = UISearchController()
        searchController.searchResultsUpdater                   = self
        searchController.searchBar.placeholder                  = "ابحث ..."
        searchController.searchBar.searchTextField.textAlignment = .right
        searchController.obscuresBackgroundDuringPresentation   = false
        navigationItem.searchController                         = searchController
    }
    
    private func configTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HisnulMuslimCell.self, forCellReuseIdentifier: HisnulMuslimCell.identifier)
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

}

extension HomeViewController: HSMDelegate, UITableViewDelegate, UNUserNotificationCenterDelegate {
    
    func didFinishLoadingHSMData() {
        updateData(on: vm.hs_mslm)
        tableView.reloadDataOnMainThread()
    }
    
    func configureDataSource() {
        self.datasource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: HisnulMuslimCell.identifier, for: indexPath) as! HisnulMuslimCell
            let hsm_Contents = self.vm.index(indexPath.row)
            cell.displayData(list: hsm_Contents)
            cell.selectionStyle = .none
            return cell
        })
    }
    
    func updateData(on hsmContents: [Content]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Content>()
        snapShot.appendSections([.main])
        snapShot.appendItems(hsmContents)
        DispatchQueue.main.async {
            self.datasource.apply(snapShot, animatingDifferences: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activeArray = isSearching ? filterContents : vm.hs_mslm
        let selectedObj = activeArray[indexPath.row]
        let detailVC = DetailsViewController()
        detailVC.content = selectedObj
        let navigationController = UINavigationController(rootViewController: detailVC)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .coverVertical
        present(navigationController, animated: true, completion: nil)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
     
}

extension HomeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filterContents.removeAll()
            isSearching = false
            updateData(on: vm.hs_mslm)
            return
        }
        isSearching = true
        filterContents = vm.hs_mslm.filter { $0.title.contains(filter) }
        updateData(on: filterContents)
    }
    
}

