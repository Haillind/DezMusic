//
//  AuthController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 08.06.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit
import WebKit

class AuthController: UIViewController {
    
    var webView: WKWebView!
    var redirectAuthCode: String?
    var defaults = UserDefaults.standard
    
    let decoderJSON = DecoderJSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    @IBAction func authorizePressed(_ sender: UIButton) {
        
        view = webView
        startAuthorizationRefactoring()
    }
    
}


//MARK: - WKWeb Methods

extension AuthController: WKNavigationDelegate, WKUIDelegate {
    
    func startAuthorizationRefactoring() {
        
        let authorizationURL = "\(K.authorizationEndPoint)?app_id=\(K.consumerKey)&redirect_uri=\(K.redirectURL)&perms=\(K.permissions)"
        
        let request = URLRequest(url: URL(string: authorizationURL)!)
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        var action: WKNavigationActionPolicy?

        defer {
            decisionHandler(action ?? .allow)
        }
        
        guard let url = navigationAction.request.url else { return }
        
        if url.host == "haillind.github.io" {
            
            if url.absoluteString.contains("code=") {
                
                redirectAuthCode = url.absoluteString.components(separatedBy: "code=").last
                requestForAccessToken(authorizationCode: redirectAuthCode)
            }
        }
    }
    
    func requestForAccessToken(authorizationCode: String?) {
        
        guard let authCode = authorizationCode else {return}
        
        let urlForAccessToken = "https://connect.deezer.com/oauth/access_token.php?app_id=\(K.consumerKey)&secret=\(K.consumerSecret)&code=\(authCode)&output=json"
        guard let url = URL(string: urlForAccessToken) else {return}
        
        NetworkService.shared.getDataFromServer(url: url) { (data, _, _) in
            guard let data = data else {return}
            self.decoderJSON.decodeToJSON(data: data, toDecode: AuthData.self) { (decodeData) in
                self.defaults.set(decodeData.accessToken, forKey: "accessToken")
                self.defaults.set(decodeData.expires, forKey: "expiresToken")
                self.getUserInfoAfterReceiveToken(accessToken: decodeData.accessToken) {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "goToTabBar", sender: self)
                    }
                }
            }
        }
    }
    
    func getUserInfoAfterReceiveToken(accessToken: String?, completion: (() -> Void)?) {
        guard let accessToken = accessToken else {return}
        let urlQuery = "https://api.deezer.com/user/me?access_token=\(accessToken)"
        guard let url = URL(string: urlQuery) else {return}
        
        NetworkService.shared.getDataFromServer(url: url) { (data, _, _) in
            guard let data = data else {return}
            self.decoderJSON.decodeToJSON(data: data, toDecode: UserInfoData.self) { (decodeData) in
                self.defaults.set(decodeData.id, forKey: "userProfileId")
                completion!()
            }
        }
    }
    
}
