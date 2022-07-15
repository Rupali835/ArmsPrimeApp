import Foundation

extension Array {
  func shuffled() -> [Element] {
    if count < 2 { return self }
    var list = self
    for i in 0..<(list.count - 1) {
      let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
      if i != j {
        #if swift(>=3.2)
          list.swapAt(i, j)
        #else
          swap(&list[i], &list[j])
        #endif
      }
    }
    return list
  }

  /// Creates an array containing all combinations of two arrays.
  static func createAllCombinations<T, U>(
    from lhs: Array<T>,
    and rhs: Array<U>
  ) -> Array<(T, U)> {
    let result: [(T, U)] = lhs.reduce([]) { (accum, t) in
      let innerResult: [(T, U)] = rhs.reduce([]) { (innerAccum, u) in
        return innerAccum + [(t, u)]
      }
      return accum + innerResult
    }
    return result
  }
}


extension UIView {
    
    open override func awakeFromNib() {
        
        if self.tag == 999 {
            
            self.backgroundColor = appearences.yellowColor
        }
    }
    
//    var corner: CGFloat {
//
//        get { return 0 }
//
//        set {
//            layer.cornerRadius = newValue
//            layer.masksToBounds = true
//        }
//    }
//
    
    
    var verticalDashedLine: Bool {
        get { return false }
        
        set {
            if newValue {
                let topPoint = CGPoint(x: frame.width / 2.0, y: 0.0)
                let bottomPoint = CGPoint(x: frame.width / 2.0, y: frame.height)
                createDashedLine(from: topPoint, to: bottomPoint, color: .black, strokeLength: 2, gapLength: 2, width: 0.5)
            }
        }
    }
    
    
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    
    
    
    
    func setPlaceholderDetails(title:String, detail: String, titleColor:UIColor = UIColor.black, detailColor: UIColor = UIColor.darkGray, titleFont:UIFont? = nil, detailFont: UIFont? = nil) {
        
        removePlaceholder()
        
        let arrNib = Bundle.main.loadNibNamed("PHTablePlaceholder", owner: nil, options: nil)
        
        guard let placeholderView = arrNib?.first as? PHTablePlaceholder else {
            
            return
        }
        
        placeholderView.frame = self.bounds
        placeholderView.setDetails(title: title, detail: detail)
        placeholderView.lblTitle.textColor = titleColor
        placeholderView.lblDetail.textColor = detailColor
        
        if let titleFontNew = titleFont {
            
            placeholderView.lblTitle.font = titleFontNew
        }
        
        if let detailsFontNew = detailFont {
            
            placeholderView.lblDetail.font = detailsFontNew
        }
    
        placeholderView.tag = -100
        self.addSubview(placeholderView)
    }
    
    func removePlaceholder() {
        
        if let view = self.viewWithTag(-100) {
            
            view.removeFromSuperview()
        }
    }
    
    private func createDashedLine(from point1: CGPoint, to point2: CGPoint, color: UIColor, strokeLength: NSNumber, gapLength: NSNumber, width: CGFloat) {
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = [strokeLength, gapLength]
        
        let path = CGMutablePath()
        path.addLines(between: [point1, point2])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
        layer.masksToBounds = true
    }
    
}

extension UIView {
    
    @IBInspectable var isTextColorYellow: Bool {
        get { return false }
        
        set {
            
            if let lbl = self as? UILabel, newValue == true {
                
                lbl.textColor = appearences.yellowColor
            }
            
            if let txt = self as? UITextField, newValue == true {
                
                txt.textColor = appearences.yellowColor
            }
        }
    }
    
    @IBInspectable var isBackgroundYellow: Bool {
        get { return false }
        
        set {
            
            if let lbl = self as? UILabel, newValue == true {
                
                lbl.backgroundColor = appearences.yellowColor
            }
            
            if let txt = self as? UITextField, newValue == true {
                
                txt.backgroundColor = appearences.yellowColor
            }
        }
    }
    
    @IBInspectable var isImgTintColorYellow: Bool {
        get { return false }
        
        set {
            
            if let imgView = self as? UIImageView, imgView.image != nil, newValue == true {
                
                imgView.image = imgView.image?.withRenderingMode(.alwaysTemplate)
                imgView.tintColor = appearences.yellowColor
            }
            
            if let btn = self as? UIButton, newValue == true {
                
                btn.tintColor = appearences.yellowColor
            }
        }
    }
    
    @IBInspectable var imgTintColor: UIColor? {
        get { return nil }
        
        set {
            
            if let imgView = self as? UIImageView, imgView.image != nil, newValue != nil {
                
                imgView.image = imgView.image?.withRenderingMode(.alwaysTemplate)
                imgView.tintColor = newValue
                
                var image = imgView.image?.withRenderingMode(.alwaysTemplate)
                UIGraphicsBeginImageContextWithOptions(imgView.image!.size, false, 1)
                newValue!.set()
                imgView.image?.draw(in: CGRect(x: 0, y: 0, width: imgView.image!.size.width, height: imgView.image!.size.height))
                image = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                
                imgView.image = image
            }
            
            if let btn = self as? UIButton, newValue != nil {
                
                btn.tintColor = imgTintColor
            }
        }
    }
}
