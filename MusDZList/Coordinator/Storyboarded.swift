//
//  Storyboarded.swift
//  MusDZList
//
//  Created by Denis Selivanov on 29.01.2021.
//  Copyright © 2021 Denis Selivanov. All rights reserved.
//

import Foundation
import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(identifier: id) as! Self
    }
}
