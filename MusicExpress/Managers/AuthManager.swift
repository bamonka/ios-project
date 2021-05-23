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
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        print(UserDefaults.standard.string(forKey: "expire"))
        experation = dateFormatter.date(from: UserDefaults.standard.string(forKey: "expire") ?? "") ?? Date()
        
        print(cookie, csrfToken, experation)
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
        experation = expire.addingTimeInterval(4 * 60 * 60)
        cookie = token
        csrfToken = csrf

        UserDefaults.standard.setValue(csrfToken, forKey: "csrf")
        UserDefaults.standard.setValue(cookie, forKey: "cookie")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        UserDefaults.standard.setValue(formatter.string(from: experation), forKey: "expire")
    }
    
    private var cookie: String
    private var csrfToken: String
    private var experation: Date
}
