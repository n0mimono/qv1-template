//
//  ViewService.swift
//  v0
//
//  Created by Ryota Yokote on 2020/10/04.
//

import Alamofire
import Foundation
import RxRelay
import RxSwift

protocol ApiService {
    func request<T: ApiResponse>(_ req: ApiRequest, _ type: T.Type) -> Observable<T>
}

class ApiServiceImpl: ApiService {
    func request<T: ApiResponse>(_ req: ApiRequest, _ type: T.Type) -> Observable<T> {
        return request(req.uri, method: .get, parameters: req.parameters, type: type.ResponseEntity.self)
            .compactMap { T($0) }
    }

    private func request<T: Decodable>(_ url: String, method: HTTPMethod, parameters: Parameters, type: T.Type) -> Observable<T?> {
        return request(url, method: .get, parameters: parameters)
            .compactMap { response -> T? in
                guard let data = response.data else {
                    return nil
                }
                guard let decoded = try? JSONDecoder().decode(type, from: data) else {
                    return nil
                }
                return decoded
            }
    }

    private func request(_ url: String, method: HTTPMethod, parameters: Parameters) -> Observable<AFDataResponse<Data?>> {
        return Observable.create { observer in
            AF.request(url, method: .get, parameters: parameters).response { response in
                observer.on(.next(response))
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }
}

protocol ApiRequest {
    var uri: String { get }
    var parameters: Parameters { get }
}

protocol ApiResponse {
    associatedtype ResponseEntity: Decodable

    init(_ responseEntity: ResponseEntity?)
}
