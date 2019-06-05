//
//  FavoriteMoviesViewModel.swift
//  ios-recruiting-hsa
//
//  Created by Hans Fehrmann on 5/31/19.
//  Copyright © 2019 Hans Fehrmann. All rights reserved.
//

import Foundation

protocol ShowArticleViewModel {
    var articleURL: URL? { get }
}

// Implementation

class ShowArticleViewModelImpl {

    fileprivate let article: Article

    init(article: Article) {
        self.article = article
    }
}

extension ShowArticleViewModelImpl: ShowArticleViewModel {

    var articleURL: URL? {
        guard let urlString = article.storyUrl else { return nil }
        return URL(string: urlString)
    }
}
