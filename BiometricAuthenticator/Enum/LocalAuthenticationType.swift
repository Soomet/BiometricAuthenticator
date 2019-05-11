//
//  LocalAuthenticationType.swift
//  BiometricAuthenticator
//
//  Created by Sumit Joshi on 2019/05/11.
//  Copyright © 2019 Sumit Joshi. All rights reserved.
//

import Foundation

enum LocalAuthenticationType {
    case authWithFaceID  // FaceID Authentication
    case authWithTouchID // TouchID Authentication
    case authWithManual  // Passcode Authentication
    
    // MARK: - Function
    
    func getDescriptionTitle() -> String {
        switch self {
        case .authWithFaceID:
            return "FaceID"
        case .authWithTouchID:
            return "TouchID"
        default:
            return ""
        }
    }
    
    func getLocalizedReason() -> String {
        switch self {
        case .authWithFaceID, .authWithTouchID:
            return "Authenticate by \(self.getDescriptionTitle())"
        default:
            return ""
        }
    }
}
