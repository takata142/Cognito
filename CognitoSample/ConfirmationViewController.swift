//
//  ConfirmationViewController.swift
//  CognitoSample
//
//  Created by 岩田裕登 on 2020/05/07.
//  Copyright © 2020 Yuto Iwata. All rights reserved.
//

import AWSCognitoIdentityProvider
import UIKit

/// 確認コード認証画面の ViewController.
class ConfirmationViewController: UIViewController {
    /// 確認コードを入力するよう伝える Label.
    @IBOutlet weak var instructionLabel: UILabel!
    /// 確認コード入力用 TextField.
    @IBOutlet weak var confirmationCodeField: UITextField!
    /// 確認コード認証中の処理を表す Activity Indicator.
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    /// SignUpViewController から渡されるユーザ名.
    var username: String?
    /// SignUpViewController から渡される, 確認コードの送信先メールアドレス.
    var sentTo: String?
    
    /// view がメモリにロードされた後に呼ばれる.
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.sentTo != nil {
            self.instructionLabel.text = "\(self.sentTo!)に\n送信される確認コードを\n入力してください。"
        }
        /// 画面タップ時の処理.
        let tapRecognizer: UITapGestureRecognizer
            = UITapGestureRecognizer(target: self, action: #selector(self.closeKeyboard(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        self.confirmationCodeField.delegate = self
        if #available(iOS 13.0, *) {
            self.indicatorView.style = .large
        }
    }
    
    /// 確認コードで認証する.
    @IBAction func confirm(sender: UIButton) {
        guard let code: String = self.confirmationCodeField.text else {
            print("Missing confirmation code.")
            self.presentErrorAlert(title: "確認コードが入力されていません。", message: nil)
            return
        }
        if self.username != nil {
            self.indicatorView.startAnimating()
            sender.isEnabled = false
            DispatchQueue.global(qos: .userInteractive).async {
                let pool: AWSCognitoIdentityUserPool = AWSCognitoIdentityUserPool(forKey: CognitoConstants.SignInProviderKey)
                let user: AWSCognitoIdentityUser = pool.getUser(self.username!)
                user.confirmSignUp(code).continueWith { task in
                    if let error: NSError = task.error as NSError? {
                        DispatchQueue.main.async {
                            self.presentErrorAlert(title: "確認コードでの認証ができませんでした。",
                                                   message: error.userInfo["message"] as? String)
                            self.indicatorView.stopAnimating()
                            sender.isEnabled = true
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.indicatorView.stopAnimating()
                            sender.isEnabled = true
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                    return task
                }
            }
        }
    }
    
    /// 画面タップ時の動作.
    @objc func closeKeyboard(_ sender: UITapGestureRecognizer) {
        // TextField 編集中の場合はキーボードを閉じる.
        if (self.confirmationCodeField.isFirstResponder) {
            self.confirmationCodeField.resignFirstResponder()
        }
    }
    
    /// ユーザ名を設定する.
    /// - Parameter username: 設定するユーザ名.
    func setUser(_ username: String) {
        // すでに設定されている場合は上書きしない.
        self.username = self.username ?? username
    }
    
    /// エラーを示すアラートを表示する.
    /// - Parameters:
    ///   - title:   アラートのタイトル.
    ///   - message: アラートのメッセージ.
    func presentErrorAlert(title: String?, message: String?) {
        /// エラーを表示するアラート.
        let errorAlert: UIAlertController = UIAlertController(title: title,
                                                              message: message,
                                                              preferredStyle: .alert)
        // アラートに「OK」ボタンを追加.
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(errorAlert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension ConfirmationViewController: UITextFieldDelegate {
    /// 編集中に Return ボタンが押された時の処理.
    /// - Parameter textField: Return ボタンが押された UITextField.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
