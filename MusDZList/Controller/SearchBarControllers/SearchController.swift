//
//  SearchController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 10.08.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class SearchController: UIViewController {
    
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearch()
    }
    
    private func setSearch() {
        view.addSubview(searchBar)
        
        searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 15).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        //searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        searchBar.widthAnchor.constraint(equalToConstant: 200).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

}
