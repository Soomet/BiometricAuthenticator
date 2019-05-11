//
//  PasscodeModel.swift
//  BiometricAuthenticator
//
//  Created by Sumit Joshi on 2019/05/11.
//  Copyright © 2019 Sumit Joshi. All rights reserved.
//

import Foundation

class PasscodeModel {
    
    private let userHashedPasscode = "PasscodeModel:userHashedPasscode"
    
    private var ud: UserDefaults {
        return UserDefaults.standard
    }
    
    // MARK: - Function
    
    // Save the passcode
    func saveHashedPasscode(_ passcode: String) -> Bool {
        if isValid(passcode) {
            setHashedPasscode(passcode)
            return true
        } else {
            return false
        }
    }
    
    // Compare the passcode entered by the user and the saved one
    func compareSavedPasscodeWith(inputPasscode: String) -> Bool {
        let hashedInputPasscode = getHashedPasscodeByHMAC(inputPasscode)
        let savedPasscode = getHashedPasscode()
        return hashedInputPasscode == savedPasscode
    }
    
    // Decide to save the passcode enterd by the user
    func existsHashedPasscode() -> Bool {
        let savedPasscode = getHashedPasscode()
        return !savedPasscode.isEmpty
    }
    
    // Get the passcode hashed with HMAC
    func getHashedPasscode() -> String {
        return ud.string(forKey: userHashedPasscode) ?? ""
    }
    
    // Delete the currently saved passcode
    func deleteHashedPasscode() {
        ud.set("", forKey: userHashedPasscode)
    }
    
    // MARK: - Private Function
    
    // Save the passcode received from parameters after encrypting by hmac
    private func setHashedPasscode(_ passcode: String) {
        let hashedPasscode = getHashedPasscodeByHMAC(passcode)
        ud.set(hashedPasscode, forKey: userHashedPasscode)
    }
    
    // Encrypt the passcode with hmac
    private func getHashedPasscodeByHMAC(_ passcode: String) -> String {
        return passcode.hmac(algorithm: .SHA256)
    }
    
    // Check the validity of the passcode
    private func isValid(_ passcode: String) -> Bool {
        return isValidLength(passcode) && isValidFormat(passcode)
    }
    
    // Check if the passcode length 4
    private func isValidLength(_ passcode: String) -> Bool {
        return passcode.count == AppConstant.PASSCODE_LENGTH
    }
    
    // Check if the passcode is the numeric value
    private func isValidFormat(_ passcode: String) -> Bool {
        let regexp = try! NSRegularExpression.init(pattern: "^(?=.*?[0-9])[0-9]{4}$", options: [])
        let targetString = passcode as NSString
        let result = regexp.firstMatch(in: passcode, options: [], range: NSRange.init(location: 0, length: targetString.length))
        return result != nil
    }
}
