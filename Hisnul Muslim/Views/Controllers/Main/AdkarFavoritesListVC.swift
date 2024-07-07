//
//  AdkarFavoritesListVC.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/14/23.
//

import UIKit
import Combine

class AdkarFavoritesListVC: UIViewController {
    
    
    var vm = AdkarFavoritesListViewModel()
    private var cancellables = Set<AnyCancellable>()
    private lazy var dataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, row in
        switch row {
        case let .noFavorites(image, text, secondaryText):
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyStateViewCell.identifier, for: indexPath) as! EmptyStateViewCell
            cell.displayData(title: text, message: secondaryText, image: image, iconSize: CGSize(width: 50, height: 50))
            return cell
        case let .favorite(content):
            let cell = tableView.dequeueReusableCell(withIdentifier: AdkarFavoriteCell.identifier, for: indexPath) as! AdkarFavoriteCell
            cell.displayData(list: content)
            return cell
        }
    }
    
    
    private lazy var tableView = {
        $0.delegate = self
        $0.separatorStyle = .none
        $0.keyboardDismissMode = .onDrag
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.register(EmptyStateViewCell.self)
        $0.register(AdkarFavoriteCell.self)
        return $0
    }(UITableView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.getFavorites()
    }
    
    
    func configureViewController() {
        view.backgroundColor    = .systemBackground
        title                   = "المفضلات"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
    
    private func handleEvent(_ event: AdkarFavoritesListViewModel.Event) {
        switch event {
        case .error(let error):
            self.presentAlertOnMainThread(title: "Error", message: error.localizedDescription)
        case .didRemoveFavorite:
            self.presentAlertOnMainThread(title: "تم الحذف", message: "تم حذف الدعاء من المفضلة بنجاح")
        }
    }
    
    private func handleState(_ state: AdkarFavoritesListViewModel.State) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        
        if state.favorites.isEmpty {
            if !state.isLoading {
                snapshot.appendItems([.noFavorites(UIImage(systemName: "bookmark.fill") ?? .hisnulMuslimBook, "لا يوجد هنا أي مفضلات", "ليس لديك أي أدعية مفضلة، أضف اذهب وقم بتفعيل الأدعية المفضلة لديك")], toSection: .main)
            }
        } else {
            snapshot.appendItems(state.favorites.map { .favorite($0) }, toSection: .main)
        }
        
        dataSource.applyOnMainThread(snapshot, animatingDifferences: true)
    }
    
}


extension AdkarFavoritesListVC {
    typealias DataSource = UITableViewDiffableDataSource<Section, Row>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    enum Section: CaseIterable {
        case main
    }
    
    enum Row: Hashable {
        
        case noFavorites(UIImage, String, String), favorite(Content)
        
        static func == (lhs: Row, rhs: Row) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case let .noFavorites(image, text, secondaryText):
                hasher.combine(values: "noFavorites", image, text, secondaryText)
            case let .favorite(content):
                hasher.combine(values: "favorite", content)
            }
        }
        
    }
}

extension AdkarFavoritesListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let row = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch row {
        case .noFavorites:
            break
        case .favorite(let content):
            let detailVC = DetailsViewController()
            detailVC.vm = .init(content: content)
            let navigationController = UINavigationController(rootViewController: detailVC)
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.modalTransitionStyle = .coverVertical
            present(navigationController, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let row = dataSource.itemIdentifier(for: indexPath) else { return nil }
        
        switch row {
        case .favorite(let content):
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
                self?.vm.removeFavorite(favorite: content)
                completionHandler(true)
            }
            deleteAction.backgroundColor = .systemRed
            return UISwipeActionsConfiguration(actions: [deleteAction])
        default:
            return nil
        }
    }
}

//#Preview {
//    let favoriteVC = AdkarFavoritesListVC()
//    return favoriteVC
//}

