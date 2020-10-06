//
//  Article.swift
//  v0
//
//  Created by Ryota Yokote on 2020/10/03.
//

import Alamofire
import Foundation

struct ItemRequest: ApiRequest {
    let uri: String = "https://qiita.com/api/v2/items"
    let parameters: Parameters

    init(page: Int) {
        parameters = ["page": page, "per_page": 20]
    }
}

struct ItemsResponse: ApiResponse {
    typealias ResponseEntity = [Article]
    
    let articles: ResponseEntity
    
    init(_ responseEntity: ResponseEntity?) {
        articles = responseEntity ?? []
    }
}

struct Article: Codable {
    let title: String
    let body: String
    let renderedBody: String
    let url: String
    let user: User

    private enum CodingKeys: String, CodingKey {
        case title
        case body
        case renderedBody = "rendered_body"
        case url
        case user
    }
}

struct User: Codable {
    let id: String
    let profileImageUrl: String

    private enum CodingKeys: String, CodingKey {
        case id
        case profileImageUrl = "profile_image_url"
    }
}
