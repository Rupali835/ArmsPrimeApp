//
//  Extensions.swift
//  Producer
//
//  Created by developer2 on 19/08/19.
//  Copyright © 2019 developer2. All rights reserved.
//

import Foundation
import UIKit
//import SkyFloatingLabelTextField

private var kAssociationKeyMaxLength: Int = 0

extension UIAlertController {
    
}

extension UILabel {
    
    open override func awakeFromNib() {
        
        if self.tag == -100 {
            
            self.backgroundColor = appearences.placeholderColor
        }
    }
}

extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        
        selectedTextRange = selection
    }
    
    open override func awakeFromNib() {
        
        self.keyboardAppearance = .light
        self.tintColor = .black
    }
}

extension UITextView {
    
    
    open override func awakeFromNib() {
        
        self.keyboardAppearance = .light
        self.tintColor = .black
    }
    
    @IBInspectable var makeCirculer: Bool {
        get { return false }
        
        set {
            if newValue == true {
                layer.cornerRadius = frame.width / 2.0
                layer.masksToBounds = true
            }
        }
    }
    
}

extension UIViewController {
    
    open override func awakeFromNib() {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
    
    func showError(msg: String) {
        
        utility.alert(title: stringConstants.appName, message: msg, delegate: self, buttons: nil, cancel: stringConstants.ok, completion: nil)
    }
    
    /// Show ImagePickerController.
    /// In order to use this method, conform the ViewController to UIImagePickerControllerDelegate, UINavigationControllerDelegate Protocols.
    func showImagePicker() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let imagePicker = UIImagePickerController()
        if let imagePickerDelegate = self as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
            imagePicker.delegate = imagePickerDelegate
        }
        //imagePicker.delegate = self
        imagePicker.allowsEditing = false
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { [unowned self] (action) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [unowned self] (action) in
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(galleryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func addBackButton() {
        
        self.navigationItem.hidesBackButton = true
        
        let backButton = UIBarButtonItem(image: UIImage.init(named: "backArrow"), style: UIBarButtonItem.Style.done, target: self, action: #selector(didTapBack))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func didTapBack() {
        
        if self.responds(to: Selector("btnBackClicked")) {
            
           perform(Selector("btnBackClicked"))
        }
        else {
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    func setStatusBarStyle(isBlack: Bool) {
        
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = isBlack ? .darkContent : .lightContent
        } else {
            UIApplication.shared.statusBarStyle = isBlack ? .default : .lightContent
        }
    }
}

/*
extension SkyFloatingLabelTextField {
    func setupCustomTextField(placeholder: String) {
        let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : appearences.placeholdeColor])
        titleFormatter = { return $0 }
        self.attributedPlaceholder = attributedPlaceholder
        textColor = UIColor.white
        titleColor = appearences.placeholdeColor
        lineColor = UIColor.lightGray
        lineHeight = 0.5
        selectedLineColor = UIColor.lightGray
        selectedTitleColor = appearences.placeholdeColor
    }
}
 */

extension UITextField {
   
    var rightImage: (image:UIImage?, height: CGFloat, width: CGFloat)? {
       
        get {
            return nil
        }
        set {
            // Add ImageView at the center of View
            if newValue == nil {
                rightView = nil
                return
            }
            
            let viewHeight: CGFloat = self.frame.size.height
            
            let rightViewFrame = CGRect(x: 0.0, y: 0.0, width: viewHeight, height: viewHeight)
            let view = UIView(frame: rightViewFrame)
            view.clipsToBounds = true

            let imageViewFrame = CGRect(x: 0, y: 0, width: newValue!.width, height: newValue!.height)
            let rightImageView = UIImageView(frame: imageViewFrame)
            rightImageView.contentMode = .scaleAspectFit
            rightImageView.image = newValue?.image
            view.addSubview(rightImageView)
            rightImageView.center = view.center
            
            // Set RightView of the TextField
            rightView = view
            //}
            rightViewMode = .always
        }
    }
}

extension UIView {
    
    func makeCircular() {
        layer.cornerRadius = frame.width / 2.0
        layer.masksToBounds = true
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat, color: UIColor? = nil) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        if color != nil {
            let borderLayer = CAShapeLayer()
            borderLayer.path = mask.path // Reuse the Bezier path
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.strokeColor = color?.cgColor
            borderLayer.lineWidth = 2
            borderLayer.frame = self.bounds
            self.layer.insertSublayer(borderLayer, at: 0)
        }
    }
    
    func constrainCentered(_ subview: UIView) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalContraint = NSLayoutConstraint(
            item: subview,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0)
        
        let horizontalContraint = NSLayoutConstraint(
            item: subview,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0)
        
        let heightContraint = NSLayoutConstraint(
            item: subview,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: subview.frame.height)
        
        let widthContraint = NSLayoutConstraint(
            item: subview,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: subview.frame.width)
        
        addConstraints([
            horizontalContraint,
            verticalContraint,
            heightContraint,
            widthContraint])
        
    }
    
    func constrainToEdges(_ subview: UIView) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let topContraint = NSLayoutConstraint(
            item: subview,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1.0,
            constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(
            item: subview,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0)
        
        let leadingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0)
        
        let trailingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 0)
        
        addConstraints([
            topContraint,
            bottomConstraint,
            leadingContraint,
            trailingContraint])
    }
    
