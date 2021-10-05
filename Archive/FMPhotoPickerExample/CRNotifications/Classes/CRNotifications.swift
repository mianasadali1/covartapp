//
//  CRNotifications.swift
//  CRNotifications
//
//  Created by Casper Riboe on 21/03/2017.
//  LICENSE : MIT
//

import UIKit

@objc public class CRNotifications: NSObject {
    
    // MARK: - Static notification types
    
    public static let success: CRNotificationType = CRNotificationTypeDefinition(textColor: UIColor.init(red: 18.0/255.0, green: 18.0/255.0, blue: 18.0/255.0, alpha: 1.0), backgroundColor: UIColor.white, image: UIImage(named: "rateUS", in: nil, compatibleWith: nil))
    public static let error: CRNotificationType = CRNotificationTypeDefinition(textColor: UIColor.white, backgroundColor: UIColor.flatRed, image: UIImage(named: "error", in: Bundle(for: CRNotifications.self), compatibleWith: nil))
    public static let info: CRNotificationType = CRNotificationTypeDefinition(textColor: UIColor.white, backgroundColor: UIColor.flatGray, image: UIImage(named: "info", in: Bundle(for: CRNotifications.self), compatibleWith: nil))

    
    // MARK: - Init
    
    public override init(){}
    
    
    // MARK: - Helpers
    
    /** Shows a CRNotification **/
//   @objc public static func showNotification(textColor: UIColor, backgroundColor: UIColor, image: UIImage?, title: String, message: String, dismissDelay: TimeInterval, completion: @escaping () -> () = {}) {
//        let notificationDefinition = CRNotificationTypeDefinition(textColor: textColor, backgroundColor: backgroundColor, image: image)
//        showNotification(type: notificationDefinition, title: title, message: message, dismissDelay: dismissDelay, completion: completion)
//    }
    
    /** Shows a CRNotification from a CRNotificationType **/
    @objc public static func showNotification(title: String, message: String, dismissDelay: TimeInterval, completion: @escaping () -> () = {}) {
        let view = CRNotification()
        let type = CRNotifications.success
        
        view.setBackgroundColor(color: type.backgroundColor)
        view.setTextColor(color: type.textColor)
        view.setImage(image: type.image)
        view.setTitle(title: title)
        view.setMessage(message: message)
        view.setDismisTimer(delay: dismissDelay)
		view.setCompletionBlock(completion)
        
        guard let window = UIApplication.shared.keyWindow else {
            print("Failed to show CRNotification. No keywindow available.")
            return
        }
        
        window.addSubview(view)
        view.showNotification()
    }
}

fileprivate struct CRNotificationTypeDefinition: CRNotificationType {
    var textColor: UIColor
    var backgroundColor: UIColor
    var image: UIImage?
}
