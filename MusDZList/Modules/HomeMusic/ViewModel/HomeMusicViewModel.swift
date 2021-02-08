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

    let showFavoriteArtistsLoading = BehaviorRelay<Bool>(value: true)
    private var arrayModel = [FavoriteArtistModel]()
    let favoriteArtistsSubject = PublishSubject<[FavoriteArtistModel]>()
//    let favor = PublishSubject<[FavoriteArtistModel]>()

    private var recommendedArrayModel = [Data]()
    let recommendedSubject = PublishSubject<[Data]>()
    let recommendedNewSubject = PublishSubject<[RecommendedModel]>()

    let bag = DisposeBag()

    var accessToken: String {
        get {
            guard let token = UserDefaults.standard.value(forKey: "accessToken") as? String else { return "" }
            return token
        }
    }

    var userId: Int {
        get {
            guard let id = UserDefaults.standard.value(forKey: "userId") as? Int else { return 0 }
            return id
        }
    }

    func transform(input: Input) -> Output {

//        requestForFavoriteList()
//            .map { $0.data }
//            .flatMap { Observable.from($0) }
//            .map {$0}
//            .flatMap {
//                Observable.combineLatest(Observable.just($0), NetworkManager.sendRequestForImages(url: $0.picture_big))
//            }
//            .do { (artist, imageData) in
//                print("URL was dowloaded")
//                let newstruct = FavoriteArtistModel(id: artist.id, name: artist.name, image: imageData)
//                self.arrayModel.append(newstruct)
//                self.favoriteArtistsSubject.onNext(self.arrayModel)
//            }
//            .toArray()
//            .subscribe({_ in
//                self.showFavoriteArtistsLoading.accept(false)
//                print("all url was downloaded")
//            })
//            .disposed(by: bag)

        requestForFavoriteList()
            .map { $0.data }
            .flatMap { Observable.from($0) }
            .map {$0}
            .flatMap {
                Observable.combineLatest(Observable.just($0), NetworkManager.sendRequestForImages(url: $0.picture_big))
            }
            .flatMap { artistData, imageData -> Observable<FavoriteArtistModel> in
                let model = FavoriteArtistModel(id: artistData.id, name: artistData.name, image: imageData)
                return Observable.just(model)
            }
            .toArray()
            .do (onSuccess: { model in
                self.favoriteArtistsSubject.onNext(model)
            })
            .subscribe(onSuccess: { _ in
                self.showFavoriteArtistsLoading.accept(false)
            })
            .disposed(by: bag)

        requestRecommendedList()
            .map {$0.data}
            .flatMap {Observable.from($0)}
            .map {$0}
            .flatMap {
                Observable.combineLatest(Observable.just($0), NetworkManager.sendRequestForImages(url: $0.pictureBig))
//                NetworkManager.sendRequestForImages(url: $0.pictureBig)
            }
            .flatMap { recommendData, imageData -> Observable<RecommendedModel> in
                let model = RecommendedModel(info: recommendData, image: imageData)
                return Observable.of(model)
            }
            .toArray()
            .do (onSuccess: { (model) in
                self.recommendedNewSubject.onNext(model)
            })
            .subscribe()
            .disposed(by: bag)
//            .toArray()
//            .do (onSuccess: { imageData in
//                self.recommendedSubject.onNext(imageData)
//            })
//            .subscribe()
//            .disposed(by: bag)

//        requestRecommendedList()
//            .map {$0.data}
//            .flatMap {Observable.from($0)}
//            .map {$0}
//            .flatMap {
////                Observable.combineLatest(Observable.just($0), NetworkManager.sendRequestForImages(url: $0.pictureBig))
//                NetworkManager.sendRequestForImages(url: $0.pictureBig)
//            }
//            .do {  imageData in
//                self.recommendedArrayModel.append(imageData)
//                self.recommendedSubject.onNext(self.recommendedArrayModel)
//            }
//            .toArray()
//            .subscribe()
//            .disposed(by: bag)


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

    private func requestRecommendedList() -> Observable<RecommendedData> {
        let urlString = "https://api.deezer.com/user/\(userId)/recommendations/playlists?access_token=\(accessToken)"
        guard let url = URL(string: urlString) else { return Observable.never() }
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
