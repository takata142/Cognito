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
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
    
    /// サインインする.
    @IBAction func signIn(_ sender: UIButton) {
        guard let username: String = self.usernameField.text,
            let password: String = self.passwordField.text else {
                self.presentErrorAlert(title: "ユーザ名またはパスワードが入力されていません。", message: nil)
                return
        }
        let authDetails: AWSCognitoIdentityPasswordAuthenticationDetails?
            = AWSCognitoIdentityPasswordAuthenticationDetails(username: username, password: password)
        self.passwordAuthenticationCompletion?.set(result: authDetails)
    }
    
    /// 「新しいアカウントを作成する」ボタンを押した時の処理.
    @IBAction func pushedSignUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SignUp", sender: nil)
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

