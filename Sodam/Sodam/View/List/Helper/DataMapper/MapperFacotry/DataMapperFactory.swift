//
//  ContentMapperFactory.swift
//  Sodam
//
//  Created by 박진홍 on 2/14/25.
//

/*
 Input과 Output의 조합을 저장할 MapperKey 구조체를 이용하여 register패턴에 활용
 타입소거하여 구체적인 매퍼를 숨기고 호출부에서는 Input과 Output만으로 매퍼를 받아 데이터 처리
 */

struct ViewDataMapper<Input, Output>: DataMapping {
    private let _map: (Input) -> Output //mapper의 map을 담아둘 내부 변수
    
    init<M:DataMapping>(mapper: M) where M.Input == Input, M.Output == Output {
        self._map = mapper.map
    }
    func map(from input: Input) -> Output {
        _map(input)
    }
}

struct MapperKey: Hashable {
    let input: ObjectIdentifier
    let output: ObjectIdentifier
    
    init<Input, Output>(input: Input.Type, output: Output.Type) {
        self.input = ObjectIdentifier(input)
        self.output = ObjectIdentifier(output)
    }
}

// TODO: 더 구체적인 에러 생성 후 파일 분리 필요함
enum FacotoryError: Error {
    case failedToCreate
}

final class DataMapperFactory {
    private var registry: [MapperKey: Any] = [:]
    
    init() { // 사용하는 매퍼를 초기화 시 기본적으로 등록해두었음. 추후 개선
        register(mapper: StatusContentMapper())
        register(mapper: HappinessListConfigMapper())
        register(mapper: HappinessListContentMapper())
    }
    
    private func register<M: DataMapping>(mapper: M) { // 현재는 초기화 시에만 등록해서 private걸어둠
        let key = MapperKey(input: M.Input.self, output: M.Output.self)
        registry[key] = ViewDataMapper(mapper: mapper)
    }
    
    func createAnyMapper<Input, Output>(inputType: Input.Type, outputType: Output.Type) -> Result<ViewDataMapper<Input, Output>, FacotoryError> {
        let key = MapperKey(input: inputType, output: outputType)
        guard let mapper = registry[key] as? ViewDataMapper<Input, Output> else { return .failure(.failedToCreate) }
        
        return .success(mapper)
    }
}
