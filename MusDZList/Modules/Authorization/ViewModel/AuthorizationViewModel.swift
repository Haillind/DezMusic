//
//  AuthorizationViewModel.swift
//  MusDZList
//
//  Created by Denis Selivanov on 26.01.2021.
//  Copyright © 2021 Denis Selivanov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import WebKit
import RxWebKit

class AuthorizationViewModel {

    let consumerKey = "417762"
    let consumerSecret = "dce9d10fa1483d1585df63ce363592f6"
    let authorizationEndPoint = "https://connect.deezer.com/oauth/auth.php"
    let defaults = UserDefaults.standard
    var redirectAuthCode: String?

    let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!


    func transform(input: Input) -> Output {
        let createTap = input.loginTrigger
            .do(onNext: openWebView)
        return Output(openWebView: createTap)
    }

    func openWebView() {
        print("hello webview from movel")
    }

    func requestForToken(authorizationCode: String?) -> Observable<AuthData> {
        guard let authCode = authorizationCode else { return Observable<AuthData>.never()}
        let urlForAccessToken = "https://connect.deezer.com/oauth/access_token.php?app_id=\(consumerKey)&secret=\(consumerSecret)&code=\(authCode)&output=json"
        guard let url = URL(string: urlForAccessToken) else { return Observable<AuthData>.never()}
        return NetworkManager.createRequest(url: url)
    }

}

extension AuthorizationViewModel: ViewModelType {
    struct Input {
        let loginTrigger: Driver<Void>
    }

    struct Output {
        let openWebView: Driver<Void>
    }
}
