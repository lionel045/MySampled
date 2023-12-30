//
//  ViewInfoScroll.swift
//  MySampled
//
//  Created by Lion on 03/12/2023.
//

import UIKit
import Foundation

protocol LabelDelegation {
    func retrieveNewLabel(labelArtistandSong: (String, String))
    func checkStateDataSampleSource() -> [TrackSample?]
    func checkStateDataSampleDest() -> [TrackSample?]
}

class ViewInfoScroll: UIView {
    private var titleArtist: UILabel!
    private var titleSong: UILabel!
    private var currentView: UIView!
    var delegation: LabelDelegation?

    lazy var sampleCollectionView: UICollectionView = {
        // Initialiser avec un layout temporaire
        let tempLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: tempLayout)
        collectionView.register(SampleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SampleHeaderView.reuseIdentifier)
        collectionView.register(SampledInHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SampledInHeaderView.reuseIdentifier)

        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.delaysContentTouches = false
        // collectionView.showsHorizontalScrollIndicator = true

        return collectionView
    }()

    func updateLayout() {
        let sampleSource = self.delegation?.checkStateDataSampleSource() ?? []
           let sampleDest = self.delegation?.checkStateDataSampleDest() ?? []
        sampleCollectionView.setCollectionViewLayout(createCompositionalLayout(sampleSource: sampleSource, sampleDest: sampleDest), animated: true)
    }

    func createCompositionalLayout(sampleSource: [TrackSample?], sampleDest: [TrackSample?]) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            // Configuration de base de l'item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            // Déterminer le nombre d'éléments dans la section
            let itemCount = sectionIndex == 0 ? sampleSource.count : sampleDest.count

                 let group: NSCollectionLayoutGroup
                 if itemCount < 2 {
                     // Groupe horizontal pour les sections avec moins de deux éléments
                     let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
                     group = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: [item])
                 } else {
                     // Groupe vertical pour les autres cas
                     let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.45))
                     group = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [item])
                     group.interItemSpacing = .fixed(10)
                }

            // Configuration de la section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            section.interGroupSpacing = 10
            // Configuration de l'en-tête de section
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(25))
            let headerIdentifier = sectionIndex == 0 ? SampleHeaderView.reuseIdentifier : SampledInHeaderView.reuseIdentifier
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            header.pinToVisibleBounds = true
            section.boundarySupplementaryItems = [header]

            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
           config.interSectionSpacing = 20 // Ajoutez de l'espace entre les sections.
           layout.configuration = config
        return layout
    }

    private var currentStackView = UIStackView()
    private var gradient = CAGradientLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewInfoScroll()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) n'a pas été implémenté")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = currentView.bounds // Mise à jour de la taille du gradient
    }
    func initViewInfoScroll() {
        currentView = UIView()
        currentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(currentView)
        NSLayoutConstraint.activate([
            self.currentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.currentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.currentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.currentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 900)
        ])
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor] // De transparent à noir
        gradient.locations = [0.1, 0.3]
        currentView.layer.insertSublayer(gradient, at: 0)

        loadStackView()
        // initLabelSample()
        initSampleCollectionView()
    }

    func updateLabel(label: (String, String)) {
        DispatchQueue.main.async { [weak self] in
            if let strongSelf = self {
                strongSelf.titleArtist.text = label.0
                strongSelf.titleSong.text = label.1
            }
        }
    }
   private func initSampleCollectionView() {
        sampleCollectionView.translatesAutoresizingMaskIntoConstraints = false // Ajouté cette ligne
        currentView.addSubview(sampleCollectionView)
       sampleCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        NSLayoutConstraint.activate([
            sampleCollectionView.topAnchor.constraint(equalTo: currentStackView.bottomAnchor, constant: 20),
            sampleCollectionView.leadingAnchor.constraint(equalTo: currentView.leadingAnchor),
            sampleCollectionView.trailingAnchor.constraint(equalTo: currentView.trailingAnchor),
            sampleCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            sampleCollectionView.heightAnchor.constraint(equalToConstant: 600)
        ])
        sampleCollectionView.bounces = false
        sampleCollectionView.bouncesZoom = false
    }
    private func loadStackView() {
        currentStackView.axis = .vertical
        currentStackView.spacing = 3
        currentStackView.alignment = .fill
        currentStackView.distribution = .fill
        currentStackView.translatesAutoresizingMaskIntoConstraints = false
        currentView.addSubview(currentStackView)
        NSLayoutConstraint.activate([
            currentStackView.leadingAnchor.constraint(equalTo: currentView.leadingAnchor, constant: 15),
            currentStackView.trailingAnchor.constraint(equalTo: currentView.trailingAnchor),
            currentStackView.topAnchor.constraint(equalTo: currentView.topAnchor, constant: 70 )
        ])
        initLabelTitleArtist()
        initLabelTitleSong()
        currentStackView.addArrangedSubview(titleArtist)
        currentStackView.addArrangedSubview(titleSong)
    }
    private func initLabelTitleArtist() {
        titleArtist = UILabel()
        titleArtist.text = "Artiste"
        titleArtist.font = UIFont(name: "Aharoni", size: 37)
        titleArtist.textColor = .white
        titleArtist.numberOfLines = 0
    }
    private func initLabelTitleSong() {
        titleSong = UILabel()
        titleSong.text = "Titre de la chanson"
        titleSong.font = UIFont(name: "Aharoni", size: 35)
        titleSong.textColor = .white
        titleSong.numberOfLines = 0
    }
}
