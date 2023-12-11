//
//  SampleHeaderView.swift
//  MySampled
//
//  Created by Lion on 10/12/2023.
//

import UIKit

class SampleHeaderView: UICollectionReusableView {
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLabel() {
        titleLabel.text = "Sample"
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 26)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
