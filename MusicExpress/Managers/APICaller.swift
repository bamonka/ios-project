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
        case wrongLoginOrPassword
    }
    
    
    
// Получение информации об Артисте

  //  https://musicexpress.sarafa2n.ru/api/v1/artists/4/tracks url Артиста
    
    public func getArtistInfoForHeader (for artist: Song?,completion: @escaping (Result<Song,Error>)-> Void) {
        createRequest(with: getAPIURLFromPath(path: "artists/" + String(artist?.artist_id ?? 0)),
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
    
    public func getArtistsTracks (artist_id:Int,completion: @escaping (Result<[Song], Error>) -> Void) {
        getSongs(url: getAPIURLFromPath(path: "artists/" + String(artist_id) + "/" + "tracks"), completion: completion)
        
        
    }
    
    public func getArtistsAlbums(artist_id:Int,completion: @escaping (Result<ArtistAlbums, Error>) -> Void) {

        createRequest(with: getAPIURLFromPath(path: "artists/" + String(artist_id) + "/" + "albums"),
                      method: .Get) { request in
   let task = URLSession.shared.dataTask(with: request) { data, _, error in
       guard let data = data, error == nil else {
           completion(.failure(APIError.faileedToGetData))
           return
       }
       
       do {
           let decoded = try JSONDecoder().decode(ArtistAlbums.self, from: data)
           completion(.success(decoded))
       } catch {
           completion(.failure(error))
       }
   }
             
task.resume()
        }
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
                        
                        
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
        }
    
    // Получение деталей альбома + GetDescription
    //https://musicexpress.sarafa2n.ru/api/v1/albums/5   url альбома

    
    public func getAlbumDetails(for album: Song?,completion: @escaping(Result<Song, Error>) -> Void) {
        createRequest(with: getAPIURLFromPath(path: "albums/" + String(album?.id ?? 0)),
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
    
    
    // Получение всего на главном экране Home
    
    
    
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
    
    
    // общая функция получения
    
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
        var request = URLRequest(url: url)
        let auth = AuthManager.shared

        if method == .Post {
            request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "content-type")
            request.setValue(auth.getCSRFToken(), forHTTPHeaderField: "x-csrf-token")
            request.httpMethod = "POST"
        }

        if auth.isSignedIn() {
            request.setValue(auth.getAccessToken(), forHTTPHeaderField: "cookie")
        }

        completion(request)
    }
    
    public func login(login: String, password: String, completion: @escaping (Result<String, Error>)-> Void) {
        createRequest(
            with: getAPIURLFromPath(path: "session"),
            method: .Post
        ) { request in
            var request = request
            request.httpBody = "{\"login\":\"\(login)\", \"password\":\"\(password)\"}".data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) {_, response, error in
                guard error == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }

                guard
                    let url = response?.url,
                    let httpResponse = response as? HTTPURLResponse,
                    let fields = httpResponse.allHeaderFields as? [String: String]
                else {
                    return
                }
                
                if httpResponse.statusCode != 200 {
                    completion(.failure(APIError.wrongLoginOrPassword))
                }
                
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: url)
                HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: nil)
                for cookie in cookies {
                    if cookie.name == "code_express_session_id" {
                        AuthManager.shared.setAccessToken(
                            token: "\(cookie.name)=\(cookie.value)",
                            expire: cookie.expiresDate!,
                            csrf: httpResponse.allHeaderFields["x-csrf-token"] as! String
                        )

                        completion(.success("OK"))
                        return
                    }
                }
                completion(.failure(APIError.wrongLoginOrPassword))
            }
            task.resume()
        }
    }
    // поиск
    
    public func search(with query:String, completion: @escaping (Result<SearchReslutResponse, Error>)-> Void) {
        let queryPercentEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        createRequest(
            with: getAPIURLFromPath(
                path: "search?query=\(queryPercentEncoded)&offset=0&limit=20"
            )!,
            method: .Get
        ) { (request) in
            print(request.url?.absoluteString ?? "wrong request")
            let task = URLSession.shared.dataTask(with: request) {data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.faileedToGetData))
                    return
                }
            
                do {
                    let decoded = try JSONDecoder().decode(SearchReslutResponse.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            
            }
            task.resume()
        }
    }
    
 
}

