import UIKit

class ButtonReccordView: UIButton, CAAnimationDelegate {
    
    private var stopButton : UIButton!
    private var recordButton: UIButton!
    private var playButton = UIButton(type: .custom)
    var ringBack: ((UIButton) -> ())?
    private var recordArm: UIImageView!
    var testPlayBtn: ((UIButton)->())?
    private var recordArmBottomConstraint: NSLayoutConstraint!
    private var rotationCompletion: (() -> Void)?
    private var armAnimationCompletion: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        //  setUpStopButton()
        circleRecordButton()
        setUpRecordArm()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUpRecordArm() {
        recordArm = UIImageView(image: UIImage(named: "bras"))
        recordArm.contentMode = .scaleAspectFill
        recordArm.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(recordArm)
        recordArmBottomConstraint = recordArm.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: 60) // La constante initiale
        
        NSLayoutConstraint.activate([
            recordArm.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -129),
            recordArm.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: 60),
            recordArm.widthAnchor.constraint(equalToConstant: 80),
            recordArm.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    private func animateRecordArmToTouchRecord() {
        
        let rotationAngle = 80 * (CGFloat.pi / 180)
        UIView.animate(withDuration: 8, delay: 0,options: .curveEaseOut,
                       animations:  {
            
            self.recordArm.transform = CGAffineTransform(rotationAngle: rotationAngle)
            self.layoutIfNeeded()
        }, completion: { _ in
            self.armAnimationCompletion = {
                self.recordArm.transform = .identity
            }
        })
        
    }
    
    private func circleRecordButton() {
        recordButton = UIButton(frame: .zero)
        recordButton.center = self.center
        recordButton.setImage(UIImage(named: "vinyle"), for: .normal)
        recordButton.imageView?.contentMode = .scaleAspectFill // Set contentMode for the imageView of the button
        recordButton.clipsToBounds = true
        recordButton.addTarget(self, action: #selector(handleTapGesture), for: .touchUpInside)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(recordButton)
        
        NSLayoutConstraint.activate([
            recordButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -35),
            recordButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            recordButton.widthAnchor.constraint(equalToConstant: 300),
            recordButton.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        // Set the cornerRadius to make the button circular
        recordButton.layer.cornerRadius = 150 // Assuming the button's width and height are 200
        //        recordButton.adjustsImageWhenHighlighted = false
        
    }
    
    private func startRotatingView(view: UIView, speedDuration: Double = 1.0, completion: (() -> Void)? = nil) {
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = speedDuration
        rotationAnimation.repeatCount = Float(8 / speedDuration)
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.fillMode = .forwards
        rotationAnimation.delegate = self
        view.layer.add(rotationAnimation, forKey: "rotationAnimation")
        
        self.animateRecordArmToTouchRecord()
        Timer.scheduledTimer(withTimeInterval: 8, repeats: false) { _ in
            completion?()
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            // Call the completion handler if the animation finished
            rotationCompletion?()
            self.armAnimationCompletion?()
            rotationCompletion = nil
        }
    }
    

    @objc func handleTapGesture() {
        if  recordButton.isEnabled  {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.prepare()
            generator.impactOccurred()
            ringBack?(recordButton)
            recordButton.isEnabled = false
            recordButton.setBackgroundImage(UIImage(named: "vinyle"), for: .normal) // For keep the same fade of color
            startRotatingView(view: recordButton, speedDuration: 3) {
                self.recordButton.isEnabled = true
                
            }
        }
    }
}
