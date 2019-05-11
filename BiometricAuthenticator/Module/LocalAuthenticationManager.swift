//
//  LocalAuthenticationManager.swift
//  BiometricAuthenticator
//
//  Created by Sumit Joshi on 2019/05/11.
//  Copyright © 2019 Sumit Joshi. All rights reserved.
//

import Foundation
import LocalAuthentication

class LocalAuthenticationManager {
    
    // MARK: - Static Function
    
    static func getDeviceOwnerLocalAuthenticationType() -> LocalAuthenticationType {
        let localAuthenticationContext = LAContext()
        
        // From iOS11: FaceID/TouchID/Passcode
        if #available(iOS 11.0, *) {
            
            if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                switch localAuthenticationContext.biometryType {
                case .faceID:
                    return .authWithFaceID
                case .touchID:
                    return .authWithTouchID
                default:
                    return .authWithManual
                }
            }
            
            // Below iOS10: TouchID/Passcode
        } else {
            
            if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                return .authWithTouchID
            } else {
                return .authWithManual
            }
            
        }
        return .authWithManual
    }
    
    static func evaluateDeviceOwnerLocalAuthentication(successHandler: (() -> ())? = nil, errorHandler: (() -> ())? = nil) {
        let type = self.getDeviceOwnerLocalAuthenticationType()
        
        // Dont continue if the user selects to unlock through passcode
        if type == .authWithManual {
            return
        }
        
        // Process according to the FaceID or TouchID result
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: type.getLocalizedReason(), reply: { success, evaluateError in
            if success {
                // Success
                successHandler?()
                print("Authentication Successful:", type.getDescriptionTitle())
            } else {
                // Failed
                errorHandler?()
                print("Authentication Failed:", evaluateError.debugDescription)
            }
        })
    }
}

