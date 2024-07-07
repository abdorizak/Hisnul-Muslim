//
//  SchedulersListVC.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/24/23.
//

import UIKit
import Combine

class SchedulersListVC: UIViewController  {
    
    private let vm                            = HSMSchedulerViewModel()
    private var cancellables                   = Set<AnyCancellable>()
    private lazy var dataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, row in
        switch row {
        case let .noSchedulers(icon, title, msg):
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyStateViewCell.identifier, for: indexPath) as! EmptyStateViewCell
            cell.displayData(title: title, message: msg, image: icon, iconSize: CGSize(width: 60, height: 60))
            cell.selectionStyle = .none
            return cell
            
        case .scheduler(let scheduler):
            let cell = tableView.dequeueReusableCell(withIdentifier: SchedulersListCell.identifier, for: indexPath) as! SchedulersListCell
            cell.displayData(list: scheduler)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    private lazy var tableView = {
        $0.delegate = self
        $0.keyboardDismissMode = .onDrag
        $0.separatorStyle = .none
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.register(EmptyStateViewCell.self)
        $0.register(SchedulersListCell.self)
        return $0
    }(UITableView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        bindViewModel()
    }
    
    
    
    func configureViewController() {
        view.backgroundColor    = .systemBackground
        title                   = "إشعارات"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func bindViewModel() {
        vm.event
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.handleEvent($0) }
            .store(in: &cancellables)
        
        vm.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.handleState($0) }
            .store(in: &cancellables)
    }

    func configureTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    private func handleEvent(_ event: HSMSchedulerViewModel.Event) {
        switch event {
        case .error(let error):
            self.presentAlertOnMainThread(title: "⛔️", message: error.localizedDescription)
        case .didRemoveScheduler:
            self.presentAlertOnMainThread(title: "نجاح", message: "لقد تم إلغاء الاشتراك في إرسال الإشعارات لهذا الدعاء")
            vm.getSchedulersData()
        }
    }
    
    private func handleState(_ state: HSMSchedulerViewModel.State) {
        var snapShot = Snapshot()
        snapShot.appendSections([.main])
        if state.schedulers.isEmpty {
            if !state.isLoading {
                snapShot.appendItems([.noSchedulers(UIImage(systemName: "bell.slash.fill") ?? .hisnulMuslimBook, "لا يوجد إشعارات", "ليس لديك أي إشعارات مجدولة، قم بإضافة إشعارات جديدة")])
            }
        } else {
            snapShot.appendItems(state.schedulers.map { .scheduler($0) })
            
        }
        dataSource.applyOnMainThread(snapShot, animatingDifferences: true)
    }
}


extension SchedulersListVC {
    typealias DataSource = UITableViewDiffableDataSource<Section, Row>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    enum Section: CaseIterable {
        case main
    }
    
    enum Row: Hashable {
        case noSchedulers(UIImage, String, String), scheduler(HSMSchedulers)
        
        static func == (lsh: Row, rhs: Row) -> Bool {
            lsh.hashValue == rhs.hashValue
        }
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case let .noSchedulers(icon, title, subtitle):
                hasher.combine(values: "noSchedulers", icon, title, subtitle)
            case .scheduler(let hSMSchedulers):
                hasher.combine(hSMSchedulers.id)
            }
        }
    }
}

extension SchedulersListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
//        let selectedObj = vm.schedulers[indexPath.item]
//        vm.deleteNotification(withID: selectedObj.id!) { [weak self] result in
//            switch result {
//            case .success( _):
//                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [selectedObj.id!.uuidString])
//                self?.vm.schedulers.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .right)
//                DispatchQueue.main.async {
//                    self?.presentAlert(title: "نجاح", message: "لقد تم إلغاء الاشتراك في إرسال الإشعارات لهذا الدعاء: \(selectedObj.adkarName ?? "N/A")", buttonTitle: "OK")
//
//
//                }
//            case .failure(let err):
//                DispatchQueue.main.async {
//                    self?.presentAlert(title: "⛔️", message: err.localizedDescription, buttonTitle: "OK!")
//                }
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let row = dataSource.itemIdentifier(for: indexPath) else { return nil }
        
        switch row {
        case .scheduler(let content):
            let deleteAction = UIContextualAction(
                style: .destructive,
                title: "Delete"
            ) { [weak self] _, _, completionHandler in
                self?.vm.deleteNotification(withID: content.id!)
                completionHandler(true)
            }
            deleteAction.backgroundColor = .systemRed
            return UISwipeActionsConfiguration(actions: [deleteAction])
        default:
            return nil
        }
    }
    
}
