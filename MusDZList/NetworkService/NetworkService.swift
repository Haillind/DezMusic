//
//  NetworkService.swift
//  MusDZList
//
//  Created by Denis Selivanov on 24.09.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
//    private init() {}
    //
    public func getDataFromServer(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
                completion(data, response, error)
            }
        }.resume()
    }
    
}
