//
//  AuthManager.swift
//  MusicExpress
//
//  Created by Лексус on 21.04.2021.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private init() {
        accessToken = ""
    }
    
    public var signInUrl: URL? {
        // let string = "https://musicexpress.sarafa2n.ru/api/v1/session"
        
        let string = "https://musicexpress.sarafa2n.ru/login"

        return URL(string: string)
    }
    
    public func getAccessToken() -> String {
        return accessToken
    }
    
    public func setAccessToken(token: String) {
        if token != "" {
            isSignedIn = true
        } else {
            isSignedIn = false
        }
        accessToken = token
    }
    
    var isSignedIn: Bool = false
    
    private var accessToken: String
    
}
