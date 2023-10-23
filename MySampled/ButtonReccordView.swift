//
//  ButtonReccordView.swift
//  MySampled
//
//  Created by Lion on 24/08/2023.
//

import UIKit
import Lottie
class ButtonReccordView: UIButton {
    
    private var reccordButton : UIButton!
    private var pulseAnimation: PulseAnimation!
    var ringBack: ((UIButton) -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButtonReccord()
        circleReccordButton()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func circleReccordButton() {
        let diameter: CGFloat = 250

        // Créer le bouton avec gradient
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: diameter, height: diameter))
        button.center = center
        button.setTitle("Appuie", for: .normal)
        button.layer.cornerRadius = diameter / 2
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleTapGesture), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.colors = [
            UIColor(red: 4/255, green: 2/255, blue: 10/255, alpha: 1).cgColor,
            UIColor(red: 29/255, green: 128/255, blue: 229/255, alpha: 1).cgColor,
            UIColor(red: 194/255, green: 137/255, blue: 235/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        button.layer.insertSublayer(gradientLayer, at: 0)

        self.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: diameter),
            button.heightAnchor.constraint(equalToConstant: diameter)
        ])

        // Créer et configurer l'animation Lottie
        let animationDiameter: CGFloat = diameter + 140 // Augmente davantage la taille de l'animation
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named("Blob")
        animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.isUserInteractionEnabled = false
        self.addSubview(animationView)
        self.sendSubviewToBack(animationView) 
        // Place l'animation derrière le bouton
        
        

        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: animationDiameter),
            animationView.heightAnchor.constraint(equalToConstant: animationDiameter)
        ])
        
      

    }

    
    private func setUpButtonReccord(){
        reccordButton = UIButton(type: .custom)
       // reccordButton.addTarget(nil, action: #selector(handleTapGesture), for: .touchUpInside)
        reccordButton.contentMode = .scaleAspectFit
        reccordButton.setTitle("Stop", for: .normal)
        reccordButton.setTitleColor(.white, for: .normal)
        reccordButton.backgroundColor = UIColor.purple.withAlphaComponent(0.4)

        reccordButton.clipsToBounds = true

        reccordButton.layer.cornerRadius = 25

        reccordButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(reccordButton)
        
        NSLayoutConstraint.activate([
            reccordButton.widthAnchor.constraint(equalToConstant: 150),
            reccordButton.heightAnchor.constraint(equalToConstant: 50),
            reccordButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            reccordButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100)
        ])

    }
    

    @objc func handleTapGesture() {
        // Si le bouton est désactivé, on ne fait rien
        guard reccordButton.isEnabled else {
            return
        }

        ringBack?(reccordButton)

        checkRecordButtonState(reccordButton)
        self.reccordButton.isEnabled = false

        // Vérifie si l'animation de pulsation n'existe pas déjà
        if pulseAnimation == nil {
            createPositionPulseAnimation()
        }

        UIView.animate(withDuration: 5) { [self] in
            self.reccordButton.layer.opacity = 0.7
        } completion: { [weak self] finish in
            self?.pulseAnimation.removeFromSuperview()
            self?.pulseAnimation = nil
            self?.reccordButton.layer.opacity = 1
            
            // Réactiver le bouton après un délai de 5 secondes
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self?.reccordButton.isEnabled = true
            }
        }
    }

    func checkRecordButtonState(_ button: UIButton) {
        if button.isEnabled {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
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
        reccordButton.layer.opacity = 1
    }

}
