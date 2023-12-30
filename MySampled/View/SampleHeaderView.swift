// 1. Créez une classe d'en-tête personnalisée

import UIKit
class SampleHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SampleHeaderViewReuse"

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
