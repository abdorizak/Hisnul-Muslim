//
//  HomeViewController.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 2/11/23.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    private var vm = HSMViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    private lazy var dataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, row in
        switch row {
        case let .noData(icon, title, msg):
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyStateViewCell.identifier, for: indexPath) as! EmptyStateViewCell
            cell.displayData(title: title, message: msg, image: icon)
            return cell
        case .suplications(let content):
            let cell = tableView.dequeueReusableCell(withIdentifier: HisnulMuslimCell.identifier, for: indexPath) as! HisnulMuslimCell
            cell.displayData(list: content)
            return cell
        }
        
    }
    
    private lazy var searchBar = {
        $0.placeholder = "ابحث ..."
        $0.searchBarStyle = .minimal
        $0.delegate = self
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UISearchBar())
    
    private lazy var tableView = {
        $0.delegate = self
        $0.separatorStyle = .none
        $0.keyboardDismissMode = .onDrag
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.register(EmptyStateViewCell.self)
        $0.register(HisnulMuslimCell.self)
        return $0
    }(UITableView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeVC()
        bindToView()
    }
    
    private func configureHomeVC() {
        UNUserNotificationCenter.current().delegate = self
        view.backgroundColor = .systemBackground
        view.addSubViews(searchBar, tableView)
        configNavBar()
        configureSearchBar()
        configTableView()
    }
    
    private func configNavBar() {
        navigationItem.title = "حِصن المسلمِ"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureSearchBar() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    private func configTableView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    
    func bindToView() {
        
        vm
            .event
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.handleEvent($0) }
            .store(in: &cancellables)
        
        vm
            .$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.handleState($0) }
            .store(in: &cancellables)
    }

    private func handleEvent(_ event: HSMViewModel.Event) {
        switch event {
        case .error(let hSErrors):
            self.presentAlertOnMainThread(title: "Error", message: hSErrors.localizedDescription)
        default:
            break
        }
    }
    
    private func handleState(_ state: HSMViewModel.State) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        if state.filteredHs_mslm.isEmpty {
            snapshot.appendItems([.noData(.hisnulMuslimBook, "No Data", "No data found")], toSection: .main)
        } else {
            snapshot.appendItems(state.filteredHs_mslm.map { .suplications($0) }, toSection: .main)
        }
        self.dataSource.applyOnMainThread(snapshot, animatingDifferences: true)
    }
    
}

extension HomeViewController: UITableViewDelegate, UNUserNotificationCenterDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case .noData:
            break
        case .suplications(let content):
            let vc = DetailsViewController()
            vc.vm = .init(content: content)
            let nv = UINavigationController(rootViewController: vc)
            nv.modalPresentationStyle = .fullScreen
            present(nv, animated: true)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text, text.isNotBlank {
            vm.event.send(.search(text))
        } else {
            vm.event.send(.searchCancel)
        }
    }
}

extension HomeViewController {
    typealias DataSource = UITableViewDiffableDataSource<Section, Row>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    enum Section: CaseIterable {
        case main
    }
    
    enum Row: Hashable {
        
        case
            noData(UIImage, String, String),
            suplications(Content)
        
        static func == (lhs: Row, rhs: Row) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case let .noData(icon, title, msg):
                hasher.combine(values: "noData", icon, title, msg)
            case .suplications(let content):
                hasher.combine(content.id)
            }
        }
    }
    
    
}

//#Preview {
//    HomeViewController()
//}
