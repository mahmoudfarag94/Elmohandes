import Foundation
import UIKit
extension UIButton{
    
    func plusate()  {
        let x = CASpringAnimation(keyPath: "transform.scale")
        x.duration = 0.4
        x.fromValue = 0.95
        x.toValue = 1.0
        x.autoreverses = true
        x.repeatCount = 2
        x.initialVelocity = 0.5
        x.damping = 1.0
        layer.add(x, forKey: nil)
    }
    func flash()  {
        let y = CABasicAnimation(keyPath: "opacity")
        y.duration = 0.4
        y.fromValue = 1
        y.toValue = 0.1
        y.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        y.autoreverses = true
        y.repeatCount = 2
        layer.add(y, forKey: nil)
    }
    
    
    
    
    
    
    
}
