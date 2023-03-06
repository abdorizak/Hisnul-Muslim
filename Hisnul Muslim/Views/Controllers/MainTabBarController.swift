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
        viewControllers = [configHomeVC(), settingVC()]
        tabBar.selectionIndicatorImage = UIImage(named: "Selected")
        tabBar.layer.masksToBounds = true
        tabBar.layer.cornerRadius = 15
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.tintColor = UIColor(named: "TabBarTint")
    }
    
    private func configHomeVC() -> UINavigationController {
        let homeVC = HomeViewController()
        homeVC.tabBarItem.title = "Home"
        homeVC.tabBarItem.image = UIImage(systemName: "book")
        homeVC.tabBarItem.selectedImage = UIImage(systemName: "book.fil")
        return UINavigationController(rootViewController: homeVC)
    }
    
    private func settingVC() -> UINavigationController {
        let settingVC = SettingsViewController()
        settingVC.tabBarItem.title = "Settings"
        settingVC.tabBarItem.image = UIImage(systemName: "gearshape")
        settingVC.tabBarItem.selectedImage = UIImage(systemName: "gearshape.fil")
        return UINavigationController(rootViewController: settingVC)
    }

}
