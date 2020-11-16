//
//  SearchController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 10.08.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class SearchController: UIViewController {
    
    var tableView = SearchTableView()
    
    let decoderJSON = DecoderJSON()
    
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Artists, tracks, playlists..."
        searchBar.layer.borderWidth = 2
        searchBar.layer.borderColor = .init(srgbRed: 120, green: 201, blue: 184, alpha: 1)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "TextField"
        textField.backgroundColor = .gray
        textField.layer.cornerRadius = 15
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var searchLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue Bold", size: 40)
        label.text = "Search"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        setSearchLabel()
        setSearch()
        setTableView()
    }
    
}

//MARK: - SearchBar Delegate Methods

extension SearchController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        testNetworkServiceWithDecode(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        testNetworkServiceWithDecode(searchText: searchBar.text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(true, animated: true)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            let intend: CGFloat = -68
            let transform = CGAffineTransform(translationX: 0, y: intend)
            
            self.searchLabel.transform = transform
            self.searchLabel.alpha = 0
            self.searchBar.transform = transform
            self.tableView.transform = transform
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(false, animated: true)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.searchLabel.transform = .identity
            self.searchLabel.alpha = 1
            self.searchBar.transform = .identity
            self.tableView.transform = .identity
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBar.endEditing(true)
        searchBar.text = ""
        tableView.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.searchBar.endEditing(true)
    }
    
}

//MARK: - Network for Search

extension SearchController {
    
    private func testNetworkServiceWithDecode(searchText: String?) {
        
        tableView.cellsData = []
        
        if searchText == "" {
            self.tableView.isHidden = true
        }
        
        guard let searchText = searchText, let url = URL(string: "https://api.deezer.com/search?q=\(searchText)") else { return }
        
        NetworkService.shared.getDataFromServer(url: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            self.decoderJSON.decodeToJSON(data: data, toDecode: SearchData.self) { (decodeData) in
                
                var cellsData = [SearchData.SearchResult]()
                
                for result in decodeData.data {
                    cellsData.append(result)
                }
                
                self.tableView.set(cells: cellsData)
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
    }
    
}

//MARK: - Constraints for UI elements

extension SearchController {
    
    private func setSearchLabel() {
        view.addSubview(searchLabel)
        
        searchLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 68).isActive = true
        searchLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        searchLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func setSearch() {
        view.addSubview(searchBar)
        
        searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: 15).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setTableView() {
        view.addSubview(tableView)
        
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 15).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        tableView.separatorStyle = .none
    }
    
}

