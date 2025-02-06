//
//  ReuseIdentifying.swift
//  Sodam
//
//  Created by 박시연 on 1/21/25.
//

protocol ReuseIdentifying: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
