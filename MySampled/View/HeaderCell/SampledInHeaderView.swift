//
//  SampledInHeaderView.swift
//  MySampled
//
//  Created by Lion on 23/12/2023.
//

import UIKit

class SampledInHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SampledInHeaderViewReuse"

    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont(name: "Aharoni", size: 26)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        // Configurez votre titleLabel ici
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
