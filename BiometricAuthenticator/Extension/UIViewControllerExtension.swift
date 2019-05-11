//
//  UIViewControllerExtension.swift
//  BiometricAuthenticator
//
//  Created by Sumit Joshi on 2019/05/11.
//  Copyright © 2019 Sumit Joshi. All rights reserved.
//

import Foundation
import UIKit

// UIViewController Extension
extension UIViewController {
    
    // Set the navigation bar of the screen
    public func setupNavigationBarTitle(_ title: String) {
        
        // Design the NavigationController
        var attributes = [NSAttributedString.Key : Any]()
        attributes[NSAttributedString.Key.font] = UIFont(name: "HiraKakuProN-W6", size: 14.0)
        attributes[NSAttributedString.Key.foregroundColor]  = UIColor.white
        
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.barTintColor = UIColor(code: "#333333")
        self.navigationController!.navigationBar.titleTextAttributes = attributes
        
        // Set the title
        self.navigationItem.title = title
    }
    
    // Make the back button "<" as "" or unseen
    public func removeBackButtonText() {
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem = backButtonItem
    }
}
