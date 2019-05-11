//
//  NSObjectProtocolExtension.swift
//  BiometricAuthenticator
//
//  Created by Sumit Joshi on 2019/05/11.
//  Copyright © 2019 Sumit Joshi. All rights reserved.
//

import Foundation
import UIKit

// NSObjectProtocolの拡張
extension NSObjectProtocol {
    
    // クラス名を返す変数"className"を返す
    static var className: String {
        return String(describing: self)
    }
}
