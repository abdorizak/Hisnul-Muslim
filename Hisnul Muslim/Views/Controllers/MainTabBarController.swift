//
//  MainTabBarController.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/4/23.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confgiTabBar()
    }
    
    private func confgiTabBar() {
        view.backgroundColor = .systemBackground
        viewControllers = [configHomeVC(), configFavorites(), configSettingVC()]
        tabBar.selectionIndicatorImage = UIImage(named: "Selected")
        tabBar.layer.masksToBounds = true
        tabBar.layer.cornerRadius = 15
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.tintColor = UIColor(named: "TabBarTint")
        self.additionalSafeAreaInsets.bottom = 15
    }
    
    private func configHomeVC() -> UINavigationController {
        let homeVC = HomeViewController()
        homeVC.tabBarItem.title = "قائمة"
        homeVC.tabBarItem.image = UIImage(systemName: "book")
        homeVC.tabBarItem.selectedImage = UIImage(systemName: "book.fil")
        return UINavigationController(rootViewController: homeVC)
    }
    
    private func configSettingVC() -> UINavigationController {
        let settingVC = SettingsViewController()
        settingVC.tabBarItem.title = "Settings"
        settingVC.tabBarItem.image = UIImage(systemName: "gearshape")
        settingVC.tabBarItem.selectedImage = UIImage(systemName: "gearshape.fil")
        return UINavigationController(rootViewController: settingVC)
    }
    
    private func configFavorites() -> UINavigationController {
        let favoriteVC = AdkarFavoritesListVC()
        favoriteVC.title = "المفضلات"
        favoriteVC.tabBarItem.image = UIImage(named: "bookmark")
        favoriteVC.tabBarItem.selectedImage = UIImage(named: "bookmark.fill")
        return UINavigationController(rootViewController: favoriteVC)
    }

}

@available(iOS 17, *)
#Preview {
    let main_controller = MainTabBarController()
    return main_controller
}
