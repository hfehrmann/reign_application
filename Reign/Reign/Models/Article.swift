//
//  Genre.swift
//  ios-recruiting-hsa
//
//  Created by Hans Fehrmann on 5/27/19.
//  Copyright © 2019 Hans Fehrmann. All rights reserved.
//

import Foundation

struct Article: Codable {

    private enum CodingKeys: String, CodingKey {
        case objectId = "objectID"
        case title
        case storyTitle = "story_title"
        case author
        case createdAt = "created_at"
        case storyUrl = "story_url"
    }

    let objectId: String
    let title: String?
    let storyTitle: String?
    let author: String
    let createdAt: Date
    let storyUrl: String?
}

extension Article: Equatable {

    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.objectId == rhs.objectId
    }
}
