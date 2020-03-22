//
//  SignUpViewController.swift
//  CognitoSample
//
//  Created by 岩田裕登 on 2020/03/22.
//  Copyright © 2020 Yuto Iwata. All rights reserved.
//

import UIKit

/// サインアップ画面の ViewController.
class SignUpViewController: UIViewController {
    /// ユーザ名入力用 TextField.
    @IBOutlet weak var usernameField: UITextField!
    /// パスワード入力用 TextField.
    @IBOutlet weak var passwordField: UITextField!
    /// 「サインイン」ボタン.
    @IBOutlet weak var signInButton: UIButton!
    
    /// サインアップする.
    @IBAction func signUp(_ sender: UIButton) {
    }
}

