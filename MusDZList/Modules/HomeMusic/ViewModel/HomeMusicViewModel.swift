//
//  HomeMusicViewModel.swift
//  MusDZList
//
//  Created by Denis Selivanov on 03.02.2021.
//  Copyright © 2021 Denis Selivanov. All rights reserved.
//

import RxSwift
import RxCocoa

class HomeMusicViewModel {

    let showLoading = BehaviorRelay<Bool>(value: true)
    private var arrayModel = [FavoriteArtistModel]()
    let favoriteArtistsSubject = PublishSubject<[FavoriteArtistModel]>()

    let bag = DisposeBag()

    var accessToken: String {
        get {
            guard let token = UserDefaults.standard.value(forKey: "accessToken") as? String else { return ""}
            return token
        }
    }

    func transform(input: Input) -> Output {

        requestForFavoriteList()
            .map { $0.data }
            .flatMap { Observable.from($0) }
            .map {$0}
            .flatMap {
                Observable.combineLatest(Observable.just($0), NetworkManager.sendRequestForImages(url: $0.picture_big))
            }
            .do { (artist, imageData) in
                print("URL was dowloaded")
                let newstruct = FavoriteArtistModel(id: artist.id, name: artist.name, image: imageData)
                self.arrayModel.append(newstruct)
                self.favoriteArtistsSubject.onNext(self.arrayModel)
            }
            .toArray()
            .subscribe({_ in
                self.showLoading.accept(false)
                print("all url was downloaded")
            })
            .disposed(by: bag)

        let string = input.data.map {
            return $0.name
        }.asDriver(onErrorJustReturn: "")

        return Output(text: string)
    }

    private func requestForFavoriteList() -> Observable<UserFavoriteArtistsData> {
        let urlUser = "https://api.deezer.com/user/me/artists?access_token=\(accessToken)"
        guard let url = URL(string: urlUser) else { return Observable<UserFavoriteArtistsData>.never()}
        return NetworkManager.createRequest(url: url)
    }
}

extension HomeMusicViewModel: ViewModelType {
    struct Input {
        let data: ControlEvent<FavoriteArtistModel>
    }

    struct Output {
        let text: Driver<String>
    }
}
