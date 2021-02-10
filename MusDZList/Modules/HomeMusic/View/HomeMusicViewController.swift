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
    @IBOutlet weak var recommendedHeightConstraint: NSLayoutConstraint!
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
        recommendedHeightConstraint.constant = (view.frame.width / 2 - 25 + 60) * 2
//        recommendedHeightConstraint.constant = 1000

        favoriteArtistsCollectionView.register(UINib(nibName: "FavoriteArtistCell", bundle: nil), forCellWithReuseIdentifier: String(describing: FavoriteArtistCell.self))
        recomendedCollectionView.register(UINib(nibName: "RecomendedCell", bundle: nil), forCellWithReuseIdentifier: String(describing: RecomendedCell.self))

        recomendedCollectionView.register(UINib(nibName: "RecommendedHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: RecommendedHeaderView.self))

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

        viewModel.showFavoriteArtistsLoading.bind(to: activityIndicator.rx.isAnimating).disposed(by: bag)

        viewModel.recommendedNewSubject.bind(to: recomendedCollectionView.rx.items(cellIdentifier: String(describing: RecomendedCell.self), cellType: RecomendedCell.self)) { row, item, cell in
            cell.recomendNameLabel.text = "\(item.info.numberOfTracks) Tracks\n\(item.info.title)"
            cell.recommendImageView.image = UIImage(data: item.image)
        }
        .disposed(by: bag)
    }

}

extension HomeMusicViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == favoriteArtistsCollectionView {
            let width = favoriteArtistsContentSizeWidth
            return CGSize(width: width, height: width)
        } else {
            let width = view.frame.width / 2 - 25
            return CGSize(width: width, height: width + 50)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == favoriteArtistsCollectionView {
            return 15
        } else {
            return 15
        }
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if collectionView == recomendedCollectionView {
//            return CGSize(width: 100, height: 100)
//        }
//        return CGSize(width: 0, height: 0)
//    }

//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//            switch kind {
//
//            case UICollectionView.elementKindSectionHeader:
//
//                let headerView = recomendedCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: RecommendedHeaderView.self), for: indexPath) as! RecommendedHeaderView
//
////                headerView.delegate = self
////                headerView.backgroundColor = .red
//                headerView.headerView.backgroundColor = .red
//                return headerView
//
////            case UICollectionView.elementKindSectionFooter:
////
////                let footerView = recomendedCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: HeaderRecomendView.self), for: indexPath) as! HeaderRecomendView
////
//////                footerView.delegate = self
////                return footerView
//
    //            default:
    //                assert(false, "Unexpected element kind")
    //            }
//        }


}
