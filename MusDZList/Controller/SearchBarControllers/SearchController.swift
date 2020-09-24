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
//        textField.layer.cornerRadius = textField.frame.size.height / 20
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
        tableView.separatorStyle = .none
    }
    
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
    }
    
}

extension SearchController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        goLoadAndShowSearchInfo(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        goLoadAndShowSearchInfo(searchText: searchBar.text)
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
        
//        let searchBarText = ""
        self.searchBar.endEditing(true)
        searchBar.text = ""
        tableView.isHidden = true
        //goLoadAndShowSearchInfo(searchText: searchBarText)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.searchBar.endEditing(true)
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
    
    func testFunc() {
        
    }
    
    func getTestDataForSearch(searchText: String?, completion: @escaping (_ data: Data)->()) {
        
        guard let searchText = searchText, let url = URL(string: "https://api.deezer.com/search?q=\(searchText)") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    completion(data)
                }
            }
        } .resume()
    }
    
    func goLoadAndShowSearchInfo(searchText: String?) {
        
        guard let searchText = searchText else {return}
        tableView.someArray = []
        getTestDataForSearch(searchText: searchText) { (data) in
            
            do {
                let decodingData = try JSONDecoder().decode(SearchData.self, from: data)
                
                for result in decodingData.data {
                    self.tableView.someArray.append(result.title)
                }
            } catch {
                print(error.localizedDescription)
            }
            
            if searchText == "" {
                self.tableView.isHidden = true
            } else {
                self.tableView.isHidden = false
//                self.setTableView()
                self.tableView.reloadData()
            }
            
        }
    }
    
}

