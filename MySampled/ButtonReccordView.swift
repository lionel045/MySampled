import UIKit
import Lottie

class ButtonReccordView: UIButton {
    
    private var stopButton : UIButton!
    private var reccordButton: UIButton!
    private var playButton = UIButton(type: .custom)
    private var pulseAnimation: PulseAnimation!
    var ringBack: ((UIButton) -> ())?
    var testPlayBtn: ((UIButton)->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        //  setUpStopButton()
        circleReccordButton()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func circleReccordButton() {
        let diameter: CGFloat = 250
        reccordButton = UIButton(frame: CGRect(x: 0, y: 0, width: diameter, height: diameter))
        reccordButton.center = center
        reccordButton.setTitle("Appuie", for: .normal)
        reccordButton.layer.cornerRadius = diameter / 2
        reccordButton.clipsToBounds = true
        reccordButton.setTitleColor(.white, for: .normal)
        reccordButton.addTarget(self, action: #selector(handleTapGesture), for: .touchUpInside)
        reccordButton.translatesAutoresizingMaskIntoConstraints = false
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = reccordButton.bounds
        gradientLayer.colors = [
            UIColor(red: 4/255, green: 2/255, blue: 10/255, alpha: 1).cgColor,
            UIColor(red: 29/255, green: 128/255, blue: 229/255, alpha: 1).cgColor,
            UIColor(red: 194/255, green: 137/255, blue: 235/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        reccordButton.layer.insertSublayer(gradientLayer, at: 0)
        
        self.addSubview(reccordButton)
        
        NSLayoutConstraint.activate([
            reccordButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            reccordButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            reccordButton.widthAnchor.constraint(equalToConstant: diameter),
            reccordButton.heightAnchor.constraint(equalToConstant: diameter)
        ])
        
        // Lottie animation setup
        let animationDiameter: CGFloat = diameter + 140
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named("Blob")
        animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.isUserInteractionEnabled = false
        self.addSubview(animationView)
        self.sendSubviewToBack(animationView)
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: animationDiameter),
            animationView.heightAnchor.constraint(equalToConstant: animationDiameter)
        ])
    }
    
    
  

    
    
    
    
    private func setUpStopButton(){
        stopButton = UIButton(type: .custom)
        stopButton.contentMode = .scaleAspectFit
        stopButton.setTitle("Stop", for: .normal)
        stopButton.setTitleColor(.white, for: .normal)
        stopButton.backgroundColor = UIColor.purple.withAlphaComponent(0.4)
        stopButton.clipsToBounds = true
        stopButton.layer.cornerRadius = 25
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stopButton)
        
        NSLayoutConstraint.activate([
            stopButton.widthAnchor.constraint(equalToConstant: 150),
            stopButton.heightAnchor.constraint(equalToConstant: 50),
            stopButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            stopButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100)
        ])
    }
    
    @objc func handleTapGesture() {
        guard reccordButton.isEnabled else {
            return
        }
        
        ringBack?(reccordButton)
        
        checkRecordButtonState(reccordButton)
        reccordButton.isEnabled = false
        
        if pulseAnimation == nil {
            createPositionPulseAnimation()
        }
        
        UIView.animate(withDuration: 4) { [self] in
            reccordButton.layer.opacity = 0.7
        } completion: { [weak self] finish in
            self?.pulseAnimation.removeFromSuperview()
            self?.pulseAnimation = nil
            self?.reccordButton.layer.opacity = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
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
        reccordButton.layer.removeAllAnimations()
        reccordButton.layer.opacity = 1
    }
}
