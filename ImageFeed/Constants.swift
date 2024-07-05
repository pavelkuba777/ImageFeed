//
//  Constants.swift
//  ImageFeed
//
//  Created by Павел Куба on 25.06.2024.
//

import Foundation

enum Constants {
    static let accessKey = "Ex-GDhO_wDQXuN-AL5_Oql8Kbu1pn27mRe6vBV8ASmk"
    static let secretKey = "2cixGaysKHXzyDrPYl8vVKuHTwijvPY59NCXRMoaSpc"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let grantType = "authorization_code"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
