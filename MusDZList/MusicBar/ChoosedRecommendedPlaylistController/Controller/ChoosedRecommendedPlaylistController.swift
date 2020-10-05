//
//  ChoosedRecommendedPlaylistController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 04.10.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class ChoosedRecommendedPlaylistController: UIViewController {
    
    
    var tracklist: RecomendModel?
    
    var viewForImage: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var tracklistImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .green
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
        print(tracklist?.data.tracklist)
        print(tracklist?.image)
        
        setView()
//        self.view.layoutIfNeeded()
//        print(viewForImage.heightAnchor.hashValue)
//        print(viewForImage.frame.size.width)
        print(view.frame.size.height)
        print(view.frame.size.width)
        print(viewForImage.frame.size.height)
        print(viewForImage.frame.width)
    }
    
    func setView() {
        view.addSubview(viewForImage)
        viewForImage.addSubview(tracklistImage)
        
        viewForImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 88).isActive = true
        viewForImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        viewForImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        viewForImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5, constant: -88).isActive = true
        self.view.layoutIfNeeded()
//        tracklistImage.topAnchor.constraint(equalTo: viewForImage.topAnchor, constant: 5).isActive = true
        tracklistImage.centerXAnchor.constraint(equalTo: viewForImage.centerXAnchor).isActive = true
        tracklistImage.centerYAnchor.constraint(equalTo: viewForImage.centerYAnchor).isActive = true
        tracklistImage.heightAnchor.constraint(equalToConstant: viewForImage.frame.width / 2).isActive = true
        tracklistImage.widthAnchor.constraint(equalToConstant: viewForImage.frame.width / 2).isActive = true
    }

}
