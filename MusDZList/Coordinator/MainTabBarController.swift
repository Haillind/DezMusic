//
//  MainTabBarController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 01.02.2021.
//  Copyright © 2021 Denis Selivanov. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, Storyboarded {

    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tabBarConstructor()
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
