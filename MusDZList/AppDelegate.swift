//
//  AppDelegate.swift
//  MusDZList
//
//  Created by Denis Selivanov on 04.06.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //print("Expires: \(UserDefaults.standard.value(forKey: "expiresToken"))")
//        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
//            self.checkExpiresToken()
//        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

//extension AppDelegate {
//
//    func checkExpiresToken() {
//
//        guard let url = URL(string: "https://api.deezer.com/user/me?access_token=\(String(describing: UserDefaults.standard.value(forKey: "accessToken")))") else {return}
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//
//            guard let data = data else {return}
//
//            do {
//                let json1 = try JSONSerialization.jsonObject(with: data, options: [])
//                print(json1)
//                let json = try JSONDecoder().decode(AuthData.self, from: data)
//                if json.error != nil && json.error?.code == 300 {
//                    print("Code error: \(String(describing: json.error?.code))")
//                }
//
//            } catch {
//
//            }
//
//        }.resume()
//
//    }
//
//}

