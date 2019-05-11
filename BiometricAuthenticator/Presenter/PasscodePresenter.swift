//
//  PasscodePresenter.swift
//  BiometricAuthenticator
//
//  Created by Sumit Joshi on 2019/05/11.
//  Copyright © 2019 Sumit Joshi. All rights reserved.
//

import Foundation

protocol PasscodePresenterDelegate: NSObjectProtocol {
    func goNext()
    func dismissPasscodeLock()
    func savePasscode()
    func showError()
}

class PasscodePresenter {
    
    private let previousPasscode: String?
    
    weak var delegate: PasscodePresenterDelegate?
    
    // MARK: - Initializer
    
    // MEMO: Set the passcode as a parameter if user preferes to use the password of previous screen
    init(previousPasscode: String?) {
        self.previousPasscode = previousPasscode
    }
    
    // MARK: - Function
    
    // Process to execute if passcode is entered in the ViewController
    func inputCompleted(_ passcode: String, inputPasscodeType: InputPasscodeType) {
        let passcodeModel = PasscodeModel()
        
        switch inputPasscodeType {
            
        case .inputForCreate, .inputForUpdate:
            
            // Go to password confirmation screen
            self.delegate?.goNext()
            break
            
            
        case .retryForCreate, .retryForUpdate:
            
            // If the password is same as previous then register in the UserDefault
            if previousPasscode != passcode {
                self.delegate?.showError()
                return
            }
            if passcodeModel.saveHashedPasscode(passcode) {
                self.delegate?.savePasscode()
            } else {
                self.delegate?.showError()
            }
            break
            
            
        case .displayPasscodeLock:
            
            // Compare the passcode with the saved user and unlock the passcode lock if its the same
            if passcodeModel.compareSavedPasscodeWith(inputPasscode: passcode) {
                self.delegate?.dismissPasscodeLock()
            } else {
                self.delegate?.showError()
            }
            break
        }
    }
}
