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
        reccordButton.setImage(UIImage(named: "mySampled"), for: .normal)
        reccordButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(reccordButton)
        
        NSLayoutConstraint.activate([
            
            reccordButton.widthAnchor.constraint(equalToConstant: 80),
            reccordButton.heightAnchor.constraint(equalToConstant: 80),
            reccordButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            reccordButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc func handleTapGesture() {
        
        ringBack?(reccordButton)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        UIView.animate(withDuration: 8) {
            self.reccordButton.layer.opacity = 0.7
            self.createPositionPulseAnimation()
        } completion: { [weak self ] finish in
            self?.pulseAnimation.removeFromSuperview()
            self?.reccordButton.layer.opacity = 1

        }
    }
    
    func createPositionPulseAnimation() {
    pulseAnimation = PulseAnimation(frame: bounds)
   //elf.createPositionPulseAnimation()
        self.addSubview(pulseAnimation)

    pulseAnimation.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        
        pulseAnimation.centerXAnchor.constraint(equalTo: centerXAnchor),
        pulseAnimation.centerYAnchor.constraint(equalTo: centerYAnchor),
        
    ])
        
    }
    
    
    
}
