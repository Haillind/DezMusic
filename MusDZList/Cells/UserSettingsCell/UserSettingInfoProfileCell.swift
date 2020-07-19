//
//  UserSettingInfoProfileCell.swift
//  MusDZList
//
//  Created by Denis Selivanov on 16.07.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class UserSettingInfoProfileCell: UITableViewCell {
    
    static var userSettingInfoProfileCellId = "UserSettingInfoProfileCell"
    
    let viewForProfileImage: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: 80, height: 80) // 80 - 80
        view.layer.cornerRadius = view.frame.size.height / 2
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let profileName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let followersView: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: 60, height: 30)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        label.text = "0\nFollowers"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let followingView: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: 60, height: 30)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.text = "0\nFollowing"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let wallViewBetweenFollowersViews: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let followerHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let followerVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var followersBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(followerButtonTaped), for: .touchUpInside)
        return button
    }()
    
    lazy var followingBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(followingButtonTaped), for: .touchUpInside)
        return button
    }()
    
    @objc func followerButtonTaped() {
        print("Follower button was taped")
    }
    
    @objc func followingButtonTaped() {
        print("Following button was taped")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        addUIElementsIntoController()
        setImageConstraints()
        setStackViewsConstraints()
    }
    
    func addUIElementsIntoController() {
        viewForProfileImage.addSubview(iconImage)
        addSubview(viewForProfileImage)
        
        followersView.addSubview(followersBtn)
        followersView.addSubview(followersLabel)
        
        followingView.addSubview(followingBtn)
        followingView.addSubview(followingLabel)
        
        followerHorizontalStackView.addArrangedSubview(followersView)
        followerHorizontalStackView.addArrangedSubview(wallViewBetweenFollowersViews)
        followerHorizontalStackView.addArrangedSubview(followingView)
        addSubview(followerHorizontalStackView)
        
        followerVerticalStackView.addArrangedSubview(profileName)
        followerVerticalStackView.addArrangedSubview(followerHorizontalStackView)
        addSubview(followerVerticalStackView)
    }
    
    func setImageConstraints() {
        
        viewForProfileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        viewForProfileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        viewForProfileImage.heightAnchor.constraint(equalToConstant: viewForProfileImage.frame.size.height).isActive = true
        viewForProfileImage.widthAnchor.constraint(equalToConstant: viewForProfileImage.frame.size.width).isActive = true
        
        iconImage.centerXAnchor.constraint(equalTo: viewForProfileImage.centerXAnchor).isActive = true
        iconImage.centerYAnchor.constraint(equalTo: viewForProfileImage.centerYAnchor).isActive = true
        iconImage.frame = viewForProfileImage.frame
        
    }
    
    func setStackViewsConstraints() {
        
        //Constraints horizontal stackView and UI elements inside him
        followerHorizontalStackView.leadingAnchor.constraint(equalTo: followerVerticalStackView.leadingAnchor).isActive = true
        followerHorizontalStackView.topAnchor.constraint(equalTo: profileName.bottomAnchor).isActive = true
        followerHorizontalStackView.heightAnchor.constraint(equalTo: followerVerticalStackView.heightAnchor, multiplier: 0.6).isActive = true
        
        followersView.heightAnchor.constraint(equalToConstant: followersView.frame.size.height).isActive = true
        followersView.widthAnchor.constraint(equalToConstant: followersView.frame.size.width).isActive = true
        
        wallViewBetweenFollowersViews.heightAnchor.constraint(equalToConstant: followingView.frame.size.height).isActive = true
        wallViewBetweenFollowersViews.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        followingView.heightAnchor.constraint(equalToConstant: followingView.frame.size.height).isActive = true
        followingView.widthAnchor.constraint(equalToConstant: followingView.frame.size.width).isActive = true
        
        //Constraints for VerticalStackView Followers
        followerVerticalStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        followerVerticalStackView.leadingAnchor.constraint(equalTo: viewForProfileImage.trailingAnchor, constant: 15).isActive = true
        followerVerticalStackView.heightAnchor.constraint(equalToConstant: viewForProfileImage.frame.size.height).isActive = true
        followerVerticalStackView.widthAnchor.constraint(equalToConstant: followersView.frame.size.width * 3).isActive = true
        
        profileName.topAnchor.constraint(equalTo: followerVerticalStackView.topAnchor).isActive = true
        profileName.leadingAnchor.constraint(equalTo: followerVerticalStackView.leadingAnchor).isActive = true
        
        //Constraints labels in view inside horizontal stackView
        followersLabel.leadingAnchor.constraint(equalTo: followersView.leadingAnchor).isActive = true
        followersLabel.bottomAnchor.constraint(equalTo: followersView.bottomAnchor).isActive = true
        
        followingLabel.leadingAnchor.constraint(equalTo: followingView.leadingAnchor).isActive = true
        followingLabel.bottomAnchor.constraint(equalTo: followingView.bottomAnchor).isActive = true
        
        //Add Buttons in follower views
        followersBtn.centerXAnchor.constraint(equalTo: followersView.centerXAnchor).isActive = true
        followersBtn.centerYAnchor.constraint(equalTo: followersView.centerYAnchor).isActive = true
        followersBtn.heightAnchor.constraint(equalTo: followersView.heightAnchor).isActive = true
        followersBtn.widthAnchor.constraint(equalTo: followersView.widthAnchor).isActive = true
        
        followingBtn.centerXAnchor.constraint(equalTo: followingView.centerXAnchor).isActive = true
        followingBtn.centerYAnchor.constraint(equalTo: followingView.centerYAnchor).isActive = true
        followingBtn.heightAnchor.constraint(equalTo: followingView.heightAnchor).isActive = true
        followingBtn.widthAnchor.constraint(equalTo: followingView.widthAnchor).isActive = true
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}

struct TestSection {
    
    let currentSectionsModel: [CurentSectionModel]
    static var configurate = UIColor.white
    
    struct CurentSectionModel {
        let image: UIImage
        let title: String
        //let backgoundColor: UIColor
    }
}
