//
//  ExtensionMethods.swift
//  JameelCustomer
//
//  Created by Vikas on 08/07/19.
//  Copyright © 2019 9HZ. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    @IBInspectable
    var imageTintColor: UIColor? {
        get {
            return self.tintColor
        }
        set {
            let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
            self.image = templateImage
            self.tintColor = newValue
        }
    }
}

extension UIImage {
    func fixedOrientation() -> UIImage? {
        guard imageOrientation != UIImage.Orientation.up else {
            //This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            //CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil //Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }
        
        //Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
    
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UINavigationItem {
    func addLeftButtonWithImage(_ target: Any, action: Selector, buttonImage: UIImage?) {
        let leftButton = UIBarButtonItem(image: buttonImage, style: .plain, target: target, action: action)
        self.leftBarButtonItem = leftButton
    }
    
    func addLeftButtonWithTitle(_ target: Any, action: Selector, buttonTitle: String) {
        let leftButton = UIBarButtonItem(title: buttonTitle, style: .plain, target: target, action: action)
        self.leftBarButtonItem = leftButton
    }
    
    func addRightButtonWithImage(_ target: Any, action: Selector, buttonImage: UIImage?) {
        let rightButton = UIBarButtonItem(image: buttonImage, style: .plain, target: target, action: action)
        self.rightBarButtonItem = rightButton
    }
    
    func addRightButtonWithTitle(_ target: Any, action: Selector, buttonTitle: String) {
        let rightButton = UIBarButtonItem(title: buttonTitle, style: .plain, target: target, action: action)
        self.rightBarButtonItem = rightButton
    }
    
    func addCustomViewToLeft(view: UIView) {
        self.leftBarButtonItem = UIBarButtonItem(customView: view)
    }
    
    func addCustomViewToRight(view: UIView) {
        self.rightBarButtonItem = UIBarButtonItem(customView: view)
    }
    
    func addMutipleItemsToLeft(items: [UIBarButtonItem]) {
        self.leftBarButtonItems = items
    }
    
    func addMutipleItemsToRight(items: [UIBarButtonItem]) {
        self.rightBarButtonItems = items
    }
}

extension UIApplication {
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
