//
//  ReuseIdentifying.swift
//  Sodam
//
//  Created by t2023-m0019 on 1/21/25.
//

protocol ReuseIdentifying: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
