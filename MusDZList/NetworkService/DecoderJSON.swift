//
//  Decoder.swift
//  MusDZList
//
//  Created by Denis Selivanov on 24.09.2020.
//  Copyright © 2020 Denis Selivanov. All rights reserved.
//

import Foundation

class DecoderJSON {
    
    func decodeToJSON<T: Codable>(data: Data, toDecode type: T.Type, completion: @escaping (T) -> ()) {
        
        do {
            let decodeData = try JSONDecoder().decode(type.self, from: data)
            completion(decodeData)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
