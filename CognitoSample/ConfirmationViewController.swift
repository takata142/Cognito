//
//  ConfirmationViewController.swift
//  CognitoSample
//
//  Created by 岩田裕登 on 2020/05/07.
//  Copyright © 2020 Yuto Iwata. All rights reserved.
//

import UIKit

/// 確認コード認証画面の ViewController.
class ConfirmationViewController: UIViewController {
    /// 確認コードを入力するよう伝える Label.
    @IBOutlet weak var instructionLabel: UILabel!
    /// 確認コード入力用 TextField.
    @IBOutlet weak var confirmationCodeField: UITextField!
    /// 「確認コードで認証」ボタン.
    @IBOutlet weak var confirmButton: UIButton!
    /// SignUpViewController から渡されるユーザ名.
    var username: String?
    /// SignUpViewController から渡される, 確認コードの送信先メールアドレス.
    var sentTo: String?
    /// SignUpViewController から渡されるパスワード.
    private var receivedPassword: String?
    
    /// view がメモリにロードされた後に呼ばれる.
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.sentTo != nil {
            self.instructionLabel.text = "\(self.sentTo!)に送信される\n確認コードを入力してください。"
        }
        /// 画面タップ時の処理.
        let tapRecognizer: UITapGestureRecognizer
            = UITapGestureRecognizer(target: self, action: #selector(self.closeKeyboard(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        self.confirmationCodeField.delegate = self
    }
    
    /// 確認コードで認証する.
    @IBAction func confirm(sender: UIButton) {
    }
    
    /// 画面タップ時の動作.
    @objc func closeKeyboard(_ sender: UITapGestureRecognizer) {
        // TextField 編集中の場合はキーボードを閉じる.
        if (self.confirmationCodeField.isFirstResponder) {
            self.confirmationCodeField.resignFirstResponder()
        }
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
