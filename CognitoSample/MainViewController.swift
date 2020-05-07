//
//  MainViewController.swift
//  CognitoSample
//
//  Created by 岩田裕登 on 2020/03/22.
//  Copyright © 2020 Yuto Iwata. All rights reserved.
//

import AWSCognitoIdentityProvider
import UIKit

class MainViewController: UIViewController {
    /// 「サインイン」ボタン.
    @IBOutlet weak var signInButton: UIButton!
    /// 「サインアウト」ボタン.
    @IBOutlet weak var signOutButton: UIButton!
    
    /// view がメモリにロードされた後に呼ばれる.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /// view が表示される直前に呼ばれる. バックグラウンド復帰、タブ切り替えなどでも呼ばれる.
    override func viewWillAppear(_ animated: Bool) {
        let pool: AWSCognitoIdentityUserPool
            = AWSCognitoIdentityUserPool(forKey: CognitoConstants.SignInProviderKey)
        let user: AWSCognitoIdentityUser? = pool.currentUser()
        user?.getSession().continueWith { (task) in
            // セッションが切れている場合, サインアウトする.
            if task.result == nil {
                user?.signOut()
            } else {
                // サインインしているときは「サインイン」ボタンを無効化して隠す.
                self.signInButton.isEnabled = false
                self.signInButton.isHidden = true
                // 「サインアウト」ボタンを有効化して表示する.
                self.signOutButton.isEnabled = true
                self.signOutButton.isHidden = false
            }
            return nil
        }.waitUntilFinished()
    }

    /// 「サインイン」ボタンを押した時の処理.
    @IBAction func pushedSignIn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SignIn", sender: nil)
    }
    
    /// 「サインアウト」ボタンを押した時の処理.
    @IBAction func pushedSignOut(_ sender: UIButton) {
        let alertController: UIAlertController = UIAlertController(
            title: "サインアウトしますか？", message: nil, preferredStyle: .alert)
        let signOut: UIAlertAction = UIAlertAction(
            title: "サインアウトする", style: .default,
            handler: { (action: UIAlertAction!) in
                let pool: AWSCognitoIdentityUserPool
                    = AWSCognitoIdentityUserPool(forKey: CognitoConstants.SignInProviderKey)
                pool.currentUser()?.signOut()
                // 「サインイン」ボタンを有効化して表示する.
                self.signInButton.isEnabled = true
                self.signInButton.isHidden = false
                // 「サインアウト」ボタンを無効化して隠す.
                self.signOutButton.isEnabled = false
                self.signOutButton.isHidden = true
        })
        let cancel: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(signOut)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
}

