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
    //
    var webView: WKWebView!
    var redirectAuthCode: String?
    var defaults = UserDefaults.standard
    
    let consumerKey = "417762"
    let consumerSecret = "dce9d10fa1483d1585df63ce363592f6"
    let authorizationEndPoint = "https://connect.deezer.com/oauth/auth.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
    }
    
    @IBAction func authorizePressed(_ sender: UIButton) {
        
        view = webView
        startAuthorization()
    }
}

//MARK: - WKWeb Methods

extension AuthController: WKNavigationDelegate, WKUIDelegate {
    
    func startAuthorization() {
        
        let redirectURL = "https://haillind.github.io"
        let authorizationURL = "\(authorizationEndPoint)?app_id=\(consumerKey)&redirect_uri=\(redirectURL)&perms=basic_access,email"
        
        let request = URLRequest(url: URL(string: authorizationURL)!)
        webView.load(request)
    }
    
    func requestForAccessToken(authorizationCode: String?) {
        
        guard let authCode = authorizationCode else {return}
        
        let urlForAccessToken = "https://connect.deezer.com/oauth/access_token.php?app_id=\(consumerKey)&secret=\(consumerSecret)&code=\(authCode)&output=json"
        guard let url = URL(string: urlForAccessToken) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else {return}
            
            do {
                
                let jsonData = try JSONDecoder().decode(AuthData.self, from: data)
                self.defaults.set(jsonData.access_token, forKey: "accessToken")
                
                DispatchQueue.main.async {
                    
                    self.performSegue(withIdentifier: "goToTabBar", sender: self)
                }
                
            } catch {
                print(error)
            }
        }.resume()
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

}
    
    // https://www.appcoda.com/linkedin-sign-in/
    // https://medium.com/@kiransjadhav111/how-to-use-wkwebview-migrating-uiwebview-to-wkwebview-with-swift-30506885d916

// https://www.youtube.com/watch?v=YA20F7RJnwA

// https://www.youtube.com/watch?v=e6u-NnpgSRo