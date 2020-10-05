//
//  HeaderViewTest.swift
//  MusDZList
//
//  Created by Denis Selivanov on 03.10.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

protocol RecommendedHeaderAndFooterDelegate: class {
    func openAllRecommendedResultsInNextController()
}

class RecommendedHeaderView: UICollectionReusableView {
        
    weak var delegate: RecommendedHeaderAndFooterDelegate?
    
    var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "RecommendBtn"), for: .normal)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(button)
        
        button.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -15).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    @IBAction func didTapButton(_ sender: AnyObject) {
        delegate?.openAllRecommendedResultsInNextController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
