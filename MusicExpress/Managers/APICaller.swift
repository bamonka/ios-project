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
    
    
    //https://musicexpress.sarafa2n.ru/api/v1/albums/5 url Альбома
    
    public func getAlbumDetails(for album: Song?,completion: @escaping(Result<Song, Error>) -> Void) {
        createRequest(with: getAPIURLFromPath(path: "albums/" + String(((album?.id!)!))),
                      method: .Get
                     ) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode(Song.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            }
                      
        task.resume()
        }
    }
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        
    }
    
    public func getDescription(artist_id:Int,completion: @escaping (Result<Song,Error>)-> Void) {
        createRequest(with: getAPIURLFromPath(path: "artists/" + String(artist_id)),
                      method: .Get
        ) {
            request in
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
                        let decoded = try JSONDecoder().decode(Song.self, from: data)
                        completion(.success(decoded))
                        print(decoded.description)
                        print(request)
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
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
            //https://musicexpress.sarafa2n.ru/api/v1/albums/top?count=3&from=0
            url: URL(string: "https://musicexpress.sarafa2n.ru/api/v1/albums/top?count=3&from=0")!,
            completion: completion
            )
    }
    
    public func getTopSongs(completion: @escaping (Result<[Song], Error>) -> Void) {
        getSongs(
            //https://musicexpress.sarafa2n.ru/api/v1/tracks/top?count=5&from=0
            url: getAPIURLFromPath(path: "tracks/top?count=5&from=0"),
            completion: completion
        )
    }
    
    enum HTTPMethod: String {
        case Get
        case Post
    }
    
    //https://musicexpress.sarafa2n.ru/api/v1/albums/5   url альбома
    
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
    
    
    
    //https://musicexpress.sarafa2n.ru/api/v1/search?query=thunder&offset=0&limit=20
    //
    
    public func search(with query:String, completion: @escaping (Result<SearchReslutResponse, Error>)-> Void){
        createRequest(with: URL(string: Constans.domen + Constans.api + "search?query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&offset=0&limit=20")! , method: .Get) { (request) in
            print(request.url?.absoluteString ?? "wrong request")
            let task = URLSession.shared.dataTask(with: request) {data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
            
                do {
                //    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                //    print(json)
                    
                    let decoded = try JSONDecoder().decode(SearchReslutResponse.self, from: data)
                   print(decoded.artists![0].name)
                    completion(.success(decoded))
                    
                    }
                catch {
                    print(error)
                    completion(.failure(error))
                }
            
                }
            task.resume()
        }
        
    }
    
    public func getGroupOfDay(completion: @escaping (Result<Song, Error>) -> Void) {
        createRequest(with: URL(string: Constans.domen + Constans.api + "artist/day")! , method: .Get) {
            request in
            
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
                            let decoded = try JSONDecoder().decode(Song.self, from: data)
                            completion(.success(decoded))
                        } catch {
                            completion(.failure(error))
                        }
                    }
                }
                task.resume()
            
        }
    }
}

