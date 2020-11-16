//
//  ChoosedRecommendedPlaylistController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 04.10.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class ChoosedRecommendedPlaylistController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .black
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var tracklist: RecomendModel?
    
    let tableView = CustomTracksTableView()
    let networking = NetworkingChoosedRecommendedTrackList()
    var testModelList = [ChoosedList]()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        testNetworking()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setView()
        tableView.screenHeight = self.view.frame.height - 88
        
        tableView.tracklist = tracklist
        
        setNavBarButtons()
        
        tableView.layoutIfNeeded()
    }
    
    func setView() {
        view.addSubview(tableView)
        tableView.alertVCDelegate = self
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.rowHeight = self.view.frame.width / 6
        
        view.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setNavBarButtons() {
        let checkTableHeader = UIBarButtonItem(image: UIImage(systemName: "bell.fill"), style: .plain, target: self, action: #selector(checkHeader))
        
        self.navigationItem.rightBarButtonItems = [checkTableHeader]
    }
    
    @objc func checkHeader() {
        
        if (tableView.headerView(forSection: 0) != nil) == true {
            print("Header is not nil")
        }
    }

}

extension ChoosedRecommendedPlaylistController {
    
    
    func testNetworking() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let tracklistUrl = self.tracklist?.data.tracklist else {return}
            self.networking.getTestChoosedListOfDataFinally(tracklistURL: tracklistUrl) {
                self.tableView.choosedList = self.networking.choosedModelList
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

extension ChoosedRecommendedPlaylistController: CustomTracksTableViewDelegate {
    
    func presentAlertController() {
        let alertVC = UIAlertController(title: "Sorry, but now it doesn't work", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)

        alertVC.addAction(action)

        present(alertVC, animated: true, completion: nil)
        
        print("Delegate was activated")
    }
}


