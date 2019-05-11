//
//  CustomViewBase.swift
//  BiometricAuthenticator
//
//  Created by Sumit Joshi on 2019/05/11.
//  Copyright © 2019 Sumit Joshi. All rights reserved.
//

import Foundation
import UIKit

// CLass inherited from the UIView to use the self designed Xib
// Reference：http://skygrid.co.jp/jojakudoctor/swift-custom-class/

class CustomViewBase: UIView {
    
    // View to display content
    weak var contentView: UIView!
    
    // Initializer to use this custom view in a code
    required override init(frame: CGRect) {
        super.init(frame: frame)
        initContentView()
    }
    
    // Initializer to use this custom view in InterfaceBuilder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initContentView()
    }
    
    // Initializer for the view of the content display
    private func initContentView() {
        
        // Get the class name of the content view to add
        let viewClass: AnyClass = type(of: self)
        
        // Setting for the content view to be added
        contentView = Bundle(for: viewClass)
            .loadNibNamed(String(describing: viewClass), owner: self, options: nil)?.first as? UIView
        contentView.autoresizingMask = autoresizingMask
        contentView.frame = bounds
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        // Set the constraint(0 on all 4 sides) of the content view to be added
        let bindings = ["view": contentView as Any]
        
        let contentViewConstraintH = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[view]|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: bindings
        )
        let contentViewConstraintV = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[view]|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: bindings
        )
        addConstraints(contentViewConstraintH)
        addConstraints(contentViewConstraintV)
    }
}
