import UIKit

class ButtonReccordView: UIButton, CAAnimationDelegate {
    private var stopButton: UIButton!
    private var recordButton: UIButton!
    private var playButton = UIButton(type: .custom)
    var ringBack: ((UIButton) -> Void)?
    private var recordArm: UIImageView!
    var testPlayBtn: ((UIButton) -> Void)?
    private var recordArmBottomConstraint: NSLayoutConstraint!
    private var rotationCompletion: (() -> Void)?
    private var armAnimationCompletion: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        //  setUpStopButton()
        circleRecordButton()
        adjustForDeviceSize()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        adjustForDeviceSize()

    }

    private func adjustForDeviceSize() {
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        let buttonSize: CGFloat = isIpad ? 400 : 300
        let cornerRadius: CGFloat = buttonSize / 2

        NSLayoutConstraint.activate([
            recordButton.widthAnchor.constraint(equalToConstant: buttonSize),
            recordButton.heightAnchor.constraint(equalToConstant: buttonSize)
        ])
        recordButton.layer.cornerRadius = cornerRadius
    }

    private func circleRecordButton() {
        recordButton = UIButton(frame: .zero)
        recordButton.center = center
        recordButton.setImage(UIImage(named: "vinyle"), for: .normal)
        recordButton.imageView?.contentMode = .scaleAspectFill // Set contentMode for the imageView of the button
        recordButton.clipsToBounds = true
        recordButton.addTarget(self, action: #selector(handleTapGesture), for: .touchUpInside)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(recordButton)

        NSLayoutConstraint.activate([
            recordButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            recordButton.centerYAnchor.constraint(equalTo: centerYAnchor)
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

        Timer.scheduledTimer(withTimeInterval: 8, repeats: false) { _ in
            completion?()
        }
    }

    func animationDidStop(_: CAAnimation, finished flag: Bool) {
        if flag {
            // Call the completion handler if the animation finished
            rotationCompletion?()
            rotationCompletion = nil
        }
    }

    @objc func handleTapGesture() {
        if recordButton.isEnabled {
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
