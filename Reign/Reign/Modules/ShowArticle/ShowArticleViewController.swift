//
//  FavoriteMoviesViewController.swift
//  ios-recruiting-hsa
//
//  Created by Hans Fehrmann on 5/28/19.
//  Copyright © 2019 Hans Fehrmann. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class ShowArticleViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var errorView: UIView!

    private var viewModel: ShowArticleViewModel

    init(viewModel: ShowArticleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ShowArticle", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This view should not be instantiaded by storyboard")
    }

    override func viewDidLoad() {
    }

    override func viewWillAppear(_ animated: Bool) {

    }
}
