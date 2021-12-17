//
//  Extensions.swift
//  Tempo
//
//  Created by Vishal Raj on 15/09/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit


extension UITextField {
    func setIcon(_ image: UIImage, position: TextFieldItemPosition, tintColor:UIColor? = nil) {
        let iconView = UIImageView(frame:
            CGRect(x: 10, y: 10, width: 25, height: 25))
        iconView.image = image
        iconView.tintColor = tintColor
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 10, y: 0, width: 45, height: 45))
        iconContainerView.addSubview(iconView)
        if position == .Left {
            leftView = iconContainerView
            leftViewMode = .always
        } else {
            rightView = iconContainerView
            rightViewMode = .always
        }
    }
    func setIcon(_ image: UIImage, frame:CGRect = CGRect(x: 10, y: 10, width: 25, height: 25), position: TextFieldItemPosition, tintColor:UIColor? = nil) {
        let iconView = UIImageView(frame: frame)
        iconView.image = image
        iconView.tintColor = tintColor
//        let iconContainerView: UIView = UIView(frame:
//            CGRect(x: 10, y: 0, width: 45, height: 45))
//        iconContainerView.addSubview(iconView)
        if position == .Left {
            leftView = iconView
            leftViewMode = .always
        } else {
            rightView = iconView
            rightViewMode = .always
        }
    }
    func setDefault(string text:String, withFont font:UIFont = UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 20.0)!, withColor color:UIColor = UIColor.white, at position: TextFieldItemPosition) {
        let calculatedSize = (text as NSString).size(withAttributes: [.font: font])
        let label = UILabel(frame: CGRect(x: 0, y: 10, width: calculatedSize.width, height: calculatedSize.height))
        label.text = text
        label.font = font
        label.textColor = color
        let containerView: UIView = UIView(frame:
            CGRect(x: 0, y: 0, width: calculatedSize.width + 5, height: calculatedSize.height + 20))
        containerView.addSubview(label)
        if position == .Left {
            leftView = containerView
            leftViewMode = .always
        } else {
            rightView = containerView
            rightViewMode = .always
        }
    }
}


extension UIApplication {
    static func currentViewController() -> UIViewController? {
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.topViewController
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        return rootViewController
    }
}

extension UIColor {
    static var menuBackgroundColor = UIColor.rgb(r: 30, g: 28, b: 46)
    
