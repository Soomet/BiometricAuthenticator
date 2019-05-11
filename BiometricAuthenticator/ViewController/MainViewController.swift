//
//  MainViewController.swift
//  BiometricAuthenticator
//
//  Created by Sumit Joshi on 2019/05/11.
//  Copyright © 2019 Sumit Joshi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
    }
    
    // MARK: - Private Function
    
    private func setupUserInterface() {
        setupNavigationItems()
    }
    
    private func setupNavigationItems() {
        setupNavigationBarTitle("Authenticator")
    }
}


