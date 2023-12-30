import AVFoundation
import UIKit

protocol ArtistDelegate: AnyObject {
    func passData(artistInfoImage: UIImage)
}

class ArtistImageView: UIView {
    private var imageView: UIImageView!
    var delegation: ArtistDelegate?
    private var mirrorImageView: UIImageView!
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradient = mirrorImageView.layer.mask as? CAGradientLayer {
            gradient.frame = mirrorImageView.bounds
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        addMirrorEffect()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) n'a pas été implémenté")
    }

    private func setupImageView() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill

        guard let image = UIImage(named: "user") else { return }
        let cropImage = resize(image: image)
        imageView.image = cropImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func addMirrorEffect() {
        mirrorImageView = UIImageView()
        mirrorImageView.image = imageView.image
        mirrorImageView.contentMode = .scaleAspectFill
        mirrorImageView.clipsToBounds = true
        mirrorImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
        mirrorImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mirrorImageView)

        NSLayoutConstraint.activate([
            mirrorImageView.topAnchor.constraint(equalTo: imageView.bottomAnchor), // Commence juste en dessous de
            mirrorImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mirrorImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mirrorImageView.heightAnchor.constraint(equalToConstant: 400) // Réfléchir seulement le tiers inférieur
        ])

        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradient.locations = [0.8, 1]
        mirrorImageView.layer.mask = gradient

        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        mirrorImageView.addSubview(blurEffectView)

        NSLayoutConstraint.activate([
            blurEffectView.bottomAnchor.constraint(equalTo: mirrorImageView.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: mirrorImageView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: mirrorImageView.trailingAnchor),
            blurEffectView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    func updateFrontUi(imageArtist: UIImage) {
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                let cropImage = strongSelf.resize(image: imageArtist)
                self?.imageView.image = cropImage
                self?.imageView.alpha = 0.8
                self?.mirrorImageView.image = cropImage
            }
        }
    }
}

extension ArtistImageView {
    func resize(image: UIImage) -> UIImage {
        let maxSize = CGSize(width: 400, height: 400)
        let availableRect = AVMakeRect(aspectRatio: image.size, insideRect: .init(origin: .zero, size: maxSize))
        let targetSize = availableRect.size
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        let resized = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return resized
    }
}
