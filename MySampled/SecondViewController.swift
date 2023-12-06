import UIKit
import AVFoundation

class SecondViewController: UIViewController {
    
    var artistImageView: ArtistImageView!
    var scrollView: UIScrollView!
    var titleArtist: UILabel!
    var titleSong: UILabel!
    var currentView: UIView!
    var dataImages: [UIImage] = [
        UIImage(named: "artist1")!,
        UIImage(named: "artist2")!,
        UIImage(named: "artist3")!
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
           scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
extension SecondViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataImages.count

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 10 // Espacement entre les cellules
        }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? CustomCollectionViewCell else {
                  fatalError("Unable to dequeue CustomCollectionViewCell")
              }
              // Configurez la cellule avec l'image à l'index correspondant
              let image = dataImages[indexPath.item]
              cell.imageArtistSample.image = image
              
              return cell
    }
    
    
    
    
    
}
