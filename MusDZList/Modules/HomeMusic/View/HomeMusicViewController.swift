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

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteArtistsCollectionView: UICollectionView!
    @IBOutlet weak var recomendedCollectionView: UICollectionView!
    @IBOutlet weak var viewInScrollView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var testDataLabel: UILabel!

    weak var coordinator: MainCoordinator?

    private let viewModel = HomeMusicViewModel()
    private let bag = DisposeBag()

    private var input: HomeMusicViewModel.Input {
        return HomeMusicViewModel.Input(data: favoriteArtistsCollectionView.rx.modelSelected(FavoriteArtistModel.self))
    }

    var favoriteArtistsContentSizeWidth: CGFloat {
        return view.frame.width / 3.5
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        heightConstraint.constant = favoriteArtistsContentSizeWidth

        favoriteArtistsCollectionView.register(UINib(nibName: "FavoriteArtistCell", bundle: nil), forCellWithReuseIdentifier: String(describing: FavoriteArtistCell.self))

        favoriteArtistsCollectionView.rx.setDelegate(self).disposed(by: bag)
        recomendedCollectionView.rx.setDelegate(self).disposed(by: bag)

        bind(output: viewModel.transform(input: input))
    }

    private func bind(output: HomeMusicViewModel.Output) {

        output.text.drive(testDataLabel.rx.text).disposed(by: bag)

        viewModel.favoriteArtistsSubject.bind(to: favoriteArtistsCollectionView.rx.items(cellIdentifier: String(describing: FavoriteArtistCell.self), cellType: FavoriteArtistCell.self)) { row, item, cell in
            cell.artist = item
        }
        .disposed(by: bag)

        viewModel.showLoading.bind(to: activityIndicator.rx.isAnimating).disposed(by: bag)
    }

}

extension HomeMusicViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == favoriteArtistsCollectionView {
            let width = favoriteArtistsContentSizeWidth
            return CGSize(width: width, height: width)
        } else {
            return UICollectionView.layoutFittingCompressedSize
        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}
