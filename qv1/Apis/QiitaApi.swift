//
//  QiitaApi.swift
//  qv1
//
//  Created by Ryota Yokote on 2020/11/01.
//

import Foundation
import Moya

protocol QiitaTargetType: TargetType {
    associatedtype Response: Codable
}

extension QiitaTargetType {
    var baseURL: URL {
        return URL(string: "https://qiita.com")!
    }

    var headers: [String: String]? {
        return nil
    }

    var sampleData: Data {
        let path = Bundle.main.path(forResource: "samples", ofType: "json")!
        return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
    }
}

enum Qiita {
    struct GetItems: QiitaTargetType {
        typealias Response = [Article]

        var method: Moya.Method { return .get }
        var path: String { return "/api/v2/items" }
        var task: Task { return .requestParameters(parameters: ["page": page, "perPage": perPage], encoding: URLEncoding.default) }

        let page: Int
        let perPage: Int

        init(page: Int, perPage: Int) {
            self.page = page
            self.perPage = perPage
        }
    }
}
