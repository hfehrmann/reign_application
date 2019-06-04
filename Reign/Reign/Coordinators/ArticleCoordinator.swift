//
//  MovieCoordinator.swift
//  ios-recruiting-hsa
//
//  Created by Hans Fehrmann on 5/28/19.
//  Copyright © 2019 Hans Fehrmann. All rights reserved.
//

import Foundation
import UIKit

class ArticleCoordinator: Coordinator {

    private let navigationController: UINavigationController
    private let appDependencies: AppDependencies

    init(navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.navigationController = navigationController
        self.appDependencies = appDependencies
    }

    func start() {
        let controller = ListArticlesWireframe.viewController(
            withDelegate: self,
            appDependencies: appDependencies
        )
        navigationController.viewControllers = [controller]
    }
}

extension ArticleCoordinator: ListArticlesViewDelegate {

    func favoriteMovieView(_ viewController: ListArticlesViewController, didSelect movie: Article) {

    }
}
