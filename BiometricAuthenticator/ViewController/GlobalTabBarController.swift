//
//  GlobalTabBarController.swift
//  BiometricAuthenticator
//
//  Created by Sumit Joshi on 2019/05/11.
//  Copyright © 2019 Sumit Joshi. All rights reserved.
//

import Foundation
import UIKit

class GlobalTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.viewControllers = [UIViewController(), UIViewController()]
        
        setupUserInterface()
        
        // Monitor the notification of Passcode Lock Screen while starting and closing the app
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayPasscodeLockScreenIfNeeded), name: UIApplication.didFinishLaunchingNotification, object: nil)
    }
    
    // MARK: - Private Function
    
    @objc private func displayPasscodeLockScreenIfNeeded() {
        let passcodeModel = PasscodeModel()
        
        // Do nothing if passcode lock is not set
        if !passcodeModel.existsHashedPasscode() {
            return
        }
        
        let nav = UINavigationController(rootViewController: getPasscodeViewController())
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle   = .crossDissolve
        self.present(nav, animated: false, completion: nil)
    }
    
    private func setupUserInterface() {
        setupGlobalTabBar()
    }
    
    private func setupGlobalTabBar() {
        
        // Set the color of the tab while selected and not selected
        let itemSize = CGSize(width: 28.0, height: 28.0)
        let deselectedColor: UIColor = .lightGray
        let selectedColor: UIColor = .black
        let tabBarItemFont = UIFont(name: AppConstant.FONT_NAME, size: 10)!
        
        let deselectedAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: tabBarItemFont,
            NSAttributedString.Key.foregroundColor: deselectedColor
        ]
        let selectedAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: tabBarItemFont,
            NSAttributedString.Key.foregroundColor: selectedColor
        ]
        
        // Set the image for the TabBar
        let _ = TabBarItemType.allCases.enumerated().map { (index, tabBarItem) in
            
            // Set the appropriate ViewController
            guard let vc = tabBarItem.getViewController() else {
                fatalError("Invalid Target ViewController.")
            }
            self.viewControllers?[index] = vc
            
            // Set the title of the appropriate ViewController
            self.viewControllers?[index].title = tabBarItem.getTabTitle()
            
            // Set the element of the TabBar of appropriate ViewContoller
            self.viewControllers?[index].tabBarItem.setTitleTextAttributes(deselectedAttributes, for: [])
            self.viewControllers?[index].tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
            self.viewControllers?[index].tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -2.0)
            self.viewControllers?[index].tabBarItem.image = UIImage.fontAwesomeIcon(name: tabBarItem.getTabFontAwesomeIcon(), style: .solid, textColor: deselectedColor, size: itemSize).withRenderingMode(.alwaysOriginal)
            self.viewControllers?[index].tabBarItem.selectedImage = UIImage.fontAwesomeIcon(name: tabBarItem.getTabFontAwesomeIcon(), style: .solid, textColor: selectedColor, size: itemSize).withRenderingMode(.alwaysOriginal)
        }
    }
    
    private func getPasscodeViewController() -> PasscodeViewController {
        // Setting of the next ViewController
        let sb = UIStoryboard(name: "Passcode", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! PasscodeViewController
        vc.setTargetInputPasscodeType(.displayPasscodeLock)
        vc.setTargetPresenter(PasscodePresenter(previousPasscode: nil))
        return vc
    }
}