    func disableUserInteraction(duration: Double) {
        
        self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            
            self.isUserInteractionEnabled = true
        }
    }
    
    func addDashedBorder(color: UIColor) {
        
        let border = CAShapeLayer()
        border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius:self.layer.cornerRadius).cgPath
        border.frame = self.bounds
        border.strokeColor = color.cgColor
        border.fillColor = nil
        border.lineDashPattern = [4, 4]
        self.layer.addSublayer(border)
    }
}

// Extensions for Date. Date formats in cases: Date to String - String to Date - String to String.
extension String {
    
    func toDate(from format: DateFormat) -> Date? {
        
        let str = self.replacingOccurrences(of: "st", with: "").replacingOccurrences(of: "rd", with: "").replacingOccurrences(of: "th", with: "").replacingOccurrences(of: "nd", with: "")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        
        return dateFormatter.date(from: str)
    }
    
    
    func toDateString(fromFormat: DateFormat, toFormat: DateFormat) -> String? {
        return toDate(from: fromFormat)?.toString(to: toFormat)
    }
    
    var isEmpty: Bool {
        
        return trimmingCharacters(in: CharacterSet.whitespaces).count > 0 ? false : true
    }
    
    var isNotEmpty: Bool {
        return !self.trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func underlinedAtrributed(font: UIFont, color: UIColor = UIColor.white) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: color])
    }
}

extension Date {
    
    func toString(to format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        
        return dateFormatter.string(from: self)
    }
    
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    static var yesterday: Date? { return Date().dayBefore }
    static var tomorrow:  Date? { return Date().dayAfter }
    var dayBefore: Date? {
        guard let noonTime = noon else { return nil }
        return Calendar.current.date(byAdding: .day, value: -1, to: noonTime)
    }
    var dayAfter: Date? {
        guard let noonTime = noon else { return nil }
        return Calendar.current.date(byAdding: .day, value: 1, to: noonTime)
    }
    var noon: Date? {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter?.month != month
    }
    
    func timestampString() -> String {
        
        return String(Int64(self.timeIntervalSince1970 * 1000))
    }
    
    func dateByAdding(day: Int) -> Date? {
        
        let calendar = Calendar.current
        
        var component = DateComponents()
        component.day = day
        
        guard let date = calendar.date(byAdding: component, to: self) else {
            
            return nil
        }
        
        return date
    }
}

// Enum for Date Formats. It should be valid date format string.
enum DateFormat: String {
    
    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    case yyyyMMdd = "yyyy-MM-dd"
    case MMMdyyyyHHmmss = "MMM d, yyyy HH:mm:ss"
    case ddMMMyyyy = "dd MMM yyyy"
    case ddMMMMyyyy = "dd MMMM yyyy"
    case dd = "dd"
    case MMMM = "MMMM"
    case mmm = "mmm"
    case yyyy = "yyyy"
    case ddMMMYYYYhhmm = "dd MMM yyyy | hh:mma"
    
    case dMMMYYYYhhmma = "dd MMM yyyy, hh:mm a"
    case ddMMM = "dd MMM"
    case hhmma = "hh:mm a"
    case ddMMMyyyyhhmmWithComma = "d MMM yyyy, hh:mm a"
    

}