    static var randomColor: UIColor {
        return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
    static func rgb(r: CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension UITextField {
    func blendBottomLine(color:CGColor = UIColor.white.cgColor, spaceX:CGFloat = 0, spaceY:CGFloat = 0, lineWidthFactor:CGFloat = 1, lineHeight:CGFloat = 0.5) {
        self.layoutIfNeeded()
        let bottomLine = CALayer()
        let frame = CGRect(x: spaceX, y: self.frame.height + spaceY, width: self.frame.width / lineWidthFactor, height: lineHeight)
        bottomLine.frame = frame
        bottomLine.backgroundColor = color
        self.layer.addSublayer(bottomLine)
        self.layoutIfNeeded()
    }
}


extension UISearchBar {
    public func setSerchTextcolor(color: UIColor) {
        let clrChange = subviews.flatMap { $0.subviews }
        guard let sc = (clrChange.filter { $0 is UITextField }).first as? UITextField else { return }
        sc.textColor = color
    }
}

extension NSLayoutConstraint {
    func withPriority(_ constant:Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(constant)
        return self
    }
    func activate() {
        self.isActive = true
    }
    func deactivate() {
        self.isActive = false
    }
}
extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
    }
    
    
    
    internal func fillSuperview() {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        let constraints:[NSLayoutConstraint] = [
            topAnchor.constraint(equalTo: superview.topAnchor),
            leftAnchor.constraint(equalTo: superview.leftAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            rightAnchor.constraint(equalTo: superview.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    internal func constraint(equalTo size: CGSize) {
        guard superview != nil else { return }
        translatesAutoresizingMaskIntoConstraints = false
        let constraints: [NSLayoutConstraint] = [
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension UIView {
    
    @IBInspectable var vcornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var vborderWidth: CGFloat{
        get{
            return layer.borderWidth
        }
        set{
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var vborderColor: UIColor{
        get{
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }else{
                return UIColor.clear
            }
        }set{
            layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var vshadowColor:UIColor{
        get{
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }else{
                return UIColor.clear
            }
        }set{
            layer.shadowColor = newValue.cgColor
        }
    }
    @IBInspectable var vshadowRadius: CGFloat {
        get{
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var vshadowOffset: CGSize{
        get{
            return layer.shadowOffset
        }set{
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var vshadowOpacity: Float{
        get{
            return layer.shadowOpacity
        }set{
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var vmakeCircle:Bool {
        get{
            return true
        }set{
            if newValue{
                clipsToBounds = true
                layoutIfNeeded()
                layer.cornerRadius = frame.size.width / 2
            }
        }
    }
}
extension Double {
    func getString(withMaximumFractionDigits digits: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.roundingMode = NumberFormatter.RoundingMode.halfUp
        formatter.maximumFractionDigits = digits
        return formatter.string(from: NSNumber(floatLiteral: self))
    }
}
//extension Float {
//    func getString(withMaximumFractionDigits digits: Int) -> String? {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = NumberFormatter.Style.decimal
//        formatter.roundingMode = NumberFormatter.RoundingMode.halfUp
//        formatter.maximumFractionDigits = digits
//        formatter.string(from: NSNumber(floatLiteral: <#T##Double#>))
//        return formatter.string(from: NSNumber(floatLiteral: self))
//    }
//}
extension UISearchBar {
    func getAllSubview<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}


extension UIAlertController {
    static func showModalSpinner(with title:String = "Please wait...", controller:UIViewController) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
//        let alertMessageAttributedString = NSAttributedString(string: title, attributes: [
//            NSAttributedString.Key.font : UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 14)!,
//            NSAttributedString.Key.foregroundColor : UIColor.white
//            ])
//        alert.setValue(alertMessageAttributedString, forKey: "attributedMessage")
        
//    alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.lightGray
//        alert.view.subviews.first?.backgroundColor = UIColor.clear
//        alert.view.subviews.first?.subviews.first?.backgroundColor = .clear
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        controller.present(alert, animated: true, completion: nil)
    }
    static func dismissModalSpinner(animated:Bool = true, controller:UIViewController, completion: (() -> Void)? = nil) {
        controller.dismiss(animated: animated, completion: completion)
    }
    static public func customAlertController(title:String, message:String? = nil) -> UIAlertController {
        
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.alert)
        let alertTitleAttributedString = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font : UIFont(name: CustomFonts.gilroySemiBold.rawValue, size: 16)!,
        ])
        alertVC.setValue(alertTitleAttributedString, forKey: "attributedTitle")
        if let message = message {
            let alertMessageAttributedString = NSAttributedString(string: "\n\(message)", attributes: [
                NSAttributedString.Key.font : UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 13)!,
            ])
            alertVC.setValue(alertMessageAttributedString, forKey: "attributedMessage")
        }
        return alertVC
    }
    static public func showCustomAlert(title:String, message: String, action:UIAlertAction = UIAlertAction(title: "Ok", style: .destructive, handler: nil), controller: UIViewController? = nil, completion: (() -> Void)? = nil) {
        let alert = UIAlertController.customAlertController(title: title, message: message)
        alert.addAction(action)
        if let vc = controller {
            vc.present(alert, animated: true, completion: completion)
        } else {
            var rootViewController = UIApplication.shared.keyWindow?.rootViewController
            if let navigationController = rootViewController as? UINavigationController {
                rootViewController = navigationController.viewControllers.first
            }
            rootViewController?.present(alert, animated: true, completion: completion)
        }
    }
    static public func showModalCustomAlert(title:String, message: String, actions:UIAlertAction..., completion: (() -> Void)? = nil) {
        let alert = UIAlertController.customAlertController(title: title, message: message)
        actions.forEach({ alert.addAction($0) })
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        rootViewController?.present(alert, animated: true, completion: completion)
    }
    static public func presentAlert(_ alert: UIAlertController, on vc: UIViewController? = nil, completion: (() -> Void)? = nil) {
        if let vc = vc {
            print("Here")
            vc.present(alert, animated: true, completion: completion)
        } else {
            print("There")
            var rootViewController = UIApplication.shared.keyWindow?.rootViewController
            if let navigationController = rootViewController as? UINavigationController {
                rootViewController = navigationController.viewControllers.first
            }
            rootViewController?.present(alert, animated: true, completion: completion)
        }
    }
}




extension UIImage {
    
        
    func withInsets(_ insets: UIEdgeInsets) -> UIImage? {
        let cgSize = CGSize(width: self.size.width + insets.left * self.scale + insets.right * self.scale,
                            height: self.size.height + insets.top * self.scale + insets.bottom * self.scale)
        
        UIGraphicsBeginImageContextWithOptions(cgSize, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        
        let origin = CGPoint(x: insets.left * self.scale, y: insets.top * self.scale)
        self.draw(at: origin)
        
        return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(self.renderingMode)
    }

    var scaledToSafeUploadSize: UIImage? {
        let maxImageSideLength: CGFloat = 480
        
        let largerSide: CGFloat = max(size.width, size.height)
        let ratioScale: CGFloat = largerSide > maxImageSideLength ? largerSide / maxImageSideLength : 1
        let newImageSize = CGSize(width: size.width / ratioScale, height: size.height / ratioScale)
        
        return image(scaledTo: newImageSize)
    }
    
    func image(scaledTo size: CGSize) -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        draw(in: CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    static func textImage(image:UIImage, text:String, textColor:UIColor = .white, font:UIFont = UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 10.0)!) -> UIImage {
        let expectedTextSize = (text as NSString).size(withAttributes: [.font: font])
        let width = max(expectedTextSize.width, image.size.width)
        let height = image.size.height + expectedTextSize.height + 5
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
//            context.currentImage.withRenderingMode(.alwaysOriginal)
            let textX: CGFloat = expectedTextSize.width > image.size.width ? 0 : (image.size.width / 2) - (expectedTextSize.width / 2)
            let textY: CGFloat = image.size.height + 5
            
            let textPoint: CGPoint = CGPoint.init(x: textX, y: textY)
            text.draw(at: textPoint, withAttributes: [
                .font: font,
                .foregroundColor: textColor
                ])
            let imageX: CGFloat = expectedTextSize.width > image.size.width ? (expectedTextSize.width / 2) - (image.size.width / 2) : 0
            let rect = CGRect(x: imageX,
                              y: 0,
                              width: image.size.width,
                              height: image.size.height)
            
            image.draw(in: rect)
//            image.withRenderingMode(.alwaysOriginal)
        }
    }
    static func textEmbededImage(image: UIImage,
                            text: String,
                            isImageBeforeText: Bool,
                            segFont: UIFont? = nil) -> UIImage {
        let font = segFont ?? UIFont.systemFont(ofSize: 16)
        let expectedTextSize = (text as NSString).size(withAttributes: [.font: font])
        let width = expectedTextSize.width + image.size.width + 5
        let height = max(expectedTextSize.height, image.size.width)
        let size = CGSize(width: width, height: height)
        
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let fontTopPosition: CGFloat = (height - expectedTextSize.height) / 2
            let textOrigin: CGFloat = isImageBeforeText
                ? image.size.width + 5
                : 0
            let textPoint: CGPoint = CGPoint.init(x: textOrigin, y: fontTopPosition)
            text.draw(at: textPoint, withAttributes: [.font: font])
            let alignment: CGFloat = isImageBeforeText
                ? 0
                : expectedTextSize.width + 5
            let rect = CGRect(x: alignment,
                              y: (height - image.size.height) / 2,
                              width: image.size.width,
                              height: image.size.height)
//            image.withRenderingMode(.alwaysOriginal)
            image.draw(in: rect)
        }
    }
    static public func placeholderInitialsImage(text: String) -> UIImage? {
//        let image:UIImage = #imageLiteral(resourceName: "idle")
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let textColor = UIColor.white
        let textFont = UIFont(name: CustomFonts.gilroyMedium.rawValue, size:18)!
        let initialsLabel = UILabel(frame: frame)
        initialsLabel.font = textFont
        initialsLabel.textColor = textColor
        initialsLabel.numberOfLines = 1
        initialsLabel.textAlignment = .center
        initialsLabel.backgroundColor = .lightGray
        initialsLabel.text = text
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
       
        if let currentContext = UIGraphicsGetCurrentContext() {
            initialsLabel.layer.render(in: currentContext)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
        return nil
    }
    func textToImage(drawText text: String, atPoint point: CGPoint) -> UIImage {
        let image:UIImage = #imageLiteral(resourceName: "help")
        let textColor = UIColor.white
        let textFont = UIFont(name: CustomFonts.gilroyMedium.rawValue, size: 20)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            ] as [NSAttributedString.Key : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCacheWithURLString(_ URLString: String?, placeHolder: UIImage?) {
        
        self.image = nil
        guard let urlString = URLString else {
            print("no url string")
            DispatchQueue.main.async {
                self.image = placeHolder
            }
            return
        }
        
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            self.image = cachedImage
            return
        } else {
            print("No cached image")
        }
        
        if let url = URLSession.shared.constructURL(from: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: urlString))
                            self.image = downloadedImage
                        } else {
                            print("Failed to unwrap downloaded image data")
                            self.image = placeHolder
                        }
                    } else {
                        print("Failed to unwrap image data")
                        self.image = placeHolder
                    }
                    
                }
            }).resume()
        } else {
            print("Failed to unwrap url")
            self.image = placeHolder
        }
    }
}


extension URLSession {
    func constructURL(from string:String, withConcatenatingPath pathToJoin:String? = nil, parameters:[String:String]? = nil) -> URL? {
        var components = URLComponents(string: string)
        if let concatenatingPath = pathToJoin {
            components?.path = "/\(concatenatingPath)"
        }
        if let parameters = parameters {
            components?.setQueryItems(with: parameters)
        }
        
        return components?.url
    }
    
    func constructURL(scheme:String = Config.EndpointConfig.apiURLScheme, host:String = Config.EndpointConfig.apiHost, port:Int? = Config.EndpointConfig.port, path:Config.EndpointConfig.EndpointPath, withConcatenatingPath pathToJoin:String? = nil, parameters:[String:String]? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        if let port = port {
            components.port = port
        }
        
        if let concatenatingPath = pathToJoin {
            components.path = Config.EndpointConfig.getEndpointURLPath(for: path) + "/\(concatenatingPath)"
        } else {
            components.path = Config.EndpointConfig.getEndpointURLPath(for: path)
        }
        if let parameters = parameters {
            components.setQueryItems(with: parameters)
        }
        return components.url
    }
}
extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}


extension Data {
    func stringify() -> String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
}



extension String {
//    func getSlashEncodedURL(from urlString:String) -> String? {
//        
//    }
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    static func emptyIfNil(_ optionalString: String?) -> String {
        let text: String
        if let unwrapped = optionalString {
            text = unwrapped
        } else {
            text = ""
        }
        return text
    }
    func isPhoneNumberLengthValid() -> Bool {
        let regex = "^[0-9]{10}"
        let regexTest = NSPredicate(format: "SELF MATCHES %@", regex)
        return regexTest.evaluate(with: self)
    }
    func isValidEmailAddress() -> Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}"
            + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
            + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
            + "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
            + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
            + "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
            + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}



extension Date {
    static func isDateSame(date1 lhs:Date, date2 rhs:Date) -> Bool {
        let lhsDay = Calendar.current.component(.day, from: lhs)
        let lhsMonth = Calendar.current.component(.month, from: lhs)
        let lhsYear = Calendar.current.component(.year, from: lhs)
        let rhsDay = Calendar.current.component(.day, from: rhs)
        let rhsMonth = Calendar.current.component(.month, from: rhs)
        let rhsYear = Calendar.current.component(.year, from: rhs)
        if (lhsDay == rhsDay && lhsMonth == rhsMonth && lhsYear == rhsYear) {
            return true
        } else {
            return false
        }
    }
    /// Returns a Date with the specified amount of components added to the one it is called with
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }
    
    /// Returns a Date with the specified amount of components subtracted from the one it is called with
    func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        return add(years: -years, months: -months, days: -days, hours: -hours, minutes: -minutes, seconds: -seconds)
    }
    static func getDateFromString(dateString:String?, dateFormat:CustomDateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        if let string = dateString {
            let date:Date? = dateFormatter.date(from: string)
            return date
        }
        return nil
    }
    static func getStringFromDate(date:Date, dateFormat:CustomDateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.rawValue
        let dateString:String = dateFormatter.string(from: date)
        return dateString
    }
    static func getDateFromString(dateString:String?, dateFormat:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        if let string = dateString {
            let date:Date? = dateFormatter.date(from: string)
            return date
        }
        return nil
    }
    static func getStringFromDate(date:Date, dateFormat:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let dateString:String = dateFormatter.string(from: date)
        return dateString
    }
}




