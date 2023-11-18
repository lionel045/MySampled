import UIKit
import AVFoundation
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
        self.view.backgroundColor = .white
        
        initImage()
        // imageView.image = imageUrl
        //  loadStackView()
        
        
    }
    
    private func initImage() {
        self.imageView = UIImageView()
        self.imageView.contentMode = .scaleAspectFit
        guard let image = UIImage(named: "user") else {return}
        let cropImage = self.cropImage(image: image)
        self.imageView.image = cropImage
    
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.imageView)
        NSLayoutConstraint.activate([
            //self.imageView.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor),
            //self.imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 300),
            self.imageView.leadingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor),
            self.imageView.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor),
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor)
            
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
                        let cropImage = self?.cropImage(image: image)
                        self?.imageView.image = cropImage
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

extension SecondViewController {
    
    
    func cropImage(image: UIImage) -> UIImage {
        
        let maxSize = CGSize(width: 400, height: 400)
            
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
