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
        case title
        case storyTitle = "story_title"
        case author
        case createdAt = "created_at"
        case storyUrl = "story_url"
    }

    let title: String?
    let storyTitle: String?
    let author: String
    let createdAt: String
    let storyUrl: String?
}
