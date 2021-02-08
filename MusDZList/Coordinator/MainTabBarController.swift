//
//  MainTabBarController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 01.02.2021.
//  Copyright © 2021 Denis Selivanov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainTabBarController: UITabBarController, Storyboarded {

    weak var coordinator: MainTabBarCoordinator?

    let logoutBarButton = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: nil)

    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = logoutBarButton
        navigationItem.hidesBackButton = true

        logoutBarButton.rx.tap
            .subscribe { (event) in
                print("asdad")
                self.coordinator?.navigationController.navigationBar.isHidden = true
                self.coordinator?.navigationController.popToRootViewController(animated: true)
            }
            .disposed(by: bag)
    }

    func tabBarConstructor() {
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .white
        vc1.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
//        let vc2 = UIViewController()
//        vc2.view.backgroundColor = .cyan
//        vc2.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        viewControllers = [vc1]
    }

}
