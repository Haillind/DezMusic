//
//  NetworkManager.swift
//  MusDZList
//
//  Created by Denis Selivanov on 25.01.2021.
//  Copyright © 2021 Denis Selivanov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NetworkManager {

//    let consumerKey = "417762"
//    let consumerSecret = "dce9d10fa1483d1585df63ce363592f6"
//    let authorizationEndPoint = "https://connect.deezer.com/oauth/auth.php"
//
//    var urlForAuth: URL? {
//        let redirectURL = "https://haillind.github.io"
//        let url = URL(string: "\(authorizationEndPoint)?app_id=\(consumerKey)&redirect_uri=\(redirectURL)&perms=basic_access,email")
//        return url
//    }

    static func createRequest<T: Codable>(url: URL) -> Observable<T> {

        return Observable<T>.create { observer in

            let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in

                guard let data = data else { return print("data")}
                      guard let decoded = try? JSONDecoder().decode(T.self, from: data) else { return print("decode") }

                observer.onNext(decoded)
                observer.onCompleted()
            }
            dataTask.resume()

            return Disposables.create {
                dataTask.cancel()
            }
        }
    }

    static func sendRequest<T: Codable>(url: URL) -> Observable<T> {
        let request = URLRequest(url: url)

        return URLSession.shared.rx.response(request: request)
            .map { response, data -> T in
                guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
                    print("Cannot decode data")
                    return T.self as! T}
                return decoded
            }
    }

    static func sendRequestForImages(url: URL) -> Observable<Data> {

        return Observable.create { observer in

            let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in

                guard let data = data else { return print("data")}

                observer.onNext(data)
                observer.onCompleted()
            }
            dataTask.resume()

            return Disposables.create {
                dataTask.cancel()
            }
        }
    }

}
