//
//  Constants.swift
//  CognitoSample
//
//

import AWSCognitoIdentityProvider

struct CognitoConstants {
    // UserPool の各情報をもとにそれぞれの値を設定する.
    /// ユーザープールを設定しているリージョン.
    static let IdentityUserPoolRegion: AWSRegionType = .USEast1
    /// ユーザープールID.
    static let IdentityUserPoolId: String = "us-east-1_6HxGhQeJ5"
    /// アプリクライアントID.
    static let AppClientId: String = "1s5h24p1uv9ouu2sbl4p3o41kq"
    /// アプリクライアントのシークレットキー.
    static let AppClientSecret: String? = "qcopgg8oua8fup6hj3mqoh1o5uhlavjc76s4b2ccpk025gj4os8"
    /// プロバイダキー. "UserPool" で良さそう.
    static let SignInProviderKey: String = "UserPool"
    
    /// インスタンス生成禁止.
    private init() {}
}
