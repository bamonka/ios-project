//
//  AuthManager.swift
//  MusicExpress
//
//  Created by Лексус on 21.04.2021.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    public var signInUrl: URL? {
        // let string = "https://musicexpress.sarafa2n.ru/api/v1/session"
        
        let string = "https://musicexpress.sarafa2n.ru/login"

        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return true
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
}
