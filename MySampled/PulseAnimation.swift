import UIKit

class PulseAnimation: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.addSublayer(firstPulsingLayer)
                createPulseLayers(count: 4)
        firstPulsingLayer.add(PulsingAnimation(scale: 1.10), forKey: nil)
        
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
                
          //  circularPulse.fillColor = UIColor.lightGray.cgColor
            radius += 15
            lineWidth -= 1
            
            layer.addSublayer(circularPulse)
            circularPulse.add(PulsingAnimation(scale: scale), forKey: nil)
            
            scale += 0.10
            
        }
        
    }
      
    private let firstPulsingLayer: CAShapeLayer = circularLayer(color: Constant.firstPulsingColor, radius: 80, lineWidth: 4)
    private let secondPulsingLayer: CAShapeLayer = circularLayer(color: Constant.secondPulsingColor, radius: 100, lineWidth: 2 )
    private let thirdPulsingLayer: CAShapeLayer = circularLayer(color: Constant.thirdPulsingColor, radius: 110, lineWidth: 1)
    
    private static func circularLayer(color: CGColor, radius: CGFloat, lineWidth: CGFloat) -> CAShapeLayer {
        let circularLayer = CAShapeLayer()
        circularLayer.lineWidth = lineWidth
        circularLayer.strokeColor = color
        circularLayer.fillColor = UIColor.white.cgColor
        circularLayer.path = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true).cgPath
        return circularLayer
    }
    
    private enum Constant {
        static let firstPulsingColor: CGColor = UIColor(red: 0.7, green: 0.4, blue: 0.7, alpha: 1.0).cgColor
        static let secondPulsingColor: CGColor = UIColor(red: 0.6, green: 0.3, blue: 0.6, alpha: 1.0).cgColor
        static let thirdPulsingColor: CGColor = UIColor(red: 0.5, green: 0.2, blue: 0.5, alpha: 1.0).cgColor
    }
}
 
