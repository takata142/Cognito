//
//  SignUpViewController.swift
//  CognitoSample
//
//

import AWSCognitoIdentityProvider
import UIKit

/// サインアップ画面の ViewController.
class SignUpViewController: UIViewController {
    /// ユーザ名入力用 TextField.
    @IBOutlet weak var usernameField: UITextField!
    /// メールアドレス入力用 TextField.
    @IBOutlet weak var emailField: UITextField!
    /// パスワード入力用 TextField.
    @IBOutlet weak var passwordField: UITextField!
    /// サインアップ中の処理を表す Activity Indicator.
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    /// view がメモリにロードされた後に呼ばれる.
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 画面タップ時の処理.
        let tapRecognizer: UITapGestureRecognizer
            = UITapGestureRecognizer(target: self, action: #selector(self.closeKeyboard(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        self.usernameField.delegate = self
        self.emailField.delegate = self
        self.passwordField.delegate = self
        if #available(iOS 13.0, *) {
            self.indicatorView.style = .large
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmSignUp" {
            let destination: ConfirmationViewController? = segue.destination as? ConfirmationViewController
            if let array: [String?] = sender as? [String?] {
                // ConfirmationViewController に値を渡す.
                destination?.setUser(array[0]!)
                destination?.sentTo = array[1]
            }
        }
    }
    
    /// サインアップする.
    @IBAction func signUp(_ sender: UIButton) {
        guard let username: String = self.usernameField.text,
            let email: String = self.emailField.text,
            let password: String = self.passwordField.text else {
                print("Missing username, email or password.")
                self.presentErrorAlert(title: "ユーザ名、メールアドレスまたはパスワードが入力されていません。", message: nil)
                return
        }
        self.indicatorView.startAnimating()
        sender.isEnabled = false
        let name: AWSCognitoIdentityUserAttributeType = AWSCognitoIdentityUserAttributeType(name: "name", value: username)
        let emailAttribute: AWSCognitoIdentityUserAttributeType = AWSCognitoIdentityUserAttributeType(name: "email", value: email)
        let attributes: [AWSCognitoIdentityUserAttributeType] = [name, emailAttribute]
        let pool: AWSCognitoIdentityUserPool = AWSCognitoIdentityUserPool(forKey: CognitoConstants.SignInProviderKey)
        pool.signUp(username, password: password, userAttributes: attributes, validationData: nil).continueWith { task in
            DispatchQueue.main.async {
                if let error: NSError = task.error as NSError? {
                    self.presentErrorAlert(title: error.userInfo["__type"] as? String,
                                           message: error.userInfo["message"] as? String)
                    self.indicatorView.stopAnimating()
                    sender.isEnabled = true
                } else {
                    if let result: AWSCognitoIdentityUserPoolSignUpResponse = task.result {
                        self.indicatorView.stopAnimating()
                        sender.isEnabled = true
                        // ユーザがメールやSMSでの認証を必要とするかどうかで処理を分ける.
                        if (result.user.confirmedStatus != .confirmed) {
                            self.performSegue(withIdentifier: "ConfirmSignUp", sender: [username,
                                                                                        result.codeDeliveryDetails?.destination])
                        } else {
                            // 確認コード認証が不要な場合は NavigationView を閉じる.
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
            return task
        }
    }
    
    /// 画面タップ時の動作.
    @objc func closeKeyboard(_ sender: UITapGestureRecognizer) {
        // TextField 編集中の場合はキーボードを閉じる.
        if (self.usernameField.isFirstResponder) {
            self.usernameField.resignFirstResponder()
        } else if (self.emailField.isFirstResponder) {
            self.emailField.resignFirstResponder()
        } else if (self.passwordField.isFirstResponder) {
            self.passwordField.resignFirstResponder()
        }
    }
    
    /// エラーを示すアラートを表示する.
    /// - Parameter title:   アラートのタイトル.
    /// - Parameter message: アラートのメッセージ.
    func presentErrorAlert(title: String?, message: String?) {
        /// エラーを表示するアラート.
        let errorAlert: UIAlertController
            = UIAlertController(title: title,
                                message: message,
                                preferredStyle: .alert)
        // アラートに「OK」ボタンを追加.
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(errorAlert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
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
