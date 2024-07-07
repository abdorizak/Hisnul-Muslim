//
//  DetailsViewController.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/8/23.
//

import UIKit
import Combine

class DetailsViewController: UIViewController {
    //    var content: Content!
    var vm: DetailsViewModel!
    private var cancellables = Set<AnyCancellable>()
    private lazy var dataSource = DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, row in
        switch row {
        case .page(let page):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCollectionViewCell.identifier, for: indexPath) as! DetailsCollectionViewCell
            cell.displayContents(of: page)
            cell.contentView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            return cell
        }
    }
    
    private lazy var pageController: UIPageControl = {
        $0.numberOfPages = vm.state.details.pages.count
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        $0.backgroundStyle = .prominent
        $0.currentPageIndicatorTintColor = .label
        $0.pageIndicatorTintColor = .systemGray
        return $0
    }(UIPageControl())
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.alwaysBounceHorizontal = true
        collectionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DetailsCollectionViewCell.self, forCellWithReuseIdentifier: DetailsCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureDetailViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCollectionViewLayout()
    }
    
    private func configureDetailViewController() {
        UNUserNotificationCenter.current().delegate = self
        view.backgroundColor = .systemBackground
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFavorite))
        let notifyMe = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .done, target: self, action: #selector(notifyMe))
        navigationItem.rightBarButtonItems = [notifyMe, addBtn]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), landscapeImagePhone: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(didTapBack))
        navigationItem.title = vm.state.details.title
        configureCollectionView()
        bindViewModel()
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
    
    private func configureCollectionView() {
        view.addSubViews(collectionView, pageController)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            pageController.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            pageController.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -4),
        ])
    }
    
    private func setCollectionViewLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = collectionView.bounds.size
        }
    }
    
    private func handleEvent(_ event: DetailsViewModel.Event) {
        switch event {
        case .showMessage(let title, let message, let type):
            presentAlertOnMainThread(title: title, message: message, type: type)
        case .didNotify(let content):
            self.showNotificationScheduler(content)
        default:
            break
        }
    }
    
    private func handleState(_ state: DetailsViewModel.State) {
        var snapShot = Snapshot()
        snapShot.appendSections([.main])
        snapShot.appendItems(state.details.pages.map { .page($0) })
        pageController.isHidden = state.details.pages.count <= 1
        dataSource.applyOnMainThread(snapShot, animatingDifferences: true)
    }
    
    private func showNotificationScheduler(_ content: Content) {
        let schedulerVC = SchedulerNotificationViewController()
        schedulerVC.content = content
        schedulerVC.modalPresentationStyle = .pageSheet
        schedulerVC.sheetPresentationController?.detents = [.medium()]
        schedulerVC.sheetPresentationController?.preferredCornerRadius = 20
        schedulerVC.sheetPresentationController?.prefersGrabberVisible = true
        present(schedulerVC, animated: true)
    }
    
    @objc func addFavorite() {
        vm.addFavorite(vm.state.details)
    }
    
    @objc func notifyMe() {
        vm.checkNotificationAccess()
    }
    
    @objc func didTapBack() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension DetailsViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    enum Section: CaseIterable { case main }
    
    enum Row: Hashable {
        case page(Page)
        
        static func == (lhs: Row, rhs: Row) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .page(let page):
                hasher.combine(page.page)
            }
        }
    }
    
}

extension DetailsViewController: UICollectionViewDelegateFlowLayout, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageController.currentPage = Int(pageIndex)
    }
    
}
