//
//  BaseTabBarController.swift
//  JetDevsHomeWork
//
//  Created by Gary.yao on 2021/10/29.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

		self.configureViewControllers()
        // Do any additional setup after loading the view.
    }

	private func configureViewControllers() {
		
		let homeViewController = UINavigationController(rootViewController: HomeViewController())
		let homeItem = UITabBarItem(
			title: "Home",
			image: UIImage(named: "icon_home_default"),
			selectedImage: UIImage(named: "icon_home_selected")
		)
		homeViewController.tabBarItem = homeItem
		
		let accountViewController = UINavigationController(rootViewController: AccountViewController())
		let accountItem = UITabBarItem(
			title: "Profile",
			image: UIImage(named: "icon_profile_default"),
			selectedImage: UIImage(named: "icon_profile_selected")
		)
		accountViewController.tabBarItem = accountItem
		
		self.view.backgroundColor = .white
		self.tabBar.barTintColor = .white
		self.tabBar.isTranslucent = false
		
		UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.latoRegularFont(size: 10), .foregroundColor: UIColor(red: 0.511, green: 0.514, blue: 0.533, alpha: 1)], for: .normal)
		UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.latoRegularFont(size: 10), .foregroundColor: UIColor.black], for: .selected)
		
		self.viewControllers = [
			homeViewController,
			accountViewController
		]
	}
}
