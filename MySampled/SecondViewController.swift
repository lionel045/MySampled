import UIKit
import AVFoundation

class SecondViewController: UIViewController {
  
    
    var artistImageView: ArtistImageView!
    var scrollView: UIScrollView!
    var titleArtist: UILabel!
    var titleSong: UILabel!
    var currentView: UIView!
    
    var currentIndex: Int?
    var dataImages: [UIImage] = [
        UIImage(named: "artist1")!,
        UIImage(named: "artist2")!,
        UIImage(named: "artist3")!,
        UIImage(named: "artist4")!,
        UIImage(named: "artist5")!,
        UIImage(named: "artist6")!,
       
    ]
        var currentStackView = UIStackView()
    var infoViewScroll: ViewInfoScroll!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(1)
                
        initArtistImageView()
        initScrollView()
        infoViewScroll.sampleCollectionView.dataSource = self
        infoViewScroll.sampleCollectionView.delegate = self
        infoViewScroll.sampleCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
        view.bringSubviewToFront(scrollView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let bottomOfImage = artistImageView.frame.maxY
        scrollView.contentInset = UIEdgeInsets(top: bottomOfImage, left: 0, bottom: 0, right: 0)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height + bottomOfImage )
    }

    
    private func initArtistImageView() {
        artistImageView = ArtistImageView() // Ajustez la hauteur au besoin
        view.addSubview(artistImageView)
        artistImageView.clipsToBounds = false
        artistImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistImageView.topAnchor.constraint(equalTo: view.topAnchor),
            artistImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            artistImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            artistImageView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }

    private func initScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
           scrollView.topAnchor.constraint(equalTo: view.topAnchor,constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 0),
        ])
        initViewScroll()
        scrollView.clipsToBounds = false
    }
    
    
    private func initViewScroll(){
        infoViewScroll = ViewInfoScroll()

          infoViewScroll.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(infoViewScroll)

        NSLayoutConstraint.activate([
            infoViewScroll.topAnchor.constraint(equalTo: scrollView.topAnchor),
            infoViewScroll.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            infoViewScroll.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            infoViewScroll.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            infoViewScroll.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
        ])
    }


}
extension SecondViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Chaque section a maintenant 4 éléments (2x2)
        return 3
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Le nombre total d'éléments divisé par le nombre d'éléments par section
        return Int(ceil(Double(dataImages.count) / 3.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? CustomCollectionViewCell else {
            fatalError("Unable to dequeue CustomCollectionViewCell")
        }
        
        
        let numberOfItemsPerSection = 3  // Renommez pour plus de clarté
        
        let indexArrayImage = indexPath.section * numberOfItemsPerSection + indexPath.item
        
        print(indexArrayImage)
        
        if indexArrayImage < dataImages.count {
            let image = dataImages[indexArrayImage]
            cell.imageArtistSample.image = image
        } else {
            cell.imageArtistSample.image = nil
        }
        
        return cell
        
    }
    
    
}
