//
//  CustomUtils.swift
//  TruckYa
//
//  Created by Digit Bazar on 05/11/19.
//  Copyright © 2019 Saurabh. All rights reserved.
//

import UIKit
final class OverlaySpinner {
    static let shared = OverlaySpinner()
    fileprivate var containerView = UIView()
    fileprivate var progressView = UIView()
    fileprivate var activityIndicator = UIActivityIndicatorView()
    internal enum SpinnerAction {
        case Start, Stop
    }
    func spinner(mark action:SpinnerAction) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        containerView.frame = window.frame
        containerView.center = window.center
        containerView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        progressView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        progressView.center = window.center
        progressView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
        progressView.layer.cornerRadius = 10
        progressView.clipsToBounds = true
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        activityIndicator.style = .whiteLarge
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2)
        progressView.addSubview(activityIndicator)
        containerView.addSubview(progressView)
        UIApplication.shared.keyWindow?.addSubview(containerView)
        switch action {
        case .Start: activityIndicator.startAnimating()
        case .Stop:
            activityIndicator.stopAnimating()
            containerView.removeFromSuperview()
        }
    }
}

class Line:UIView {
    init(color:UIColor = UIColor.gray, opacity:Float = 0.5) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = color
        self.layer.opacity = opacity
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class TextInsetLabel:UILabel {
    open var textInsets: UIEdgeInsets = .zero {
        didSet { setNeedsDisplay() }
    }
    open override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: textInsets)
        super.drawText(in: insetRect)
    }
}


class InsetLabel:UILabel {
    var topInset:CGFloat!
    var bottomInset:CGFloat!
    var leftInset:CGFloat!
    var rightInset:CGFloat!
    init(insets:UIEdgeInsets) {
        super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        self.topInset = insets.top
        self.bottomInset = insets.bottom
        self.leftInset = insets.left
        self.rightInset = insets.right
    }
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)))
    }
    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class HapticFeedbackGenerator {
    internal enum FeedbackType { case Error, Warning, Success, Light, Medium, Heavy, Rigid, Soft, SelectionChanged }
    static func generateFeedback(ofType feedbackType: FeedbackType) {
        switch feedbackType {
        case .Error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        case .Warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        case .Success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        case .Light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case .Medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        case .Heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        case .Rigid:
            if #available(iOS 13.0, *) {
                let generator = UIImpactFeedbackGenerator(style: .rigid)
                generator.impactOccurred()
            } else {
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            }
        case .Soft:
            if #available(iOS 13.0, *) {
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.impactOccurred()
            } else {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            }
        case .SelectionChanged:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }
}
/*
class ViewController: UIViewController {
    var i = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false

        btn.widthAnchor.constraint(equalToConstant: 128).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 128).isActive = true
        btn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        btn.setTitle("Tap here!", for: .normal)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.addTarget(self, action: #selector(tapped), for: .touchUpInside)

        view.addSubview(btn)
    }

    @objc func tapped() {
        i += 1
        print("Running \(i)")

        switch i {
        case 1:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)

        case 2:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)

        case 3:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)

        case 4:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()

        case 5:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()

        case 6:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()

        default:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            i = 0
        }
    }
}
*/



/*
#1. Using FloatingPoint rounded() method

In the simplest case, you may use the Double round() method.

let roundedValue1 = (0.6844 * 1000).rounded() / 1000
let roundedValue2 = (0.6849 * 1000).rounded() / 1000
print(roundedValue1) // returns 0.684
print(roundedValue2) // returns 0.685
#2. Using FloatingPoint rounded(_:) method

let roundedValue1 = (0.6844 * 1000).rounded(.toNearestOrEven) / 1000
let roundedValue2 = (0.6849 * 1000).rounded(.toNearestOrEven) / 1000
print(roundedValue1) // returns 0.684
print(roundedValue2) // returns 0.685
#3. Using Darwin round function

Foundation offers a round function via Darwin.

import Foundation

let roundedValue1 = round(0.6844 * 1000) / 1000
let roundedValue2 = round(0.6849 * 1000) / 1000
print(roundedValue1) // returns 0.684
print(roundedValue2) // returns 0.685
#4. Using a Double extension custom method built with Darwin round and pow functions

If you want to repeat the previous operation many times, refactoring your code can be a good idea.

import Foundation

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

let roundedValue1 = 0.6844.roundToDecimal(3)
let roundedValue2 = 0.6849.roundToDecimal(3)
print(roundedValue1) // returns 0.684
print(roundedValue2) // returns 0.685
#5. Using NSDecimalNumber rounding(accordingToBehavior:) method

If needed, NSDecimalNumber offers a verbose but powerful solution for rounding decimal numbers.

import Foundation

let scale: Int16 = 3

let behavior = NSDecimalNumberHandler(roundingMode: .plain, scale: scale, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)

let roundedValue1 = NSDecimalNumber(value: 0.6844).rounding(accordingToBehavior: behavior)
let roundedValue2 = NSDecimalNumber(value: 0.6849).rounding(accordingToBehavior: behavior)

print(roundedValue1) // returns 0.684
print(roundedValue2) // returns 0.685
#6. Using NSDecimalRound(_:_:_:_:) function

import Foundation

let scale = 3

var value1 = Decimal(0.6844)
var value2 = Decimal(0.6849)

var roundedValue1 = Decimal()
var roundedValue2 = Decimal()

NSDecimalRound(&roundedValue1, &value1, scale, NSDecimalNumber.RoundingMode.plain)
NSDecimalRound(&roundedValue2, &value2, scale, NSDecimalNumber.RoundingMode.plain)

print(roundedValue1) // returns 0.684
print(roundedValue2) // returns 0.685
#7. Using NSString init(format:arguments:) initializer

If you want to return a NSString from your rounding operation, using NSString initializer is a simple but efficient solution.

import Foundation

let roundedValue1 = NSString(format: "%.3f", 0.6844)
let roundedValue2 = NSString(format: "%.3f", 0.6849)
print(roundedValue1) // prints 0.684
print(roundedValue2) // prints 0.685
#8. Using String init(format:_:) initializer

Swift’s String type is bridged with Foundation’s NSString class. Therefore, you can use the following code in order to return a String from your rounding operation:

import Foundation

let roundedValue1 = String(format: "%.3f", 0.6844)
let roundedValue2 = String(format: "%.3f", 0.6849)
print(roundedValue1) // prints 0.684
print(roundedValue2) // prints 0.685
#9. Using NumberFormatter

If you expect to get a String? from your rounding operation, NumberFormatter offers a highly customizable solution.

import Foundation

let formatter = NumberFormatter()
formatter.numberStyle = NumberFormatter.Style.decimal
formatter.roundingMode = NumberFormatter.RoundingMode.halfUp
formatter.maximumFractionDigits = 3

let roundedValue1 = formatter.string(from: 0.6844)
let roundedValue2 = formatter.string(from: 0.6849)
print(String(describing: roundedValue1)) // prints Optional("0.684")
print(String(describing: roundedValue2)) // prints Optional("0.685")
*/