extension UISearchBar {
    
    private var textField: UITextField? {
        return subviews.first?.subviews.compactMap { $0 as? UITextField }.first
    }
    
    private var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
    }
    
    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            if newValue {
                if activityIndicator == nil {
                    let newActivityIndicator = UIActivityIndicatorView(style: .white)
                    newActivityIndicator.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    newActivityIndicator.startAnimating()
                    newActivityIndicator.backgroundColor = UIColor.clear
                    textField?.leftView?.addSubview(newActivityIndicator)
                    let leftViewSize = textField?.leftView?.frame.size ?? CGSize.zero
                    newActivityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                }
            } else {
                activityIndicator?.removeFromSuperview()
            }
        }
    }
}

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(withCell: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: T.identifier) as? T
    }
    
    func registerNib<T: UITableViewCell>(withCell: T.Type) {
        register(UINib(nibName: T.identifier, bundle: nil), forCellReuseIdentifier: T.identifier)
    }
    
    func setPlaceholder(title:String, detail: String, titleColor:UIColor = UIColor.white, detailColor: UIColor = UIColor.darkGray) {
     
        let arrNib = Bundle.main.loadNibNamed("PHTablePlaceholder", owner: nil, options: nil)
        
        guard let placeholderView = arrNib?.first as? PHTablePlaceholder else {
            
            return
        }
        
        placeholderView.frame = self.bounds
        placeholderView.setDetails(title: title, detail: detail)
        placeholderView.lblTitle.textColor = titleColor
        placeholderView.lblDetail.textColor = detailColor
        
        self.backgroundView = placeholderView
    }
    
    func loaderAtFooter(show: Bool) {
        if show {
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: 30.0))
            activityIndicator.color = UIColor.gray
            activityIndicator.startAnimating()
            tableFooterView = activityIndicator
            tableFooterView?.isHidden = false
        } else {
            if let footer = tableFooterView {
                footer.removeFromSuperview()
            }
            tableFooterView = nil
            tableFooterView?.isHidden = true
        }
    }
    
    func showNoDataView(title: String = "No data found", color: UIColor = #colorLiteral(red: 0.6901960784, green: 0.09019607843, blue: 0.1607843137, alpha: 1)) {
        let label = UILabel()
        label.frame = CGRect(x: 0.0, y: center.y, width: frame.width, height: 40.0)
        label.text = title
        label.font = ShoutoutFont.bold.withSize(size: .large)
        label.textColor = color
        label.numberOfLines = 0
        label.textAlignment = .center
        backgroundView = label
    }
    
    func hideNoDataView() {
        backgroundView = nil
    }
}

extension UICollectionReusableView {
    
    static var identifierVar: String {
        return String(describing: self)
    }
}

extension UICollectionView {
    
    func dequeueReusableCell<T: UICollectionViewCell>(withCell: T.Type, indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T
    }
    
    func registerNib<T: UICollectionViewCell>(withCell: T.Type) {
        register(UINib(nibName: T.identifier, bundle: nil), forCellWithReuseIdentifier: T.identifier)
    }
    
    func registerHeader<T: UICollectionReusableView>(withHeader: T.Type) {
        register(UINib(nibName: T.identifierVar, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.identifierVar)
    }
    
    func setPlaceholder(title:String, detail: String) {
     
        let arrNib = Bundle.main.loadNibNamed("PHTablePlaceholder", owner: nil, options: nil)
        
        guard let placeholderView = arrNib?.first as? PHTablePlaceholder else {
            
            return
        }
        
        placeholderView.frame = self.bounds
        placeholderView.setDetails(title: title, detail: detail)
        self.backgroundView = placeholderView
    }
        
    func showNoDataView(title: String = "No data found", color: UIColor = #colorLiteral(red: 0.6901960784, green: 0.09019607843, blue: 0.1607843137, alpha: 1)) {
        let label = UILabel()
        label.frame = CGRect(x: 0.0, y: center.y, width: frame.width, height: 40.0)
        label.text = title
        label.font = ShoutoutFont.bold.withSize(size: .large)
        label.textColor = color
        label.numberOfLines = 0
        label.textAlignment = .center
        backgroundView = label
    }
    
    func hideNoDataView() {
        backgroundView = nil
    }
}

extension UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell {
    
