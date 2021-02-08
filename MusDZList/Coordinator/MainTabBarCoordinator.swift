//
//  HomeMusicCoordinator.swift
//  MusDZList
//
//  Created by Denis Selivanov on 05.02.2021.
//  Copyright © 2021 Denis Selivanov. All rights reserved.
//

import UIKit

class MainTabBarCoordinator: Coordinator {

    weak var parentCoordinator: MainCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let tabbar = MainTabBarController.instantiate()
        navigationController.navigationBar.isHidden = false
        tabbar.coordinator = self
        navigationController.pushViewController(tabbar, animated: false)
    }
    
}
