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
            }
            return nil
        }.waitUntilFinished()
    }

    /// 「サインイン」ボタンを押した時の処理.
    @IBAction func pushedSignIn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SignIn", sender: nil)
    }
    
}

