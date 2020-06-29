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
        
//        do
//        {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
//            try AVAudioSession.sharedInstance().setActive(true)
//
//         //!! IMPORTANT !!
//         /*
//         If you're using 3rd party libraries to play sound or generate sound you should
//         set sample rate manually here.
//         Otherwise you wont be able to hear any sound when you lock screen
//         */
//            //try AVAudioSession.sharedInstance().setPreferredSampleRate(4096)
//        }
//        catch
//        {
//            print(error)
//        }
//        // This will enable to show nowplaying controls on lock screen
//        application.beginReceivingRemoteControlEvents()
        
        
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
//            print("Playback OK")
//            try AVAudioSession.sharedInstance().setActive(true)
//            print("Session is Active")
//        } catch {
//            print(error)
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

