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
        searchBar.placeholder = "Artists, tracks, playlists..."
        searchBar.layer.borderWidth = 2
        searchBar.layer.borderColor = .init(srgbRed: 120, green: 201, blue: 184, alpha: 1)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    var tableView: UITableView!
    
    private var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "TextField"
        textField.backgroundColor = .gray
//        textField.layer.cornerRadius = textField.frame.size.height / 20
        textField.layer.cornerRadius = 15
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var searchLabel: UILabel = {
        let label = UILabel()
        label.text = "Search"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        setSearch()
        
    }
    
    private func setTableView() {
        view.addSubview(tableView)
        
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 50).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        //searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        //tableView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    private func setSearch() {
        view.addSubview(searchBar)
        
        searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        //searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        searchBar.widthAnchor.constraint(equalToConstant: 200).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

}

extension SearchController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        testNetworkingFor(searching: searchText.lowercased())
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(searchBar.text ?? " ")
        
        //testNetworkingFor(searching: searchBar.text)
        getTestDataForSearch(searchText: searchBar.text) { (data) in
            print(String(data: data, encoding: .utf8))
            self.tableView = SearchTableView.init()
            self.setTableView()
        }
        
        
        
    }
    
    
}

//MARK: - Network for Search

extension SearchController {
    
    func testNetworkingFor(searching searchText: String?) {
        
        guard let searchText = searchText, let url = URL(string: "https://api.deezer.com/search?q=artist:\'\(searchText)\'") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let response = response else {return}
            print(response)
            
            guard let data = data else {return}
            
            let save = String(data: data, encoding: .utf8)
            print(save)
            
        }.resume()
    }
    
    func getTestDataForSearch(searchText: String?, completion: @escaping (_ data: Data)->()) {
        
        guard let searchText = searchText, let url = URL(string: "https://api.deezer.com/search?q=artist:\'\(searchText)\'") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    completion(data)
                }
            }
        } .resume()
    }
    
}

