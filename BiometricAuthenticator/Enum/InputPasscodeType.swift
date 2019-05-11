//
//  InputPasscodeType.swift
//  BiometricAuthenticator
//
//  Created by Sumit Joshi on 2019/05/11.
//  Copyright © 2019 Sumit Joshi. All rights reserved.
//

import Foundation
enum InputPasscodeType {
    case inputForCreate      // Create new passcode
    case retryForCreate      // Confirm create new passcode
    case inputForUpdate      // Change passcode
    case retryForUpdate      // Confirm change passcode
    case displayPasscodeLock // Display passcode lock screen
    
    // MARK: - Function
    
    func getTitle() -> String {
        switch self {
        case .inputForCreate, .retryForCreate:
            return "Create Passcode"
        case .inputForUpdate, .retryForUpdate:
            return "Change Passcode"
        case .displayPasscodeLock:
            return "Passcode Lock"
        }
    }
    
    func getMessage() -> String {
        switch self {
        case .inputForCreate:
            return "Enter new Passcode"
        case .inputForUpdate:
            return "Chane Passcode"
        case .retryForCreate, .retryForUpdate:
            return "Re-enter the Passcode"
        case .displayPasscodeLock:
            return "Enter your Passcode"
        }
    }
    
    func getNextInputPasscodeType() -> InputPasscodeType? {
        switch self {
        case .inputForCreate:
            return .retryForCreate
        case .inputForUpdate:
            return .retryForUpdate
        default:
            return nil
        }
    }
}
