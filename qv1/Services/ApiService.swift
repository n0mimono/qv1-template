//
//  ViewService.swift
//  v0
//
//  Created by Ryota Yokote on 2020/10/04.
//

import Foundation
import Moya
import RxMoya
import RxRelay
import RxSwift

protocol ApiService {
    func request<T>(_ request: T) -> Observable<T.Response> where T: QiitaTargetType
}

class ApiServiceImpl: ApiService {
    let disposeBag = DisposeBag()

    let qiitaProvider = MoyaProvider<MultiTarget>()

    func request<T>(_ request: T) -> Observable<T.Response> where T: QiitaTargetType {
        let target = MultiTarget(request)
        return qiitaProvider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .map(T.Response.self)
            .asObservable()
    }
}
