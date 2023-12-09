//
//  ViewInfoScroll.swift
//  MySampled
//
//  Created by Lion on 03/12/2023.
//

import UIKit
import Foundation
class ViewInfoScroll: UIView {
    
    private var titleArtist: UILabel!
    private var titleSong: UILabel!
    private var currentView: UIView!
    private lazy var titleSample: UILabel = {
        
        let label = UILabel()
        label.text = "Sample"
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 26)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var sampleCollectionView: UICollectionView = {
         // Utilisez le layout compositional que vous allez créer
         let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
         collectionView.backgroundColor = .clear
         collectionView.translatesAutoresizingMaskIntoConstraints = false
         collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.delaysContentTouches = false
        //  collectionView.showsHorizontalScrollIndicator = true
        
         return collectionView
     }()
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        // Configuration de l'item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.48),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        // Configuration du groupe horizontal
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(400), // Ajusté pour encourager le défilement
                                               heightDimension: .absolute(150))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        
        // Configuration de la section avec défilement horizontal
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
      
        // Création du layout complet avec les sections définies
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.collectionView?.bounces = false
        layout.collectionView?.bouncesZoom = false
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
    
    
    func initViewInfoScroll(){
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
        initLabelSample()
        initSampleCollectionView()
    }
    
    func initSampleCollectionView(){
        sampleCollectionView.translatesAutoresizingMaskIntoConstraints = false // Ajouté cette ligne
        currentView.addSubview(sampleCollectionView)
        
        NSLayoutConstraint.activate([
            sampleCollectionView.topAnchor.constraint(equalTo: titleSample.bottomAnchor, constant: 20),
            sampleCollectionView.leadingAnchor.constraint(equalTo: currentView.leadingAnchor),
            sampleCollectionView.trailingAnchor.constraint(equalTo: currentView.trailingAnchor),
            sampleCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            sampleCollectionView.heightAnchor.constraint(equalToConstant: 400)
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
            currentStackView.leadingAnchor.constraint(equalTo: currentView.leadingAnchor, constant: 30),
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
        titleArtist.font = UIFont.systemFont(ofSize: 33)
        titleArtist.textColor = .white
        titleArtist.numberOfLines = 0
    }
    
    private func initLabelTitleSong() {
        titleSong = UILabel()
        titleSong.text = "Titre de la chanson"
        titleSong.font = UIFont.systemFont(ofSize: 31)
        titleSong.textColor = .white
        titleSong.numberOfLines = 0
    }
    
    private func initLabelSample(){
        
        currentView.addSubview(titleSample)
        
        NSLayoutConstraint.activate([
            titleSample.topAnchor.constraint(equalTo: currentStackView.bottomAnchor, constant: 30),
            titleSample.leadingAnchor.constraint(equalTo: currentView.leadingAnchor,constant: 30),
            
        ])
        
    }
}


