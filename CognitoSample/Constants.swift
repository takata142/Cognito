//
//  Constants.swift
//  CognitoSample
//
//  Created by 岩田裕登 on 2020/05/06.
//  Copyright © 2020 Yuto Iwata. All rights reserved.
//

import AWSCognitoIdentityProvider

struct CognitoConstants {
    // UserPool の各情報をもとにそれぞれの値を設定する.
    static let IdentityUserPoolRegion: AWSRegionType = .Unknown
    static let IdentityUserPoolId: String = "YourIdentityUserPoolId"
    static let AppClientId: String = "YourAppClientId"
    static let AppClientSecret: String? = nil
    static let SignInProviderKey: String = "YourSignInProviderKey"
    static let IdentityPoolId: String = "YourIdentityPoolId"
    
    /// インスタンス生成禁止.
    private init() {}
}
