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
        didSelect movie: Article
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
        viewModel.onSelectMovie = { [weak delegate, unowned controller] movie in
            delegate?.favoriteMovieView(controller, didSelect: movie)
        }
        return controller
    }
}
