//
//  HomeMusicViewModel.swift
//  MusDZList
//
//  Created by Denis Selivanov on 03.02.2021.
//  Copyright © 2021 Denis Selivanov. All rights reserved.
//

//import Foundation
//import UIKit
import RxSwift
import RxCocoa

class HomeMusicViewModel {

    let showLoading = BehaviorRelay<Bool>(value: true)
    let favoriteArtistsData = PublishSubject<[FavoritesArtistsData]>()

    let bag = DisposeBag()

    var accessToken: String {
        get {
            guard let token = UserDefaults.standard.value(forKey: "accessToken") as? String else { return ""}
            return token
        }
    }

    func transform(input: Input) -> Output {
        
        requestForFavoriteList()
            .do(onDispose:  {
                self.showLoading.accept(false)
            })
            .subscribe (onNext: { data in
                self.favoriteArtistsData.onNext(data.data)
                self.favoriteArtistsData.onCompleted()
            })
            .disposed(by: bag)

        return Output()
    }

    func requestForFavoriteList() -> Observable<UserFavoriteArtistsData> {
        let urlUser = "https://api.deezer.com/user/me/artists?access_token=\(accessToken)"
        guard let url = URL(string: urlUser) else { return Observable<UserFavoriteArtistsData>.never()}
        return NetworkManager.createRequest(url: url)
    }
}

extension HomeMusicViewModel: ViewModelType {
    struct Input {
    }

    struct Output {
    }
}
