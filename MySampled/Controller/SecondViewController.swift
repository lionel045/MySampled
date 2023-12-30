import AVFoundation
import UIKit

class SecondViewController: UIViewController {
    var artistImageView: ArtistImageView!
    var scrollView: UIScrollView!
    var titleArtist: UILabel!
    var titleSong: UILabel!
    var currentView: UIView!
    lazy var dismissButton = {
        var button = UIButton(type: .custom)
        button.setImage(UIImage(named: "close"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(dismissCurrentView), for: .touchUpInside)

        return button
    }()

    var currentIndex: Int?
    var dataImages: [UIImage] = [
        //        UIImage(named: "artist1")!,
        //        UIImage(named: "artist2")!,
        //        UIImage(named: "artist3")!,
        //        UIImage(named: "artist4")!,
        //        UIImage(named: "artist5")!,
        //        UIImage(named: "artist6")!,
    ]

    var dataSample: [TrackSample?] = []

    var currentStackView = UIStackView()
    var infoViewScroll: ViewInfoScroll!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(1)

        initArtistImageView()
        initScrollView()
        initDismiss()
        infoViewScroll.sampleCollectionView.dataSource = self
        infoViewScroll.sampleCollectionView.delegate = self
        infoViewScroll.delegation?.hideLabelSample(arrayOfSample: dataSample)
        infoViewScroll.sampleCollectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
        view.bringSubviewToFront(scrollView)
        view.bringSubviewToFront(dismissButton) // Ceci place le bouton au-dessus de la scrollView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let bottomOfImage = artistImageView.frame.maxY
        scrollView.contentInset = UIEdgeInsets(top: bottomOfImage, left: 0, bottom: 0, right: 0)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height + bottomOfImage)
    }

    func initDismiss() {
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dismissButton)

        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            dismissButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10)
        ])
    }

    @objc func dismissCurrentView() {
        dismiss(animated: true)
    }

    func addCoverImage(imageCoverURL: String, label: (String, String)) async {
        do {
            if let image = try await ImageService.shared.downloadImage(from: imageCoverURL) {
                await MainActor.run {
                    self.artistImageView.delegation?.passData(artistInfoImage: image)
                    self.infoViewScroll.delegation?.retrieveNewLabel(labelArtistandSong: label)
                }
            }
        } catch {
            print("Erreur lors du téléchargement de l'image : \(error)")
        }
    }

    func addSampleArray(sampleRetrieve: [TrackSample?]) async {
        dataSample = sampleRetrieve
        dataImages = []
        for sample in sampleRetrieve {
            if let url = sample?.source_track?.medium_image_url {
                let image = try? await ImageDownloadService.downloadSampleImage(artistImage: url)
                dataImages.append(image!)
            }
        }
        infoViewScroll.delegation?.hideLabelSample(arrayOfSample: dataSample)
        DispatchQueue.main.async {
            self.infoViewScroll?.sampleCollectionView.reloadData()
        }
    }

    private func initArtistImageView() {
        artistImageView = ArtistImageView()
        artistImageView.delegation = self // Ajustez la hauteur au besoin
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
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        initViewScroll()
        scrollView.clipsToBounds = false
    }

    private func initViewScroll() {
        infoViewScroll = ViewInfoScroll()
        infoViewScroll.delegation = self

        infoViewScroll.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(infoViewScroll)

        NSLayoutConstraint.activate([
            infoViewScroll.topAnchor.constraint(equalTo: scrollView.topAnchor),
            infoViewScroll.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            infoViewScroll.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            infoViewScroll.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            infoViewScroll.widthAnchor.constraint(equalTo: scrollView.widthAnchor)

        ])
    }
}

extension SecondViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        // Chaque section a maintenant 4 éléments (2x2)
        return 3
    }

    func numberOfSections(in _: UICollectionView) -> Int {
        // Le nombre total d'éléments divisé par le nombre d'éléments par section
        return Int(ceil(Double(dataSample.count) / 3.0))
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? CustomCollectionViewCell else {
            fatalError("Unable to dequeue CustomCollectionViewCell")
        }

        let numberOfItemsPerSection = 3
        let indexArrayImage = indexPath.section * numberOfItemsPerSection + indexPath.item

        if indexArrayImage < dataSample.count {
            let trackSample = dataSample[indexArrayImage]
            let artistName = trackSample?.source_track?.full_artist_name ?? "Unknown Artist"
            let trackName = trackSample?.source_track?.track_name ?? "Unknown Track"
            cell.labelArtistSample.text = "\(artistName)"
            cell.labelSongSample.text = "\(trackName)"
            cell.imageArtistSample.image = dataImages[indexArrayImage]
        } else {
            cell.imageArtistSample.image = nil
            cell.labelArtistSample.text = ""
        }

        return cell
    }
}

extension SecondViewController: ArtistDelegate {
    func passData(artistInfoImage: UIImage) {
        artistImageView.updateFrontUi(imageArtist: artistInfoImage)
    }
}

extension SecondViewController: labelDelegation {
    func retrieveNewLabel(labelArtistandSong: (String, String)) {
        infoViewScroll.updateLabel(label: labelArtistandSong)
    }
}
