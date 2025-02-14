//
//  MapperProtocol.swift
//  Sodam
//
//  Created by 박진홍 on 2/14/25.
//

///input 타입과 output 타입을 구현단계에서 명시할 수 있게 하는 매퍼 프로토콜
protocol MapperProtocol {
    associatedtype Input
    associatedtype Output
    func map(from input: Input) throws -> Output
}
