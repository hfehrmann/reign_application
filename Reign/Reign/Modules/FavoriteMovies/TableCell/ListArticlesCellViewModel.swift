//
//  FavoriteMovieCellViewModel.swift
//  ios-recruiting-hsa
//
//  Created by Hans Fehrmann on 5/31/19.
//  Copyright © 2019 Hans Fehrmann. All rights reserved.
//

import Foundation
protocol ListArticlesCellViewModel {
    var title: String { get }
    var author: String { get }
    var timeDifference: String { get }
    var url: URL? { get }
}

class ListArticlesCellViewModelImpl {

    private let article: Article

    init(article: Article) {
        self.article = article
    }
}

extension ListArticlesCellViewModelImpl: ListArticlesCellViewModel {
    var title: String { return article.title ?? article.storyTitle ?? "" }
    var author: String { return article.author }

    var timeDifference: String {
        let now = Date()
        let calendar = Calendar.current
        let components: Set<Calendar.Component> = [.minute, .hour, .day]
        let dateComponents = calendar.dateComponents(components, from: article.createdAt, to: now)
        if let day = dateComponents.day, day > 0 {
            return "\(day)d"
        } else if let hour = dateComponents.hour, hour > 0 {
            return "\(hour)h"
        } else if let minute = dateComponents.minute {
            return "\(minute)m"
        }
        return ""
    }

    var url: URL? {
        guard let url = article.storyUrl else { return nil }
        return URL(string: url)
    }
}
