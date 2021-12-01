//
//  MainViewController.swift
//  CognitoSample
//
//

import AWSCognitoIdentityProvider
import UIKit
import UserNotifications

//アクションの宣言
enum ActionIdentifier: String{
    case attend
    case absent
    case hold
}

class MainViewController: UIViewController,UNUserNotificationCenterDelegate{
    /// 「サインイン」ボタン.
    @IBOutlet weak var signInButton: UIButton!
    /// 「サインアウト」ボタン.
    @IBOutlet weak var signOutButton: UIButton!
    /// 「(Username) さんがサインインしています。」のラベル.
    @IBOutlet weak var userLabel: UILabel!
    

    @IBOutlet weak var timeNotification: UIButton!
    

    
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
                // 「サインアウト」ボタン、ラベルを有効化して表示する.
                self.signOutButton.isEnabled = true
                self.signOutButton.isHidden = false
                //通知ボタンを有効化して表示
                self.timeNotification.isEnabled = true
                self.timeNotification.isHidden = false
                
                self.userLabel.text = user!.username! + "さんが\nサインインしています。"
                self.userLabel.isHidden = false
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
                // 「サインアウト」ボタン、ラベルを無効化して隠す.
                self.signOutButton.isEnabled = false
                self.signOutButton.isHidden = true
                self.userLabel.isHidden = true
                //通知ボタンを無効化して非表示
                self.timeNotification.isEnabled = false
                self.timeNotification.isHidden = true
                
        })
        let cancel: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(signOut)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    

    
    
    
    //通知ボタン押下
    @IBAction func timeButton(_ sender: UIButton) {
        
        let attend = UNNotificationAction(identifier: ActionIdentifier.attend.rawValue, title: "出席", options: [])
        let absent = UNNotificationAction(identifier: ActionIdentifier.absent.rawValue, title: "欠席", options: [])
        let hold = UNNotificationAction(identifier: ActionIdentifier.hold.rawValue, title: "保留", options: [])
        
        let category = UNNotificationCategory(identifier: "message", actions: [attend,absent,hold], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        //UNUserNotificationCenter.current().delegate = self

        
        //通知の内容
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = "出席確認"
        content.subtitle = "サブタイトル"
        content.body = "参加可否を教えてください。"
        
        content.categoryIdentifier = "message"
        
        //タイマーの時間をセット
        let timer = 5
        
        //通知のリクエスト
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timer), repeats: false)
        //let identifer = NSUUID().uuidString
        let request = UNNotificationRequest(identifier:"fivesecond",
                                            content:content,
                                            trigger:trigger)
        UNUserNotificationCenter.current().add(request,withCompletionHandler: nil)
    }
    

    
}

