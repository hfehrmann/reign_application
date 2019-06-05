//
//  FavoriteMoviesViewModel.swift
//  ios-recruiting-hsa
//
//  Created by Hans Fehrmann on 5/31/19.
//  Copyright © 2019 Hans Fehrmann. All rights reserved.
//

import Foundation

protocol ListArticlesViewModel {
    var removeAtIndex: (IndexPath) -> Void { get set }
    var onUpdate: () -> Void { get set }

    var title: String { get }
    var count: Int { get }
    func load()
    func refresh()
    func remove(at indexPath: IndexPath)
    func select(indexPath: IndexPath)
    func cellViewModel(forIndex index: IndexPath) -> ListArticlesCellViewModel
}

// Implementation

class ListArticlesViewModelImpl {

    var removeAtIndex: (IndexPath) -> Void = { _ in }
    var onUpdate: () -> Void = { }

    var onSelectArticle: (Article) -> Void = { _ in }

    fileprivate var articles: [Article] = []
    private let articlesManager: ArticleManager

    init(articlesManager: ArticleManager) {
        self.articlesManager = articlesManager
    }
}

extension ListArticlesViewModelImpl: ListArticlesViewModel {

    var title: String { return "Favorites" }
    var count: Int { return articles.count }

    func load() {
        articlesManager.getLocalArticles(
            onSuccess: { [weak self] articles in
                guard articles.count > 0 else { return }
                self?.articles = articles
                self?.onUpdate()
            },
            onError: nil
        )
    }

    func refresh() {
        articlesManager.getLatestArticles(
            onSuccess: { [weak self] articles in
                self?.articles = articles
                self?.onUpdate()
            },
            onError: { [weak self] articles, _ in
                self?.articles = articles
                self?.onUpdate()
            }
        )
    }

    func select(indexPath: IndexPath) {
        let article = articles[indexPath.row]
        onSelectArticle(article)
    }

    func remove(at indexPath: IndexPath) {
        let article = articles[indexPath.row]
        articlesManager.remove(article: article) { [weak self] articles in
            self?.articles = articles
            self?.removeAtIndex(indexPath)
        }
    }

    func cellViewModel(forIndex index: IndexPath) -> ListArticlesCellViewModel {
        let article = articles[index.row]
        let cellViewModel = ListArticlesCellViewModelImpl(article: article)
        return cellViewModel
    }
}
