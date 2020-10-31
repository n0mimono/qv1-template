//
//  Article.swift
//  v0
//
//  Created by Ryota Yokote on 2020/10/03.
//

import Foundation

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
