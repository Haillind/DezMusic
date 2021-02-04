//
//  HomeMusicViewController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 01.02.2021.
//  Copyright © 2021 Denis Selivanov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeMusicViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    weak var coordinator: MainCoordinator?

    private let viewModel = HomeMusicViewModel()
    private let bag = DisposeBag()

    private var input: HomeMusicViewModel.Input {
        return HomeMusicViewModel.Input()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
        tableView.backgroundColor = .red
        tableView.isHidden = true

        tableView.register(UINib(nibName: "TestTableViewCell", bundle: nil), forCellReuseIdentifier: String(describing: TestTableViewCell.self))

        bind(output: viewModel.transform(input: input))
    }

    private func bind(output: HomeMusicViewModel.Output) {

        viewModel.favoriteArtistsData.bind(to: tableView.rx.items(cellIdentifier: String(describing: TestTableViewCell.self), cellType: TestTableViewCell.self)) { row, item, cell in
            cell.favoriteArtistItem = item
        }.disposed(by: bag)

        viewModel.showLoading.bind(to: activityIndicator.rx.isAnimating).disposed(by: bag)
        viewModel.showLoading.bind(to: tableView.rx.isHidden).disposed(by: bag)
    }

}
