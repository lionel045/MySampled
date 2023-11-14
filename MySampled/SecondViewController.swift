import UIKit

protocol Delegation {
    func superviseResult(result: Bool?)
}

class SecondViewController: UIViewController {
    var delegate: Delegation?
    var imageUrl: UIImage?
    let currentStackView =  UIStackView()
    var imageView = UIImageView()
    let playButton = UIButton()
    var findResult : Bool?
    let shareButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .gray
        
        initImage()
        imageView.image = imageUrl
        loadStackView()
        
        
    }
    
    func initImage() {
        self.imageView = UIImageView()
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.image = UIImage(named: "user")
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.imageView)
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor),
            self.imageView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor),
            self.imageView.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor),
            self.imageView.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor),
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.imageView.widthAnchor.constraint(equalToConstant: 300 ),
            self.imageView.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    
    func initShareButton(){
        let diameter = 30
        shareButton.setImage(UIImage(named: "shareButton"), for: .normal)
        shareButton.contentMode = .scaleToFill
        self.view.addSubview(shareButton)
        shareButton.clipsToBounds = true
        shareButton.layer.cornerRadius = CGFloat(diameter / 2)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.layer.opacity = 0.5
    }
    
    func initPlayButton() {
        let diameter = 30
        playButton.setImage(UIImage(named: "playButton"), for: .normal)
        playButton.contentMode = .scaleToFill
        self.view.addSubview(playButton)
        playButton.clipsToBounds = true
        playButton.layer.cornerRadius = CGFloat(diameter / 2)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.layer.opacity = 0.5
    }
    
    func loadStackView() {
        
        
        currentStackView.axis = .horizontal
        currentStackView.distribution = .fillEqually
        self.view.addSubview(currentStackView)
        currentStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            currentStackView.widthAnchor.constraint(equalToConstant: 200),
            currentStackView.heightAnchor.constraint(equalToConstant: 100),
            currentStackView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
            
        ])
        initPlayButton()
        initShareButton()
        currentStackView.addArrangedSubview(shareButton)
        currentStackView.addArrangedSubview(playButton)
        
    }
    
    func addCoverImage(imageCoverURL: String) {
        if let url = URL(string: imageCoverURL) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Erreur de réponse HTTP")
                    self?.delegate?.superviseResult(result: false)
                    return
                }

                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                        self?.delegate?.superviseResult(result: true)

                    }

                    } else {
                    print("Erreur de téléchargement de l'image ou format incorrect")
                    self?.delegate?.superviseResult(result: false)
                }
            }
            task.resume()
        }
    }

    
 
}
