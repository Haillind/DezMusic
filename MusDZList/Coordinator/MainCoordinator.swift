//
//  MainCoordinator.swift
//  MusDZList
//
//  Created by Denis Selivanov on 29.01.2021.
//  Copyright © 2021 Denis Selivanov. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = AuthorizationViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }

    func testContoler() {
        let vc = HomeMusicViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }

    func homeMusicBar() {
        let tabbar = MainTabBarController.instantiate()
        tabbar.coordinator = self
//        tabbar.modalPresentationStyle = .pageSheet
//        navigationController.present(tabbar, animated: true, completion: nil)
        navigationController.pushViewController(tabbar, animated: true)
//        navigationController.show(tabbar, sender: self)
    }
}
