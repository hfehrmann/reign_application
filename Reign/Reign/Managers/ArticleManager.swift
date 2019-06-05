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
    case unableToRetreiveArticles(Error)
}

protocol ArticleManager {
    func load()
    func getLocalArticles(
        onSuccess: (([Article]) -> Void)?,
        onError: ((ArticleManagerError) -> Void)?
    )
    func getLatestArticles(
        onSuccess: (([Article]) -> Void)?,
        onError: (([Article], ArticleManagerError) -> Void)?
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

    private var deletedKeys: Set<String>

    init(client: Client, persitance: Persistance) {
        self.client = client
        self.persitance = persitance
        self.deletedKeys = []
    }
}

extension ArticleManagerImpl: ArticleManager {

    func load() {
        let key = Constant.PersistanceKey.deletedArticlesKeys
        let deletedKeys: Set<String>? = try? persitance.retreive(key: key)
        self.deletedKeys = deletedKeys ?? []
    }

    func getLocalArticles(
        onSuccess: (([Article]) -> Void)?,
        onError: ((ArticleManagerError) -> Void)?
    ) {
        do {
            let key = Constant.PersistanceKey.articles
            let articles: [Article]? = try self.persitance.retreive(key: key)
            let finalArticles = self.filterArticles(articles ?? [], self.deletedKeys)
            onSuccess?(finalArticles)
        } catch {
            onError?(.unableToRetreiveArticles(error))
        }
    }

    func getLatestArticles(
        onSuccess: (([Article]) -> Void)?,
        onError: (([Article], ArticleManagerError) -> Void)?
    ) {
        client.articlesSearch(
            onSuccess: { [weak self] articleResponse in
                guard let self = self else { return }
                let articles = articleResponse.hits
                try? self.persitance.save(data: articles, forKey: Constant.PersistanceKey.articles)
                onSuccess?(self.filterArticles(articles, self.deletedKeys))
            },
            onError: { [weak self] errorData in
                print(errorData)
                guard let self = self else { return }
                let key = Constant.PersistanceKey.articles
                do {
                    let articles: [Article]? = try self.persitance.retreive(key: key)
                    let finalArticles = self.filterArticles(articles ?? [], self.deletedKeys)
                    onError?(finalArticles, .unableToFetchArticles(errorData))
                } catch {
                    onError?([], .unableToRetreiveArticles(error))
                }
            }
        )
    }

    func remove(article: Article, callback: (([Article]) -> Void)?) {
        var articles: [Article]
        articles = (try? persitance.retreive(key: Constant.PersistanceKey.articles)) ?? []
        articles.removeAll { $0.objectId == article.objectId }

        // Here we can enque this task over a serial queue to avoid data races
        let key = Constant.PersistanceKey.deletedArticlesKeys
        deletedKeys.insert(article.objectId)
        try? persitance.save(data: deletedKeys, forKey: key)

        callback?(articles)
    }
}

private extension ArticleManagerImpl {

    func filterArticles(_ articles: [Article], _ deletedKeys: Set<String>) -> [Article] {
        return articles.filter { !deletedKeys.contains($0.objectId) }
    }
}
