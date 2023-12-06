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
 lazy var sampleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
     layout.scrollDirection = .vertical
     layout.itemSize = CGSize(width: 400, height: 90)
     
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
          collectionView.backgroundColor = .clear
            
        return collectionView
        
    }()
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
            self.currentView.heightAnchor.constraint(equalToConstant: 600)
        ])
         
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor] // De transparent à noir
        gradient.locations = [0.1, 0.3]
        currentView.layer.insertSublayer(gradient, at: 0)
        
        loadStackView()
        initSampleCollectionView()
    }
    
    func initSampleCollectionView(){
        sampleCollectionView.translatesAutoresizingMaskIntoConstraints = false // Ajouté cette ligne
        currentView.addSubview(sampleCollectionView)
        
        NSLayoutConstraint.activate([
        
            sampleCollectionView.topAnchor.constraint(equalTo: currentStackView.bottomAnchor, constant: 90),
            sampleCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            sampleCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            sampleCollectionView.heightAnchor.constraint(equalToConstant: 300)
            
        ])
        print(self.sampleCollectionView.frame.width)

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
            currentStackView.topAnchor.constraint(equalTo: currentView.topAnchor, constant: 90 )
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
    
    
    
}
