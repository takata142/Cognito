//
//  MainViewController.swift
//  CognitoSample
//
//  Created by 岩田裕登 on 2020/03/22.
//  Copyright © 2020 Yuto Iwata. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    /// view がメモリにロードされた後に呼ばれる.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    /// 「サインイン」ボタンを押した時の処理.
    @IBAction func pushedSignIn(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SignIn", sender: nil)
    }
    
}

