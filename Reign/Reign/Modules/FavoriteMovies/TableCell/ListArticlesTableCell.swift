//
//  FavoriteMovieTableCell.swift
//  ios-recruiting-hsa
//
//  Created by Hans Fehrmann on 5/28/19.
//  Copyright © 2019 Hans Fehrmann. All rights reserved.
//

import Foundation
import UIKit

protocol ListArticlesTableCell: UITableViewCell {
    func configure(viewModel: ListArticlesCellViewModel)
}

class ListArticlesTableCellImpl: UITableViewCell {

    private var titleLabel: UILabel!
    private var subTitleLabel: UILabel!

    private let horizontalEdgeInset: CGFloat = 15

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        backgroundColor = .white
        setTitle()
        setSubtitle()

    }

    private func setTitle() {
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.numberOfLines = 2

        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = titleLabel.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: horizontalEdgeInset
        )
        let trailingConstraint = trailingAnchor.constraint(
            equalTo: titleLabel.trailingAnchor,
            constant: horizontalEdgeInset
        )
        titleLabel.centerYAnchor.constraint(equalTo: topAnchor, constant: 23).isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
    }

    private func setSubtitle() {
        subTitleLabel = UILabel()
        subTitleLabel.textColor = .darkGray
        subTitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subTitleLabel.numberOfLines = 1

        addSubview(subTitleLabel)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = subTitleLabel.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: horizontalEdgeInset
        )

        bottomAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 5).isActive = true
        leadingConstraint.isActive = true
    }

}

extension ListArticlesTableCellImpl: ListArticlesTableCell {

    func configure(viewModel: ListArticlesCellViewModel) {
        let author = viewModel.author
        let timeDifference = viewModel.timeDifference
        titleLabel.text = viewModel.title
        subTitleLabel.text = "\(author) - \(timeDifference)"
    }
}
