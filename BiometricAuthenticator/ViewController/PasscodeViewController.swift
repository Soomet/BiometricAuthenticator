//
//  PasscodeViewController.swift
//  BiometricAuthenticator
//
//  Created by Sumit Joshi on 2019/05/11.
//  Copyright © 2019 Sumit Joshi. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

class PasscodeViewController: UIViewController {
    
    // Variable to pass before screen change
    private var inputPasscodeType: InputPasscodeType!
    private var presenter: PasscodePresenter!
    
    private var userInputPasscode: String = ""
    
    @IBOutlet weak private var inputPasscodeDisplayView: InputPasscodeDisplayView!
    @IBOutlet weak private var inputPasscodeKeyboardView: InputPasscodeKeyboardView!
    @IBOutlet weak private var inputPasscodeMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MEMO: Set the Protocol set in PasscodePresenter
        presenter.delegate = self
        
        setupUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideTabBarItems()
    }
    
    // MARK: - Function
    
    func setTargetPresenter(_ presenter: PasscodePresenter) {
        self.presenter = presenter
    }
    
    func setTargetInputPasscodeType(_ inputPasscodeType: InputPasscodeType) {
        self.inputPasscodeType = inputPasscodeType
    }
    
    // MARK: - Private Function
    
    private func setupUserInterface() {
        setupNavigationItems()
        setupInputPasscodeMessageLabel()
        setupPasscodeNumberKeyboardView()
    }
    
    private func setupNavigationItems() {
        setupNavigationBarTitle(inputPasscodeType.getTitle())
        removeBackButtonText()
    }
    
    private func setupInputPasscodeMessageLabel() {
        inputPasscodeMessageLabel.text = inputPasscodeType.getMessage()
    }
    
    private func setupPasscodeNumberKeyboardView() {
        inputPasscodeKeyboardView.delegate = self
        
        // MEMO: Check the condition of the device's FaceID/TouchID and which screen are they being used
        var isEnabledLocalAuthenticationButton: Bool = false
        if inputPasscodeType == .displayPasscodeLock {
            isEnabledLocalAuthenticationButton = LocalAuthenticationManager.getDeviceOwnerLocalAuthenticationType() != .authWithManual
        }
        inputPasscodeKeyboardView.shouldEnabledLocalAuthenticationButton(isEnabledLocalAuthenticationButton)
    }
    
    private func hideTabBarItems() {
        if let tabBarVC = self.tabBarController {
            tabBarVC.tabBar.isHidden = true
        }
    }
    
    private func acceptUserInteraction() {
        self.view.isUserInteractionEnabled = true
    }
    
    private func refuseUserInteraction() {
        self.view.isUserInteractionEnabled = false
    }
    
    // Wrapper to execute B process after some seconds of exeuting A process
    // MEMO: To prevent from the unintentional screen change by fast usage from the user
    private func executeSeriesAction(firstAction: (() -> ())? = nil, deleyedAction: @escaping (() -> ())) {
        // Not receive the user interaction at first
        self.refuseUserInteraction()
        firstAction?()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.24) {
            // Accept the user interaction only fter 0.24 seconds
            self.acceptUserInteraction()
            deleyedAction()
        }
    }
}

// MARK: - PasscodeNumberKeyboardDelegate

extension PasscodeViewController: InputPasscodeKeyboardDelegate {
    
    func inputPasscodeNumber(_ numberOfString: String) {
        
        // パスコードが0から3文字の場合はキーボードの押下された数値の文字列を末尾に追加する
        if 0...3 ~= userInputPasscode.count {
            userInputPasscode = userInputPasscode + numberOfString
            inputPasscodeDisplayView.incrementDisplayImagesBy(passcodeStringCount: userInputPasscode.count)
        }
        
        // パスコードが4文字の場合はPasscodePresenter側に定義した入力完了処理を実行する
        if userInputPasscode.count == AppConstant.PASSCODE_LENGTH {
            presenter.inputCompleted(userInputPasscode, inputPasscodeType: inputPasscodeType)
        }
    }
    
    func deletePasscodeNumber() {
        
        // パスコードが1から3文字の場合は数値の文字列の末尾を削除する
        if 1...3 ~= userInputPasscode.count {
            userInputPasscode = String(userInputPasscode.prefix(userInputPasscode.count - 1))
            inputPasscodeDisplayView.decrementDisplayImagesBy(passcodeStringCount: userInputPasscode.count)
        }
    }
    
    func executeLocalAuthentication() {
        
        // パスコードロック画面以外では操作を許可しない
        guard inputPasscodeType == .displayPasscodeLock else {
            return
        }
        
        // TouchID/FaceIDによる認証を実行し、成功した場合にはパスコードロックを解除する
        LocalAuthenticationManager.evaluateDeviceOwnerLocalAuthentication(
            successHandler: {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
        },
            errorHandler: {}
        )
    }
}

// MARK: - PasscodePresenterProtocol

extension PasscodeViewController: PasscodePresenterDelegate {
    
    // 次に表示するべき画面へ入力された値を引き継いだ状態で遷移する
    func goNext() {
        executeSeriesAction(
            firstAction: {},
            deleyedAction: {
                // Enum経由で次のアクションで設定すべきEnumの値を取得する
                guard let nextInputPasscodeType = self.inputPasscodeType.getNextInputPasscodeType() else {
                    return
                }
                // 遷移先のViewControllerに関する設定をする
                let sb = UIStoryboard(name: "Passcode", bundle: nil)
                let vc = sb.instantiateInitialViewController() as! PasscodeViewController
                vc.setTargetInputPasscodeType(nextInputPasscodeType)
                vc.setTargetPresenter(PasscodePresenter(previousPasscode: self.userInputPasscode))
                self.navigationController?.pushViewController(vc, animated: true)
                
                
                self.userInputPasscode.removeAll()
                self.inputPasscodeDisplayView.decrementDisplayImagesBy()
        }
        )
    }
    
    // パスコードロック画面を解除する
    func dismissPasscodeLock() {
        executeSeriesAction(
            firstAction: {},
            deleyedAction: {
                self.dismiss(animated: true, completion: nil)
        }
        )
    }
    
    // ユーザーが入力したパスコードを保存して設定画面へ戻る
    func savePasscode() {
        executeSeriesAction(
            firstAction: {},
            deleyedAction: {
                self.navigationController?.popToRootViewController(animated: true)
        }
        )
    }
    
    // ユーザーが入力した値が正しくないことをユーザーへ伝える
    func showError() {
        executeSeriesAction(
            // 実行直後はエラーメッセージを表示する & バイブレーションを適用する
            firstAction: {
                self.inputPasscodeMessageLabel.text = "パスコードが一致しませんでした"
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        },
            // 秒数経過後にユーザーが入力したメッセージを空にする & パスコードのハート表示をリセットする
            deleyedAction: {
                self.userInputPasscode.removeAll()
                self.inputPasscodeDisplayView.decrementDisplayImagesBy()
        }
        )
    }
}