extension UIView {

    public enum Corner: Int {
        case TopRight
        case TopLeft
        case BottomRight
        case BottomLeft
        case All
    }

    public func blendCorner(corner: Corner, length: CGFloat = 20.0) {
        let maskLayer = CAShapeLayer()
        var path: CGPath?
        switch corner {
        case .All:
            path = self.makeAnglePathWithRect(rect: self.bounds, topLeftSize: length, topRightSize: length, bottomLeftSize: length, bottomRightSize: length)
        case .TopRight:
            path = self.makeAnglePathWithRect(rect: self.bounds, topLeftSize: 0.0, topRightSize: length, bottomLeftSize: 0.0, bottomRightSize: 0.0)
        case .TopLeft:
            path = self.makeAnglePathWithRect(rect: self.bounds, topLeftSize: length, topRightSize: 0.0, bottomLeftSize: 0.0, bottomRightSize: 0.0)
        case .BottomRight:
            path = self.makeAnglePathWithRect(rect: self.bounds, topLeftSize: 0.0, topRightSize: 0.0, bottomLeftSize: 0.0, bottomRightSize: length)
        case .BottomLeft:
            path = self.makeAnglePathWithRect(rect: self.bounds, topLeftSize: 0.0, topRightSize: 0.0, bottomLeftSize: length, bottomRightSize: 0.0)
        }
        maskLayer.path = path
        self.layer.mask = maskLayer
    }

