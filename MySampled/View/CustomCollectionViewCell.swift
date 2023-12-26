import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    lazy var imageArtistSample: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "artist1")
        imageView.layer.cornerRadius = frame.width / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var labelSongSample: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Aharoni", size: 15)
        label.text = "Son Sampler"
        label.numberOfLines = 0
        label.textColor = .white
        label.sizeToFit()
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var labelSampleMinute: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Aharoni", size: 14)
        label.text = ""
        label.numberOfLines = 0
        label.textColor = .white
        label.sizeToFit()
     //   label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var labelArtistSample: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Aharoni", size: 15)
        label.text = "Artist"
        label.numberOfLines = 0
        label.textColor = .white
        label.sizeToFit()

        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stacksampleView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let identifier = "CustomCell"
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageArtistSample.layer.cornerRadius = 10
        imageArtistSample.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) n'a pas été implémenté")
    }
    
    private func setupViews() {
       addSubview(imageArtistSample)
    addSubview(stacksampleView)
        stacksampleView.addArrangedSubview(labelSongSample)
        stacksampleView.addArrangedSubview(labelArtistSample)
        stacksampleView.addArrangedSubview(labelSampleMinute)

        initImageSample()
        initStackViewSample()
        
    }
    
    func initImageSample() {
        NSLayoutConstraint.activate([
            imageArtistSample.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            imageArtistSample.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageArtistSample.widthAnchor.constraint(equalToConstant: 90),
            imageArtistSample.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    func initStackViewSample() {
        NSLayoutConstraint.activate([
            stacksampleView.leadingAnchor.constraint(equalTo: imageArtistSample.trailingAnchor, constant: 10),
            stacksampleView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stacksampleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
            stacksampleView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10),
        ])
    }

}
