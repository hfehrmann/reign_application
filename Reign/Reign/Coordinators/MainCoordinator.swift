//
//  MainCoordinator.swift
//  ios-recruiting-hsa
//
//  Created by Hans Fehrmann on 5/27/19.
//  Copyright © 2019 Hans Fehrmann. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {

    private let window: UIWindow

    private var articleCoordinator: ArticleCoordinator!
    private lazy var appDependecies = buildDependencies()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let navigation = UINavigationController()
        articleCoordinator = ArticleCoordinator(
            navigationController: navigation,
            appDependencies: appDependecies
        )
        articleCoordinator.start()

        window.rootViewController = navigation
        window.makeKeyAndVisible()
    }
}

private  extension MainCoordinator {

    func buildDependencies() -> AppDependencies {
        let dependencies = AppDependencies(
            articleManager: articleManagerDefault()
        )
        return dependencies
    }
}
