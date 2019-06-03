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
            onSuccess: { articleResponse in
                onSuccess?(articleResponse.hints)
            },
            onError: { errorData in
                onError?(.unableToFetchArticles(errorData))
            }
        )
    }
}
