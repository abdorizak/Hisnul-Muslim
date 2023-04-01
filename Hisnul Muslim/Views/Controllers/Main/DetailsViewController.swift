//
//  DetailsViewController.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/8/23.
//

import UIKit

class DetailsViewController: UIViewController {
    enum Section { case main }
    var content: Content!
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Page>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureDetailViewController()
    }
    
    private func configureDetailViewController() {
        view.backgroundColor = .systemBackground
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFavorite))
        let notifyMe = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .done, target: self, action: #selector(notifyMe))
        navigationItem.rightBarButtonItems = [notifyMe, addBtn]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), landscapeImagePhone: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(didTapBack))
        navigationItem.title = content.title
//        navigationController?.navigationBar.prefersLargeTitles = false
        configureCollectionView()
        configureDataSource()
        updateUI()
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .tertiarySystemFill
        collectionView.register(DetailsCollectionViewCell.self, forCellWithReuseIdentifier: DetailsCollectionViewCell.identifier)
        view.addSubview(collectionView)
        collectionView.delegate = self
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc func addFavorite() {
        let favorite = Content(id: content.id, title: content.title, pages: content.pages)
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            
            guard let error = error else {
                self.presentAlert(title: "Success!", message: "You have successfull favorite this user 🎉", buttonTitle: "Ok")
                return
            }
            self.presentAlert(title: "Something Wrong", message: error.rawValue, buttonTitle: "ok")
        }
    }
    
    @objc func notifyMe() {
        // check if the user autorized to send notifications
        if SchedulerNotifications.shared.isUserAllowNotification {
            let schedulerVC = SchedulerNotificationViewController()
            schedulerVC.content = self.content
            schedulerVC.modalPresentationStyle = .pageSheet
            schedulerVC.sheetPresentationController?.detents = [.medium()]
            schedulerVC.sheetPresentationController?.preferredCornerRadius = 20
            schedulerVC.sheetPresentationController?.prefersGrabberVisible = true
            present(schedulerVC, animated: true)
        } else {
            let alertController = UIAlertController(title: "تحذير", message: "تحتاج إلى السماح للتطبيق بإرسال الإشعارات. يرجى الذهاب إلى إعدادات الجهاز لتمكين الإشعارات.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }))
            DispatchQueue.main.async { [weak self] in
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    @objc func didTapBack() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension DetailsViewController {
    
    func updateUI() {
        self.updateData(on: content)
        DispatchQueue.main.async { [self] in
            self.collectionView.reloadData()
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCollectionViewCell.identifier, for: indexPath) as! DetailsCollectionViewCell
            let pages_need_to_display = self.content.pages[indexPath.item]
            cell.displayContents(of: pages_need_to_display)
            return cell
        })
    }
    
    func updateData(on pages: Content) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Page>()
        snapShot.appendSections([.main])
        snapShot.appendItems(pages.pages)
        DispatchQueue.main.async {
            self.dataSource.apply(snapShot, animatingDifferences: true)
        }
    }
    
}

extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.height)
    }
    
}