    var tableView: UITableView? {
        var view = superview
        while let v = view, v.isKind(of: UITableView.self) == false {
            view = v.superview
        }
        return view as? UITableView
    }
    
    open override func awakeFromNib() {
        
        self.selectionStyle = .none
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIImage {
    
    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Returns a resized image that fits in rectSize, keeping it's aspect ratio
    /// Note that the new image size is not rectSize, but within it.
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height
        
        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }
        
        let newSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
        let resized = resizedImage(newSize: newSize)
        return resized
    }
    
    func imageWithSize(_ size:CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        
        let aspectWidth:CGFloat = size.width / self.size.width
        let aspectHeight:CGFloat = size.height / self.size.height
        let aspectRatio:CGFloat = min(aspectWidth, aspectHeight)
        
        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        self.draw(in: scaledImageRect)
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    func fixOrientation() -> UIImage {
        
        if imageOrientation == UIImage.Orientation.up {
            return self
        }
        
        var transform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -(.pi / 2))
            
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }
        
        switch imageOrientation {
            
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1);
            
        default:
            break
        }
        
        guard let cgImageData = cgImage, let colorSpaceData = cgImageData.colorSpace else {
            print("Error: Failed fixing orientation of the image.")
            return self
        }
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        guard let ctx = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: cgImageData.bitsPerComponent,
            bytesPerRow: 0,
            space: colorSpaceData,
            bitmapInfo: UInt32(cgImageData.bitmapInfo.rawValue)
            ) else {
                print("Error: Failed fixing orientation of the image.")
                return self
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
            
        case .left, .leftMirrored, .right, .rightMirrored:
            // Grr...
            ctx.draw(cgImageData, in: CGRect(x:0, y: 0 ,width: size.height, height: size.width))
            
        default:
            ctx.draw(cgImageData, in: CGRect(x:0, y: 0, width: size.width, height: size.height))
        }
        
        // And now we just create a new UIImage from the drawing context
        guard let cgimg = ctx.makeImage() else {
            print("Error: Failed fixing orientation of the image.")
            return self
        }
        
        let img = UIImage(cgImage: cgimg)
        return img
    }
    
    func toBase64() -> String? {
        
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}

extension UILabel {
    @IBInspectable var adjustFontSizeToFitWidth: Bool {
        get { return adjustsFontSizeToFitWidth }
        
        set {
            adjustsFontSizeToFitWidth = adjustFontSizeToFitWidth
        }
    }
}

extension UIButton {

    override open var intrinsicContentSize: CGSize {

        let intrinsicContentSize = super.intrinsicContentSize

        let adjustedWidth = intrinsicContentSize.width + titleEdgeInsets.left + titleEdgeInsets.right
        let adjustedHeight = intrinsicContentSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom

        return CGSize(width: adjustedWidth, height: adjustedHeight)
    }
}

extension UILabel {
    
    public var requiredHeight: CGFloat {
      let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
      label.numberOfLines = 0
      label.lineBreakMode = NSLineBreakMode.byWordWrapping
      label.font = font
      label.text = text
      label.attributedText = attributedText
      label.sizeToFit()
      return label.frame.height
    }
}

@IBDesignable class DottedVertical: UIView {

    @IBInspectable var dotColor: UIColor = UIColor.red
    @IBInspectable var lowerHalfOnly: Bool = false

    override func draw(_ rect: CGRect) {

        // say you want 8 dots, with perfect fenceposting:
        let fullHeight: CGFloat = bounds.size.height
        let totalCount = fullHeight / 18
        let width = bounds.size.width
        let itemLength: CGFloat = 2
        
        let path = UIBezierPath()
        
        let beginFromTop = CGFloat(0.0)
        let top = CGPoint(x: width/2, y: beginFromTop)
        let bottom = CGPoint(x: width/2, y: fullHeight)
        
        path.move(to: top)
        path.addLine(to: bottom)

        path.lineWidth = width

        let dashes: [CGFloat] = [itemLength, itemLength]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        
        path.lineCapStyle = CGLineCap.round

        dotColor.setStroke()
        path.stroke()
    }
}

extension Data {
    
    mutating func append(_ string: String) {
        
        if let data = string.data(using: .utf8) {
            
            append(data)
        }
    }
}

