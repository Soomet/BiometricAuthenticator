//
//  AppConstant.swift
//  BiometricAuthenticator
//
//  Created by Sumit Joshi on 2019/05/11.
//  Copyright © 2019 Sumit Joshi. All rights reserved.
//

import Foundation
import UIKit

struct AppConstant {
    static let FONT_NAME: String = "HiraMaruProN-W4"
    static let PASSCODE_LENGTH: Int = 4
    
    // MARK: - Computed Property
    
    static var PASSCODE_HASH: String {
        return get("Passcode") as! String
    }
    
    // MARK: - Static Function
    
    static func get(_ key: String) -> AnyObject? {
        return Bundle.main.object(forInfoDictionaryKey: key) as AnyObject
    }
}
