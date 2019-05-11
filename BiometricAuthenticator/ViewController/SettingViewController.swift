//
//  SettingViewController.swift
//  BiometricAuthenticator
//
//  Created by Sumit Joshi on 2019/05/11.
//  Copyright © 2019 Sumit Joshi. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController: UIViewController {
    
    private let passcodeModel = PasscodeModel()
    
    @IBOutlet weak private var passcodeSwitch: UISwitch!
    @IBOutlet weak private var openSettingButton: UIButton!
    @IBOutlet weak private var editPasscodeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showTabBarItems()
        setCurrentPasscodeStatus()
    }
    
    // MARK: - Private Function
    
    @objc private func passcodeSwitchChanged() {
        if passcodeModel.existsHashedPasscode() {
            showAlertWith(title: "Disable Passcode", message: "Previously saved password will be deleted. Ok to proceed?",
                          okActionHandler: {
                            PasscodeModel().deleteHashedPasscode()
                            self.setCurrentPasscodeStatus()
            },
                          cancelActionHandler: {
                            self.setCurrentPasscodeStatus()
            }
            )
        } else {
            let vc = getPasscodeViewController(targetInputPasscodeType: .inputForCreate)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func openSettingButtonAction() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func editPasscodeButtonAction() {
        let vc = getPasscodeViewController(targetInputPasscodeType: .inputForUpdate)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setCurrentPasscodeStatus() {
        let isPasscodeExist = PasscodeModel().existsHashedPasscode()
        passcodeSwitch.isOn = isPasscodeExist
        editPasscodeButton.superview?.isHidden = !isPasscodeExist
    }
    
    private func getPasscodeViewController(targetInputPasscodeType: InputPasscodeType) -> PasscodeViewController {
        // 遷移先のViewControllerに関する設定をする
        let sb = UIStoryboard(name: "Passcode", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! PasscodeViewController
        vc.setTargetInputPasscodeType(targetInputPasscodeType)
        vc.setTargetPresenter(PasscodePresenter(previousPasscode: nil))
        return vc
    }
    
    private func setupUserInterface() {
        setupNavigationItems()
        setupPasscodeSwitch()
        setupOpenSettingButton()
        setupEditPasscodeButton()
    }
    
    private func setupNavigationItems() {
        setupNavigationBarTitle("Setting")
        removeBackButtonText()
    }
    
    private func setupPasscodeSwitch() {
        passcodeSwitch.addTarget(self, action: #selector(self.passcodeSwitchChanged), for: .touchUpInside)
    }
    
    private func setupOpenSettingButton() {
        openSettingButton.addTarget(self, action: #selector(self.openSettingButtonAction), for: .touchUpInside)
    }
    
    private func setupEditPasscodeButton() {
        editPasscodeButton.addTarget(self, action: #selector(self.editPasscodeButtonAction), for: .touchUpInside)
    }
    
    private func showTabBarItems() {
        if let tabBarVC = self.tabBarController {
            tabBarVC.tabBar.isHidden = false
        }
    }
    
    private func showAlertWith(title: String? = nil, message: String,
                               okActionHandler: @escaping () -> Void = {}, cancelActionHandler: @escaping () -> Void = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            okActionHandler()
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { _ in
            cancelActionHandler()
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
