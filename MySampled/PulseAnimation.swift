import UIKit

class PulseAnimation: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBrown
        layer.addSublayer(firstPulsingLayer)
                createPulseLayers(count: 4)
        firstPulsingLayer.add(PulsingAnimation(scale: 1.60), forKey: nil)
      //  layer.addSublayer(secondPulsingLayer)
       // layer.addSublayer(thirdPulsingLayer)
        //  secondPulsingLayer.add(PulsingAnimation(scale: 1.90), forKey: nil)
     //   thirdPulsingLayer.add(PulsingAnimation(scale: 2), forKey: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let expandingAnimationScale: CGFloat = 1.89
    func PulsingAnimation(scale: CGFloat) -> CAAnimationGroup {
        let animationGroup = createPulsingAnimationGroup(duration: 1.5, speed: 1.3)
        animationGroup.animations = [createExpandingAnimation(scale: scale),createOpacityAnimation()]
        return animationGroup
    }
 
    private func createPulsingAnimationGroup(duration: TimeInterval, speed: Float) -> CAAnimationGroup {
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = duration
        animationGroup.speed = speed
        animationGroup.repeatCount = .infinity
        return animationGroup
    }
    
    private func createExpandingAnimation(scale: CGFloat) -> CABasicAnimation {
        let expandingAnimation = CABasicAnimation(keyPath: "transform.scale")
        expandingAnimation.fromValue = 1
        expandingAnimation.toValue = scale
        return expandingAnimation
    }
    
    private func createOpacityAnimation() -> CABasicAnimation {
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        //opacityAnimation.duration = 0.5
        opacityAnimation.toValue = 0
        
        return opacityAnimation
    }
    
    private func createPulseLayers(count: Int)  {
        
        var lineWidth = 4
        var scale : CGFloat = 1.85
        var radius : CGFloat =  110
        for pulseCount in 0..<count {
            var circularPulse = PulseAnimation.circularLayer(color: Constant.secondPulsingColor , radius: radius, lineWidth: 3)
                
            circularPulse.fillColor = UIColor.darkGray.cgColor
            radius += 15
            lineWidth -= 1
            
            layer.addSublayer(circularPulse)
            circularPulse.add(PulsingAnimation(scale: scale), forKey: nil)
            
            scale += 0.10
            
        }
        
    }
    
    
    private let firstPulsingLayer: CAShapeLayer = circularLayer(color: Constant.firstPulsingColor, radius: 80, lineWidth: 15)
    private let secondPulsingLayer: CAShapeLayer = circularLayer(color: Constant.secondPulsingColor, radius: 100, lineWidth: 2 )
    private let thirdPulsingLayer: CAShapeLayer = circularLayer(color: Constant.thirdPulsingColor, radius: 110, lineWidth: 1)
    
    private static func circularLayer(color: CGColor, radius: CGFloat, lineWidth: CGFloat) -> CAShapeLayer {
        let circularLayer = CAShapeLayer()
        circularLayer.lineWidth = lineWidth
        circularLayer.strokeColor = color
        circularLayer.fillColor = UIColor.clear.cgColor
        circularLayer.path = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true).cgPath
        return circularLayer
    }
    
    private enum Constant {
        
                
        
        static let firstPulsingColor: CGColor = UIColor(red: 0.12, green: 0.56, blue: 1, alpha: 1).cgColor // Nuance la plus claire de bleu
        static let secondPulsingColor: CGColor = UIColor(red: 0.12, green: 0.36, blue: 0.8, alpha: 1).cgColor // Nuance intermédiaire de bleu
        static let thirdPulsingColor: CGColor = UIColor(red: 0.12, green: 0.16, blue: 0.6, alpha: 1).cgColor // Nuance la plus foncée de bleu
    }


}
