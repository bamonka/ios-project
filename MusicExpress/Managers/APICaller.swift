//
//  APICaller.swift
//  MusicExpress
//
//  Created by Лексус on 21.04.2021.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constans {
        static let domen = "https://musicexpress.sarafa2n.ru"
        static let api = "/api/v1/"
        static let default_albums_count = 6
        static let default_albums_offset = 0
        static let default_tracks_count = 5
        static let default_tracks_offset = 0
        static let default_top_albums_count = 3
        static let default_top_albums_offset = 0
        static let default_top_songs_count = 5
        static let default_top_songs_offset = 0
    }
    
    private init() {}
    
    enum APIError: Error {
        case faileedToGetData
    }
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        
    }
    
    private func getSongs(url: URL, completion: @escaping (Result<[Song], Error>) -> Void) {
        createRequest(
            with: url,
            method: HTTPMethod.Get
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                if error != nil {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
               
                guard let data = data else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }

                DispatchQueue.main.async {
                    do {
                        let decoded = try JSONDecoder().decode([Song].self, from: data)
                        completion(.success(decoded))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
    
    public func getAlbums(completion: @escaping (Result<[Song], Error>) -> Void) {
        getSongs(
            url: getAPIURLFromPath(path: "albums?count=\(Constans.default_albums_count)&from=\(Constans.default_albums_offset)"),
            completion: completion
        )
    }
    
    public func getNewSongs(completion: @escaping (Result<[Song], Error>) -> Void) {
        getSongs(
            url: getAPIURLFromPath(path: "tracks?count=\(Constans.default_tracks_count)&from=\(Constans.default_tracks_offset)"),
            completion: completion
        )
    }
    
    public func getTopAlbums(completion: @escaping (Result<[Song], Error>) -> Void) {
        getSongs(
            url: getAPIURLFromPath(path: "top?count=\(Constans.default_top_albums_count)&from=\(Constans.default_top_albums_offset)"),
            completion: completion
        )
    }
    
    public func getTopSongs(completion: @escaping (Result<[Song], Error>) -> Void) {
        getSongs(
            url: getAPIURLFromPath(path: "top?count=\(Constans.default_top_songs_count)&from=\(Constans.default_top_songs_count)"),
            completion: completion
        )
    }
    
    enum HTTPMethod: String {
        case Get
        case Post
    }
    
    public func getAlbumImage(path: String) throws -> Data? {
        if let url = getURLFromPath(path: path) {
            return try Data(contentsOf: url)
        }
        
        return nil
    }
    
    private func getURLFromPath(path: String) -> URL? {
        return URL(string: Constans.domen + path)
    }
    
    private func getAPIURLFromPath(path: String) -> URL! {
        return URL(string: Constans.domen + Constans.api + path)
    }
    
    private func createRequest(
        with url: URL,
        method: HTTPMethod,
        completion: @escaping (URLRequest) -> Void
    ) {
        // set some http headers
        completion(URLRequest(url: url))
    }
}

