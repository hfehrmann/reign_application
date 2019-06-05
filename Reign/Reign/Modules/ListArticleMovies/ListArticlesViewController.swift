//
//  FavoriteMoviesViewController.swift
//  ios-recruiting-hsa
//
//  Created by Hans Fehrmann on 5/28/19.
//  Copyright © 2019 Hans Fehrmann. All rights reserved.
//

import Foundation
import UIKit

class ListArticlesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private var cellIdentifier = "CellIdentifier"
    private var viewModel: ListArticlesViewModel

    init(viewModel: ListArticlesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ListArticles", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("This view should not be instantiaded by storyboard")
    }

    override func viewDidLoad() {
        tableView.register(ListArticlesTableCellImpl.self, forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 70
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = .black
        tableView.tableHeaderView = UIView()
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: 0, height: view.safeAreaInsets.bottom)
        tableView.tableFooterView = footerView
        tableView.backgroundView = PullDownToRefreshMessage()
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self

        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = .lightGray
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl

        view.backgroundColor = .white

        viewModel.removeAtIndex = { [unowned self] _ in
            self.tableView.reloadData()
        }
        viewModel.onUpdate = { [unowned self, unowned refreshControl] in
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

private extension ListArticlesViewController {

    @objc func refreshData() {
        viewModel.refresh()
        tableView.backgroundView = nil
    }
}

extension ListArticlesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequedCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        guard let cell = dequedCell as? ListArticlesTableCell else {
            return UITableViewCell()
        }
        let cellViewModel = viewModel.cellViewModel(forIndex: indexPath)
        cell.configure(viewModel: cellViewModel)
        return cell
    }
}

extension ListArticlesViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        editActionsForRowAt indexPath: IndexPath
    ) -> [UITableViewRowAction]? {
        let title = "Unfavorite"
        let unfavoriteAction = UITableViewRowAction(
            style: .default,
            title: title
        ) { [unowned self] _, indexPath in
            self.viewModel.remove(at: indexPath)
        }
        return [unfavoriteAction]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.select(indexPath: indexPath)
    }
}
