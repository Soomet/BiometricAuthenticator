//
//  TabBarItemType.swift
//  BiometricAuthenticator
//
//  Created by Sumit Joshi on 2019/05/11.
//  Copyright © 2019 Sumit Joshi. All rights reserved.
//

import Foundation
import FontAwesome_swift

enum TabBarItemType: CaseIterable {
    case home
    case setting
    
    // Get the appropriate ViewController
    func getViewController() -> UIViewController? {
        switch self {
        case .home:
            return UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        case .setting:
            return UIStoryboard(name: "Setting", bundle: nil).instantiateInitialViewController()
        }
    }
    
    // Get the index number of the TabBar
    func getTabIndex() -> Int {
        switch self {
        case .home:
            return 0
        case .setting:
            return 1
        }
    }
    
    // Get the title of the TabBar
    func getTabTitle() -> String {
        switch self {
        case .home:
            return "Main Screen"
        case .setting:
            return "Setting"
        }
    }
    
    // Get the FontAwesome Icon name
    func getTabFontAwesomeIcon() -> FontAwesome {
        switch self {
        case .home:
            return .home
        case .setting:
            return .bars
        }
    }
}
