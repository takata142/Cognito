//
//  SignInViewController.swift
//  CognitoSample
//
//  Created by 岩田裕登 on 2020/03/22.
//  Copyright © 2020 Yuto Iwata. All rights reserved.
//

import AWSCognitoIdentityProvider
import UIKit

/// サインイン画面の ViewController.
class SignInViewController: UIViewController {
    /// ユーザ名入力用 TextField.
    @IBOutlet weak var usernameField: UITextField!
    /// パスワード入力用 TextField.
    @IBOutlet weak var passwordField: UITextField!
    /// 「サインイン」ボタン.
    @IBOutlet weak var signInButton: UIButton!
    
    /// view がメモリにロードされた後に呼ばれる.
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 画面タップ時の処理.
        let tapRecognizer: UITapGestureRecognizer
            = UITapGestureRecognizer(target: self, action: #selector(self.closeKeyboard(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        self.usernameField.delegate = self
        self.passwordField.delegate = self
    }
    
    /// サインインする.
    @IBAction func signIn(_ sender: UIButton) {
        guard let username: String = self.usernameField.text,
            let password: String = self.passwordField.text else {
                self.presentErrorAlert(title: "ユーザ名またはパスワードが入力されていません。", message: nil)
                return
        }
        print(username)
        let pool: AWSCognitoIdentityUserPool = AWSCognitoIdentityUserPool(forKey: CognitoConstants.SignInProviderKey)
        let user: AWSCognitoIdentityUser = pool.getUser(username)
        user.getSession(username, password: password, validationData: nil).continueWith { task in
            DispatchQueue.main.async {
                if let error: NSError = task.error as NSError? {
                    self.presentErrorAlert(title: error.userInfo["__type"] as? String,
                                           message: error.userInfo["message"] as? String)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            return task
        }
    }
    
    /// 「新しいアカウントを作成する」ボタンを押した時の処理.
    @IBAction func pushedSignUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SignUp", sender: nil)
    }
    
    /// 画面タップ時の処理.
    @objc func closeKeyboard(_ sender: UITapGestureRecognizer) {
        // TextField 編集中の場合はキーボードを閉じる.
        if (self.usernameField.isFirstResponder) {
            self.usernameField.resignFirstResponder()
        } else if (self.passwordField.isFirstResponder) {
            self.passwordField.resignFirstResponder()
        }
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
extension SignInViewController: UITextFieldDelegate {
    /// 編集中に Return ボタンが押された時の処理.
    /// - Parameter textField: Return ボタンが押された UITextField.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        // 次のタグ番号を持っている UITextField があればフォーカス.
        let nextTag: Int = textField.tag + 1
        if let nextTextField: UITextField = self.view.viewWithTag(nextTag) as? UITextField {
            nextTextField.becomeFirstResponder()
        }
        return true
    }
}
