//
//  AppDelegate.swift
//  CognitoSample
//
//

import AWSCognitoIdentityProvider
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // AWS サービス設定を作成.
        let serviceConfiguration: AWSServiceConfiguration = AWSServiceConfiguration(
            region: CognitoConstants.IdentityUserPoolRegion,
            credentialsProvider: nil
        )
        // ユーザプール設定を作成.
        let userPoolConfigration: AWSCognitoIdentityUserPoolConfiguration =
            AWSCognitoIdentityUserPoolConfiguration(clientId: CognitoConstants.AppClientId,
                                                    clientSecret: CognitoConstants.AppClientSecret,
                                                    poolId: CognitoConstants.IdentityUserPoolId)
        // ユーザープールクライアントを初期化.
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration,
                                            userPoolConfiguration: userPoolConfigration,
                                            forKey: CognitoConstants.SignInProviderKey)
        
        
        //プッシュ通知の利用許可のリクエスト送信
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]){granted, error in
            guard granted else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        //通知許可の取得
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound],completionHandler:{(granted,error) in
            if error != nil {
                return
            }
            if granted{
                UNUserNotificationCenter.current().delegate = self
            }else{
                print("認証されていません")
            }
        })
        
        
        
        
        return true
    }
    
    

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
//デバイストークンの取得
extension AppDelegate{
    func application(_ application:UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken:Data){
        let token = deviceToken.map{String(format:"%.2hhx",$0)}.joined()
        print("Device token: \(token)")
    }
    func application(_ applicatioin:UIApplication,
                     didRegisterForRemoteNotificationsWithError error:Error){
        print("ailed to register to APNs: \(error)")
    }
}

// アプリが起動中それ以外でも通知が届く設定
extension AppDelegate:UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:@escaping(UNNotificationPresentationOptions)->Void) {
        completionHandler([.alert,.sound])
    }
    
    //アクション選択時に呼び出されるメソッド
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response:UNNotificationResponse,
                                withCompletionHandler completionHandler:@escaping()-> Void) {
        switch response.actionIdentifier{
        case ActionIdentifier.attend.rawValue:
            debugPrint("出席ボタンが押されました")
            
        case ActionIdentifier.absent.rawValue:
            debugPrint("欠席ボタンが押されました")
            
        case ActionIdentifier.hold.rawValue:
            debugPrint("保留が押されました")
            
        default:
            ()
        }
        completionHandler()
    }
    
    
}
