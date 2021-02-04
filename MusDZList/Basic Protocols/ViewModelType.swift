//
//  ViewModelType.swift
//  MusDZList
//
//  Created by Denis Selivanov on 28.01.2021.
//  Copyright © 2021 Denis Selivanov. All rights reserved.
//

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
