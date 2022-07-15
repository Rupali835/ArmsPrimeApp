

import UIKit

let pi = 3.14159265359
let dotEnteringDelay = 0.6

class SHActivityView: UIView {
    
    
    enum SpinnerSize : Int
    {
        case kSHSpinnerSizeLarge // suitable for frame size (185, 185)
    }
    
    var spinnerSize : SpinnerSize?
    
    
    var spinnerColor : UIColor?
    
    var disableEntireUserInteraction : Bool?
        {
        
        didSet
        {
            if (disableEntireUserInteraction == true)
            {
                UIApplication.shared.beginIgnoringInteractionEvents()
            }
        }
    }
    
    var stopShowingAndDismissingAnimation : Bool?
    
    
    
    
    private var viewActivitySquare : UIView?
    private var viewNotRotate : UIView?
    private var isAnimating : Bool?
    
    //MARK:-
    private func DEGREES_TO_RADIANS(degrees : Double) -> CGFloat
    {
        return CGFloat(((pi*degrees) / 180))
    }
    
    func showAndStartAnimate()
    {
        if (isAnimating == true)
        {
            print("WARNING already animation started")
            return;
        }
        else
        {
            isAnimating = true
        }
        self.alpha = 0.0;
        
        // if (disableEntireUserInteraction == true)
        // {
        UIApplication.shared.beginIgnoringInteractionEvents()
        // }
        viewNotRotate = self
        viewActivitySquare = UIView.init()
        var frameViewActivitySquare : CGRect?
        
        frameViewActivitySquare = CGRect(x:0, y:0, width:50,height: 50)
        self.frame = frameViewActivitySquare!
        
        var imageCenter : UIImageView?
        
        
        frameViewActivitySquare = CGRect(x:0, y:0, width:110, height:110)
        viewNotRotate?.frame = CGRect(x:0, y:0, width:100, height:100)
        
        imageCenter = UIImageView(frame:CGRect(x:0,y:0,width:70,height:70))
        
        let images : UIImage = UIImage(named:"share.png")!
        imageCenter = UIImageView(image: images)
        imageCenter?.contentMode =  UIView.ContentMode.scaleToFill
        viewNotRotate?.addSubview(imageCenter!)
        
        viewActivitySquare?.frame = frameViewActivitySquare!
        self.addSubview(viewActivitySquare!)
        
        let lowerPath = UIBezierPath(arcCenter: (viewActivitySquare?.center)!, radius: (viewActivitySquare?.frame.size.width)!/2.2, startAngle: DEGREES_TO_RADIANS(degrees: -5), endAngle: DEGREES_TO_RADIANS(degrees: 200), clockwise: true)
        let lowerShape = self.createShapeLayer(path: lowerPath)
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = CGRect(x:0, y:0, width:(viewActivitySquare?.frame.size.width)!,height: (viewActivitySquare?.frame.size.height)!)
        var colorSpinner = spinnerColor
        
        if (colorSpinner == nil)
        {
            colorSpinner = colorWithHexString(hex: "#2b2a2a")
        }
        gradientLayer.colors = NSArray(objects: (colorSpinner?.cgColor)!,colorWithHexString(hex: "#2b2a2a").withAlphaComponent(0.0).cgColor,colorWithHexString(hex: "#2b2a2a").withAlphaComponent(0.0).cgColor,UIColor.clear.cgColor) as! [CGColor]
        gradientLayer.startPoint = CGPoint(x:0.5, y:0.8)
        gradientLayer.endPoint = CGPoint(x:2.0, y:0.5)
        gradientLayer.mask = lowerShape
        viewActivitySquare?.layer.addSublayer(gradientLayer)
        
        let upperPath = UIBezierPath(arcCenter: (viewActivitySquare?.center)!, radius: (viewActivitySquare?.frame.size.width)!/2.2, startAngle: DEGREES_TO_RADIANS(degrees: 200), endAngle: DEGREES_TO_RADIANS(degrees: 300), clockwise: true)
        let upperShape = self.createShapeLayer(path: upperPath)
        if (spinnerColor != nil)
        {
            upperShape.strokeColor = spinnerColor?.cgColor
        }
        else
        {
            upperShape.strokeColor = colorWithHexString(hex: "#2b2a2a").cgColor
        }
        viewActivitySquare?.layer.addSublayer(upperShape)
        NotificationCenter.default.addObserver(self, selector:  #selector(SHActivityView.rotationAnimation),  name: UIApplication.willEnterForegroundNotification, object: nil)
      
        self.rotationAnimation()
        viewActivitySquare?.center = CGPoint(x:(viewNotRotate?.frame.size.width)!/2, y:(viewNotRotate?.frame.size.height)!/2)
        
        UIView.animate(withDuration: (stopShowingAndDismissingAnimation == true) ? 0.0 : 0.5) { () -> Void in
            self.alpha = 1.0
        }
        
    }
    
    private func createShapeLayer(path : UIBezierPath) -> CAShapeLayer
    {
        let shape = CAShapeLayer.init()
        shape.path = path.cgPath
        
        shape.lineWidth = 10.0
        
        shape.lineCap = CAShapeLayerLineCap.round
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor(white: 1.0, alpha: 1.0).cgColor
        return shape
    }
    
    
    @objc private func rotationAnimation()
    {
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fromValue = NSNumber(value: 0.0)
        rotate.toValue = NSNumber(value: 6.2)
        rotate.repeatCount = Float(CGFloat.greatestFiniteMagnitude)
        rotate.duration = 1.5
        viewActivitySquare?.layer .add(rotate, forKey: "rotateRepeatedly")
        
    }
    
    func dismissAndStopAnimation()
    {
        UIView.animate(withDuration: (stopShowingAndDismissingAnimation == true) ? 0.0 : 0.5, animations: { () -> Void in
            self.alpha = 0.0
        }) { (finished) -> Void in
            if (finished == true)
            {
                self.isAnimating = false
                for view : UIView in self.subviews
                {
                    view.removeFromSuperview()
                }
                
                //  if (self.disableEntireUserInteraction == true)
                //  {
                UIApplication.shared.endIgnoringInteractionEvents()
                //  }
                NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
             
            }
        }
    }
    
    // Creates a UIColor from a Hex string.
    func colorWithHexString (hex:String) -> UIColor {
        var cString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
}
