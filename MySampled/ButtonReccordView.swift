//
//  ButtonReccordView.swift
//  MySampled
//
//  Created by Lion on 24/08/2023.
//

import UIKit

class ButtonReccordView: UIButton {
    
    private var reccordButton : UIButton!
    private var pulseAnimation: PulseAnimation!
    var ringBack: ((UIButton) -> ())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView(){
        reccordButton = UIButton(type: .custom)
        reccordButton.addTarget(nil, action: #selector(handleTapGesture), for: .touchUpInside)
        reccordButton.contentMode = .scaleAspectFit
        reccordButton.setTitle("Appuie", for: .normal)
        reccordButton.backgroundColor = .darkGray
        reccordButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(reccordButton)
        
        NSLayoutConstraint.activate([
            reccordButton.widthAnchor.constraint(equalToConstant: 300),
            reccordButton.heightAnchor.constraint(equalToConstant: 200),
            reccordButton.topAnchor.constraint(equalTo: topAnchor),
            reccordButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            reccordButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            reccordButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc func handleTapGesture() {
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        ringBack?(reccordButton)
        UIView.animate(withDuration: 10) {
            self.reccordButton.layer.opacity = 0.7
            self.createPositionPulseAnimation()
        } completion: { [weak self ] finish in
            self?.pulseAnimation.removeFromSuperview()
            self?.reccordButton.layer.opacity = 1
        }
    }
    
    func createPositionPulseAnimation() {
    pulseAnimation = PulseAnimation(frame: bounds)
        self.addSubview(pulseAnimation)

    pulseAnimation.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        
        pulseAnimation.centerXAnchor.constraint(equalTo: centerXAnchor),
        pulseAnimation.centerYAnchor.constraint(equalTo: centerYAnchor),
        
    ])
        
    }
    
    func resetButton() {
        // Réinitialisez le bouton à son état initial ici
        reccordButton.layer.removeAllAnimations()
        pulseAnimation.removeFromSuperview()
        reccordButton.layer.opacity = 1
    }

}
