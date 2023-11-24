import UIKit
import AVFoundation


class SecondViewController: UIViewController {
    
    
    var imageUrl: UIImage?
    var scrollView: UIScrollView!
    var titleArtist: UILabel!
    var titleSong: UILabel!
    var mirrorImageView: UIImageView?
    let currentStackView =  UIStackView()
    var imageView = UIImageView()
    let playButton = UIButton()
    var findResult : Bool?
    let shareButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(1)
        
        
        initImage()
        initScrollView()
        
        // loadStackView()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Réglez le contentInset de la scrollView pour que son contenu commence en dessous de l'image.
        let bottomOfImage = imageView.frame.maxY
        scrollView.contentInset = UIEdgeInsets(top: bottomOfImage, left: 0, bottom: 0, right: 0)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height + bottomOfImage)
        
        updateMirrorEffect()

        
    }
    
    
    private func initImage() {
        self.imageView = UIImageView()
        self.imageView.contentMode = .scaleAspectFill
        guard let image = UIImage(named: "user") else {return}
        let cropImage = self.cropImage(image: image)
        self.imageView.image = cropImage

        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.imageView)
        NSLayoutConstraint.activate([

            self.imageView.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor),
            self.imageView.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor),
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
        ])
        
        addMirrorEffect()
        
    }
    
    func addAditionnalView() {
        
        let whiteView = UIView(frame: view.bounds)
     
        whiteView.backgroundColor = .white.withAlphaComponent(0.1)
        imageView.addSubview(whiteView)
        
    }
    
    
    private func addMirrorEffect() {
        guard let image = imageView.image else { return }
        mirrorImageView = UIImageView(image: image)
        guard let mirrorImageView = mirrorImageView else { return }

        mirrorImageView.contentMode = .scaleAspectFill
        mirrorImageView.clipsToBounds = true
        mirrorImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
        mirrorImageView.frame = imageView.frame.offsetBy(dx: 0, dy: imageView.frame.size.height)

        // Créer et configurer le gradient
        let gradient = CAGradientLayer()
        gradient.frame = mirrorImageView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.3).cgColor]
        gradient.locations = [0.8, 1]

        // Ajouter le gradient comme sous-couche de mirrorImageView
        mirrorImageView.layer.mask = gradient

        view.addSubview(mirrorImageView)
        // Appliquer l'effet de flou
//        let blurEffect = UIBlurEffect(style: .dark) // Ou .light, .extraLight, etc.
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
//        mirrorImageView.addSubview(blurEffectView)
//
//        // Ajouter des contraintes
//        NSLayoutConstraint.activate([
//            blurEffectView.topAnchor.constraint(equalTo: mirrorImageView.topAnchor),
//            blurEffectView.bottomAnchor.constraint(equalTo: mirrorImageView.bottomAnchor),
//            blurEffectView.leadingAnchor.constraint(equalTo: mirrorImageView.leadingAnchor),
//            blurEffectView.trailingAnchor.constraint(equalTo: mirrorImageView.trailingAnchor)
//        ])

    }


     
    
    private func updateMirrorEffect() {
           guard let mirrorImageView = mirrorImageView else { return }
           
           mirrorImageView.frame = imageView.frame.offsetBy(dx: 0, dy: imageView.frame.size.height)
        
        if let gradient = mirrorImageView.layer.mask as? CAGradientLayer {
               gradient.frame = mirrorImageView.bounds
           }
       }
    
    
    func initLabelTitleArtist() -> UILabel
    {
        
        let titleArtist = UILabel()
        titleArtist.text = "Contoso"
        titleArtist.font = UIFont.systemFont(ofSize: 33)
        titleArtist.textColor = .white
        titleArtist.numberOfLines = 0
        return titleArtist
    }
    
    func initLabelTitleSong() -> UILabel
    {
        
        let titleSong = UILabel()
        titleSong.text = "Beat it"
        titleSong.font = UIFont.systemFont(ofSize: 31)
        titleSong.textColor = .white
        titleSong.numberOfLines = 0
        return titleSong
    }
    
    
    
    
    func initScrollView()
    {
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = UIColor.clear
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        addAditionnalView()
        loadStackView()
        
        
        //scrollView.contentSize = CGSize(width: view.frame.width, height: 1000) // Exemple de taille
        
    }

    
    
    
    func loadStackView() {
        currentStackView.axis = .vertical
        currentStackView.spacing = 10
        currentStackView.alignment = .fill
        currentStackView.distribution = .fill
        currentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.scrollView.addSubview(currentStackView)
        NSLayoutConstraint.activate([
            currentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,constant: 30),
            currentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            currentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            
        ])
        
        initLabelTitleArtist()
        initLabelTitleSong()
        
        currentStackView.addArrangedSubview(initLabelTitleArtist())
        currentStackView.addArrangedSubview(initLabelTitleSong())
    }
    
    func addCoverImage(imageCoverURL: String) {
        if let url = URL(string: imageCoverURL) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Erreur de réponse HTTP")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        let cropImage = self?.cropImage(image: image)
                        self?.imageView.image = cropImage
                        
                    }
                    
                } else {
                    print("Erreur de téléchargement de l'image ou format incorrect")
                }
            }
            task.resume()
        }
    }
    
    
    
}

extension SecondViewController {
    
    
    func cropImage(image: UIImage) -> UIImage {
        
        let maxSize = CGSize(width: 450, height: 450)
        
        let availableRect = AVMakeRect(aspectRatio: image.size, insideRect: .init(origin: .zero, size: maxSize))
        let targetSize = availableRect.size
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        
        let resized = renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
            
        }
        
        return resized
    }
    
    
    
    
    
    
}
