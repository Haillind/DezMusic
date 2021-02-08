//
//  TestingRxViewController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 25.01.2021.
//  Copyright © 2021 Denis Selivanov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import WebKit
import RxWebKit

class AuthorizationViewController: UIViewController, Storyboarded {

    @IBOutlet weak var loginButton: UIButton!

    weak var coordinator: MainCoordinator?

    private let viewModel = AuthorizationViewModel()
    private let bag = DisposeBag()

    let consumerKey = "417762"
    let consumerSecret = "dce9d10fa1483d1585df63ce363592f6"
    let authorizationEndPoint = "https://connect.deezer.com/oauth/auth.php"
    let redirectURL = "https://haillind.github.io"

    var urlForAuth: URL? {
        let redirectURL = "https://haillind.github.io"
        let url = URL(string: "\(authorizationEndPoint)?app_id=\(consumerKey)&redirect_uri=\(redirectURL)&perms=basic_access,email")
        return url
    }

    var webView: WKWebView!
    var redirectAuthCode: String?
    var defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLoginButtonAutoSizing()

        let loginTrigger = loginButton.rx.tap
            .flatMap {
                return Observable<Void>.create { observer in
                    self.configureWebView()
                    return Disposables.create()
                }
            }


        let input = AuthorizationViewModel.Input(loginTrigger: loginTrigger.asDriver(onErrorJustReturn: ()))
        bind(output: viewModel.transform(input: input))


    }

    func bind(output: AuthorizationViewModel.Output) {
        output.openWebView.drive().disposed(by: bag)
    }

    private func configureLoginButtonAutoSizing() {
        loginButton.titleLabel?.minimumScaleFactor = 0.5
        loginButton.titleLabel?.numberOfLines = 1
        loginButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }

    private func configureWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)

        webView.uiDelegate = self
        webView.navigationDelegate = self

        guard let url = URL(string: "\(authorizationEndPoint)?app_id=\(consumerKey)&redirect_uri=\(redirectURL)&perms=basic_access,email") else {return}
        let request = URLRequest(url: url)
        view = webView
        webView.load(request)
    }
    @IBAction func go(_ sender: UIButton) {
        coordinator?.homeMusicBar()
    }

}

extension AuthorizationViewController: WKNavigationDelegate, WKUIDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        var action: WKNavigationActionPolicy?

        defer {
            decisionHandler(action ?? .allow)
        }

        guard let url = navigationAction.request.url else { return }

        if url.host == "haillind.github.io" {

            if url.absoluteString.contains("code=") {

                redirectAuthCode = url.absoluteString.components(separatedBy: "code=").last

                viewModel.requestForToken(authorizationCode: redirectAuthCode)
                    .subscribe(onNext: { auth in
                        guard let token = auth.access_token else {return}
                        self.defaults.set(token, forKey: "accessToken")

                        self.viewModel.requestForUserId(accessToken: token)
                            .subscribe { (data) in
                                guard let id = data.element?.id else {return}
                                self.defaults.setValue(id, forKey: "userId")
                                DispatchQueue.main.async {
                                    self.coordinator?.homeMusicBar()
                                }
                            }
                            .disposed(by: self.bag)
                    })
                    .disposed(by: self.bag)
            }
        }
    }
}
