import UIKit

class ButtonReccordView: UIButton, CAAnimationDelegate {
    
    private var stopButton : UIButton!
    private var recordButton: UIButton!
    private var playButton = UIButton(type: .custom)
    private var pulseAnimation: PulseAnimation!
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
        recordArm = UIImageView(image: UIImage(named: "bras")) // Remplacez "recordArm" par le nom de votre image de bras de lecture
        recordArm.contentMode = .scaleAspectFill
        recordArm.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(recordArm)
        recordArmBottomConstraint = recordArm.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: 60) // La constante initiale
        // Par exemple, si le pivot est en bas à gauche du bras de lecture :
        NSLayoutConstraint.activate([
            recordArm.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -129), // Ajuster en fonction de votre layout
            recordArm.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: 60),
            recordArm.widthAnchor.constraint(equalToConstant: 80), // La largeur de votre bras de lecture
            recordArm.heightAnchor.constraint(equalToConstant: 180) // La hauteur de votre bras de lecture
        ])
    }
    
    private func animateRecordArmToTouchRecord() {
        
        let rotationAngle = 80 * (CGFloat.pi / 180)
        UIView.animate(withDuration: 9.90, delay: 0,options: .curveEaseOut,
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
        recordButton.setBackgroundImage(UIImage(named: "vinyle"), for: .normal)  // Set it to clear if you want the transparent parts to show
        recordButton.imageView?.contentMode = .scaleAspectFill // Set contentMode for the imageView of the button
        recordButton.backgroundColor = .clear
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
    }
    
    private func startRotatingView(view: UIView, duration: Double = 1.0, completion: (() -> Void)? = nil) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = duration
        rotationAnimation.repeatCount = Float(10 / duration)
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.fillMode = .forwards
        rotationAnimation.delegate = self
        view.layer.add(rotationAnimation, forKey: "rotationAnimation")
        
        self.animateRecordArmToTouchRecord()

        Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
                completion?()
            self.armAnimationCompletion?()
            let animationFinish = true
            }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            // Call the completion handler if the animation finished
            rotationCompletion?()
            rotationCompletion = nil
        }
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
        guard recordButton.isEnabled else {
            return
        }
    
        ringBack?(recordButton)
                recordButton.isEnabled = false
        startRotatingView(view: recordButton, duration: 2) {
            self.recordButton.isEnabled = true
          }
    }
     
    }

