//
//  FavoriteMoviesWireframe.swift
//  ios-recruiting-hsa
//
//  Created by Hans Fehrmann on 5/31/19.
//  Copyright © 2019 Hans Fehrmann. All rights reserved.
//

import Foundation
import UIKit

protocol ListArticlesViewDelegate: class {
    func favoriteMovieView(
        _ viewController: ListArticlesViewController,
        didSelect article: Article
    )
}

class ListArticlesWireframe {

    static func viewController(
        withDelegate delegate: ListArticlesViewDelegate,
        appDependencies: AppDependencies
    ) -> UIViewController {
        let viewModel = ListArticlesViewModelImpl(
            articlesManager: appDependencies.articleManager
        )
        let controller = ListArticlesViewController(viewModel: viewModel)
        viewModel.onSelectArticle = { [weak delegate, unowned controller] article in
            delegate?.favoriteMovieView(controller, didSelect: article)
        }
        return controller
    }
}
