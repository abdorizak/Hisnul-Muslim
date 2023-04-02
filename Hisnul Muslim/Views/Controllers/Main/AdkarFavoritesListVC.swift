//
//  AdkarFavoritesListVC.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/14/23.
//

import UIKit

class AdkarFavoritesListVC: HSDataLoadingVC {
    
    let tableView               = UITableView()
    var favorites: [Content]    = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }
    
    
    func configureViewController() {
        view.backgroundColor    = .systemBackground
        title                   = "المفضلات"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame         = view.bounds
        tableView.rowHeight     = 80
        tableView.delegate      = self
        tableView.dataSource    = self
        tableView.removeExcessCells()
        
        tableView.register(AdkarFavoriteCell.self, forCellReuseIdentifier: AdkarFavoriteCell.identifier)
    }
    
    
    func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let favorites):
                self.updateUI(with: favorites)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentAlert(title: "هناك خطأ ما", message: error.rawValue, buttonTitle: "Ok")
                }
            }
        }
    }
    
    
    func updateUI(with favorites: [Content]) {
        if favorites.isEmpty {
            self.showEmptyStateView(with: "لا يوجد هنا أي مفضلات", in: self.view)
        } else  {
            self.favorites = favorites
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
}


extension AdkarFavoritesListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AdkarFavoriteCell.identifier) as! AdkarFavoriteCell
        let favorite = favorites[indexPath.row]
        cell.displayData(list: favorite)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedObj = favorites[indexPath.item]
        let detailVC = DetailsViewController()
        detailVC.content = selectedObj
        let navigationController = UINavigationController(rootViewController: detailVC)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .coverVertical
        present(navigationController, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        PersistenceManager.updateWith(favorite: favorites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                return
            }
            
            DispatchQueue.main.async {
                self.presentAlert(title: "غير قادر على الإزالة", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

