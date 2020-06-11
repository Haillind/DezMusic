//
//  TestController.swift
//  MusDZList
//
//  Created by Denis Selivanov on 09.06.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import UIKit

class TestController: UIViewController {
    
    var user: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = UserDefaults.standard.string(forKey: "accessToken")!
        
    }
    
    @IBAction func testFav(_ sender: UIButton) {
        
        let urlUser = "https://api.deezer.com/user/me/artists?access_token=\(user!)"

        guard let url = URL(string: urlUser) else {return}

        URLSession.shared.dataTask(with: url) { (data, _, _) in

            guard let data = data else {return}

            let info = String(data: data, encoding: .utf8)
            print(info)

        }.resume()
    }
}
//https://api.deezer.com/user/me/artists
