//
//  InputPasscodeKeyboardView.swift
//  BiometricAuthenticator
//
//  Created by Sumit Joshi on 2019/05/11.
//  Copyright © 2019 Sumit Joshi. All rights reserved.
//

import Foundation
import UIKit

// MEMO: Protocol to make change while the button is tapped
protocol InputPasscodeKeyboardDelegate: NSObjectProtocol {
    
    // Pass the numbers from 0-9 as a string when tapped
    func inputPasscodeNumber(_ numberOfString: String)
    
    // Delete the number if delete button is pressed
    func deletePasscodeNumber()
    
    // Start Biometric Authentic if the device supports the technology
    func executeLocalAuthentication()
}

class InputPasscodeKeyboardView: CustomViewBase {
    
    weak var delegate: InputPasscodeKeyboardDelegate?
    
    // Add the haptic feedback when button pressed
    private let buttonFeedbackGenerator: UIImpactFeedbackGenerator = {
        let generator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        return generator
    }()
    
    // Passcode lock number buttons
    // MEMO: its not "weak" because its connected through "Outlet Collection"ß用いて接続しているのでweakはけつけていません
    @IBOutlet private var inputPasscodeNumberButtons: [UIButton]!
    
    // Button for Local Authentication
    @IBOutlet private weak var executeLocalAuthenticationButton: UIButton!
    
    // Button for passcode lock delete button
    @IBOutlet private weak var deletePasscodeNumberButton: UIButton!
    
    // MARK: - Initializer
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        
        setupInputPasscodeKeyboardView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupInputPasscodeKeyboardView()
    }
    
    // MARK: - Function
    
    func shouldEnabledLocalAuthenticationButton(_ result: Bool = true) {
        executeLocalAuthenticationButton.isEnabled = result
        executeLocalAuthenticationButton.superview?.alpha = (result) ? 1.0 : 0.3
    }
    
    // MARK: - Private Function
    
    @objc private func inputPasscodeNumberButtonTapped(sender: UIButton) {
        guard let superView = sender.superview else {
            return
        }
        executeButtonAnimation(for: superView)
        buttonFeedbackGenerator.impactOccurred()
        self.delegate?.inputPasscodeNumber(String(sender.tag))
    }
    
    @objc private func deletePasscodeNumberButtonTapped(sender: UIButton) {
        guard let superView = sender.superview else {
            return
        }
        executeButtonAnimation(for: superView)
        buttonFeedbackGenerator.impactOccurred()
        self.delegate?.deletePasscodeNumber()
    }
    
    @objc private func executeLocalAuthenticationButtonTapped(sender: UIButton) {
        guard let superView = sender.superview else {
            return
        }
        executeButtonAnimation(for: superView)
        buttonFeedbackGenerator.impactOccurred()
        self.delegate?.executeLocalAuthentication()
    }
    
    private func setupInputPasscodeKeyboardView() {
        inputPasscodeNumberButtons.enumerated().forEach {
            let button = $0.element
            button.addTarget(self, action: #selector(self.inputPasscodeNumberButtonTapped(sender:)), for: .touchDown)
        }
        deletePasscodeNumberButton.addTarget(self, action: #selector(self.deletePasscodeNumberButtonTapped(sender:)), for: .touchDown)
        executeLocalAuthenticationButton.addTarget(self, action: #selector(self.executeLocalAuthenticationButtonTapped(sender:)), for: .touchDown)
    }
    
    private func executeButtonAnimation(for targetView: UIView, completionHandler: (() -> ())? = nil) {
        
        // MEMO: Show the user interaction response without the feel of delay through animation
        UIView.animateKeyframes(withDuration: 0.16, delay: 0.0, options: [.allowUserInteraction, .autoreverse], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 1.0, animations: {
                targetView.alpha = 0.5
            })
            UIView.addKeyframe(withRelativeStartTime: 1.0, relativeDuration: 1.0, animations: {
                targetView.alpha = 1.0
            })
        }, completion: { finished in
            completionHandler?()
        })
    }
}
