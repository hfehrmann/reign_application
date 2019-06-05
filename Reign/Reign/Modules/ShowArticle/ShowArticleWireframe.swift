//
//  FavoriteMoviesWireframe.swift
//  ios-recruiting-hsa
//
//  Created by Hans Fehrmann on 5/31/19.
//  Copyright © 2019 Hans Fehrmann. All rights reserved.
//

import Foundation
import UIKit

class ShowArticleWireframe {

    static func viewController(article: Article) -> UIViewController {
        let viewModel = ShowArticleViewModelImpl(article: article)
        let controller = ShowArticleViewController(viewModel: viewModel)
        return controller
    }
}