    private func makeAnglePathWithRect(rect: CGRect, topLeftSize tl: CGFloat, topRightSize tr: CGFloat, bottomLeftSize bl: CGFloat, bottomRightSize br: CGFloat) -> CGPath {
        var points = [CGPoint]()
        points.append(CGPoint(x: rect.origin.x + tl, y: rect.origin.y))
        points.append(CGPoint(x: rect.origin.x + rect.size.width - tr, y: rect.origin.y))
        points.append(CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + tr))
        points.append(CGPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y + rect.size.height - br))
        points.append(CGPoint(x: rect.origin.x + rect.size.width - br, y: rect.origin.y + rect.size.height))
        points.append(CGPoint(x: rect.origin.x + bl, y: rect.origin.y + rect.size.height))
        points.append(CGPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height - bl))
        points.append(CGPoint(x: rect.origin.x, y: rect.origin.y + tl))

        let path = CGMutablePath()
        path.move(to: CGPoint(x: points.first!.x, y: points.first!.y))
//        CGPathMoveToPoint(path, nil, points.first!.x, points.first!.y)
        for point in points {
            if point != points.first {
                path.addLine(to: CGPoint(x: point.x, y: point.y))
//                CGPathAddLineToPoint(path, nil, point.x, point.y)
            }
        }
//        path.addLine(to: CGPoint(x: points.first!.x, y: points.first!.y))
//        CGPathAddLineToPoint(path, nil, points.first!.x, points.first!.y)
        return path
    }

}
