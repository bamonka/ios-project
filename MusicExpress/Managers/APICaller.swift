//
//  APICaller.swift
//  MusicExpress
//
//  Created by Лексус on 21.04.2021.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        
    }
    
    public func getTopSongs(success: @escaping (Data) -> Void, failure: @escaping (String) -> Void) {
        
        guard let url = URL(string: "https://musicexpress.sarafa2n.ru/api/v1/albums?count=6&from=0") else {
            return
        }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if error != nil {
                failure("error")
                return
            }
           
            guard let data = data else {
                failure("empry data")
                return
            }
            
           
            DispatchQueue.main.async {
                success(data)
            }
        }
        task.resume()
    }
}
