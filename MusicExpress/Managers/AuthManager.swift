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
        cookie = UserDefaults.standard.string(forKey: "cookie") ?? ""
        csrfToken = UserDefaults.standard.string(forKey: "csrf") ?? ""

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat

        experation = dateFormatter.date(from: UserDefaults.standard.string(forKey: "expire") ?? "") ?? Date()
        
        print(experation, cookie, csrfToken)
    }
    
    public func isSignedIn() -> Bool {
        if Date() < experation && cookie != "" && csrfToken != "" {
            return true
        }
        
        return false
    }
    
    public func getAccessToken() -> String {
        return cookie
    }
    
    public func getCSRFToken() -> String {
        return csrfToken
    }
    
    public func setAccessToken(
        token: String,
        expire: Date,
        csrf: String
    ) {
        experation = expire
        cookie = token
        csrfToken = csrf

        UserDefaults.standard.setValue(csrfToken, forKey: "csrf")
        UserDefaults.standard.setValue(cookie, forKey: "cookie")
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        UserDefaults.standard.setValue(formatter.string(from: experation), forKey: "expire")
        
        print(experation, cookie, csrfToken)
    }
    
    private let dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    private var cookie: String
    private var csrfToken: String
    private var experation: Date
}
