//
//  Coordinator.swift
//  MusDZList
//
//  Created by Denis Selivanov on 29.01.2021.
//  Copyright © 2021 Denis Selivanov. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
