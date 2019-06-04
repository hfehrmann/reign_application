//
//  ModelManager.swift
//  ios-recruiting-hsa
//
//  Created by Hans Fehrmann on 5/30/19.
//  Copyright © 2019 Hans Fehrmann. All rights reserved.
//

import Foundation

enum ArticleManagerError: Error {
    case unableToFetchArticles(Error)
}

protocol ArticleManager {
    func getLatestArticles(
        onSuccess: (([Article]) -> Void)?,
        onError: ((ArticleManagerError) -> Void)?
    )
    func remove(article: Article, callback: (([Article]) -> Void)?)
}

func articleManagerDefault() -> ArticleManager {
    return ArticleManagerImpl(client: clientDefault(), persitance: persistanceDefault())
}

// Implementation

class ArticleManagerImpl {

    let client: Client
    let persitance: Persistance

    init(client: Client, persitance: Persistance) {
        self.client = client
        self.persitance = persitance
    }
}

extension ArticleManagerImpl: ArticleManager {

    func getLatestArticles(
        onSuccess: (([Article]) -> Void)?,
        onError: ((ArticleManagerError) -> Void)?
    ) {
        client.articlesSearch(
            onSuccess: { [weak self] articleResponse in
                guard let self = self else { return }
                let articles = articleResponse.hits
                try? self.persitance.save(data: articles, forKey: Constant.PersistanceKey.articles)
                onSuccess?(articles)
            },
            onError: { [weak self] errorData in
                print(errorData)
                guard let self = self else { return }
                let key = Constant.PersistanceKey.articles
                let articles: [Article]? = try? self.persitance.retreive(key: key)
                onSuccess?(articles ?? [])
            }
        )
    }

    func remove(article: Article, callback: (([Article]) -> Void)?) {
        var articles: [Article]
        articles = (try? persitance.retreive(key: Constant.PersistanceKey.articles)) ?? []
        articles.removeAll { $0.objectId == article.objectId }
        callback?(articles)
    }
}
