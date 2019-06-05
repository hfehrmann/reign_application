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

    @IBOutlet private weak var errorView: UIView!
    @IBOutlet private weak var loader: UIActivityIndicatorView!

    private var webView: WKWebView!

    private var viewModel: ShowArticleViewModel

    init(viewModel: ShowArticleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ShowArticle", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This view should not be instantiaded by storyboard")
    }

    override func viewDidLoad() {
        loader.hidesWhenStopped = true
        loader.stopAnimating()
        guard let url = viewModel.articleURL else { return }
        loader.startAnimating()
        errorView.removeFromSuperview()

        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: view.bounds, configuration: webConfiguration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.load(URLRequest(url: url))
        webView.navigationDelegate = self
        view.insertSubview(webView, belowSubview: loader)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true  )
    }
}

extension ShowArticleViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loader.stopAnimating()
    }
}
