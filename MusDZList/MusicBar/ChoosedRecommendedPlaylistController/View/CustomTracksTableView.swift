//
//  CustomTracksTableView.swift
//  MusDZList
//
//  Created by Denis Selivanov on 05.10.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

protocol CustomTracksTableViewDelegate: class {
    func presentAlertController()
}

class CustomTracksTableView: UITableView {
    
    var screenHeight: CGFloat?
    var screenWidht: CGFloat?
    
    var tracklist: RecomendModel?
    
    var choosedTrackListData = [RecommendTracklistDataModel]()
    var choosedList = [ChoosedList]()
    
    var height: NSLayoutConstraint?
    var bottom: NSLayoutConstraint?
    
    weak var alertVCDelegate: CustomTracksTableViewDelegate?

    init() {
        super.init(frame: .zero, style: .grouped)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        delegate = self
        dataSource = self
        register(ChoosedTableCell.self, forCellReuseIdentifier: String(describing: ChoosedTableCell.self))
        register(CustomHeaderTableView.self, forHeaderFooterViewReuseIdentifier: String(describing: CustomHeaderTableView.self))
        
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        
        isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        guard let header = headerView(forSection: 0) else {return}
        if let imageView = header.contentView.subviews.first as? UIImageView {
            height = imageView.constraints.filter{ $0.identifier == "height" }.first
            bottom = header.constraints.filter{ $0.identifier == "bottom" }.first
        }
        
        let offsetY = -contentOffset.y

        bottom?.constant = offsetY >= 0 ? 0 : offsetY / 2
        height?.constant = max(header.bounds.height, header.bounds.height + offsetY)

        header.clipsToBounds = offsetY <= 0

        guard let newImageView = header.contentView.subviews.first as? UIImageView else {return}
        
//        if offsetY <= -newImageView.frame.height / 3.2 {
//            UIView.animate(withDuration: 3, delay: 0, options: .curveEaseOut) {
////                let intend: CGFloat = -300
////                let transform = CGAffineTransform(translationX: 0, y: intend)
//                newImageView.alpha = 0.2
//            }
//        } else {
//            UIView.animate(withDuration: 10, delay: 0, options: .curveEaseOut) {
//                newImageView.alpha = 1
//            }
//        }
        
        if offsetY <= -newImageView.frame.height / 3.2 {
//            header.contentView.frame.size.height = 50
//            newImageView.frame.size.height = 50
            
        }

        print(offsetY)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CustomTracksTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choosedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: ChoosedTableCell.self), for: indexPath) as! ChoosedTableCell
        
        guard let image = choosedList[indexPath.item].image else {fatalError()}
        cell.nameOfSong.text = choosedList[indexPath.item].nameOfSong
        cell.titleOfArtistAndAlbum.text = choosedList[indexPath.item].artistName + " - " + choosedList[indexPath.item].albumName
        cell.albumImage.image = UIImage(data: image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        alertVCDelegate?.presentAlertController()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: CustomHeaderTableView.self)) as! CustomHeaderTableView
        
        guard let screenHeight = screenHeight, let tracklist = tracklist else {return nil}
        
        view.screenHeight = screenHeight / 2
        view.layoutIfNeeded()
        view.tracklistImage.image = UIImage(data: tracklist.image)
        
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let screenHeight = screenHeight else {fatalError()}
        return screenHeight / 2 - 50
    }
    
}
