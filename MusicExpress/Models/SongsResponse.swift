//
//  TopSongsResponse.swift
//  MusicExpress
//
//  Created by Антон Шарин on 23.04.2021.
//

import Foundation


// приходит с бэка и декодится в это
struct Song: Codable {
    
    let title: String? // альбомы трэк
    let artists : String?
    let id: Int?
    let audio : String? // трэк
    let album_poster : String? // трэк
    let artist_name : String? // альбомы
    let poster : String? //альбом
    let avatar: String? // артист
    let name: String? // артист
    let artist : String? // трэк
  
    
    enum CodingKeys : String, CodingKey {
        case title = "title"
        case id
        case audio = "audio"
        case album_poster = "album_poster"
        case artists = "artists"
        case artist_name = "artist_name"
        case poster = "poster"
        case avatar = "avatar"
        case name = "name"
        case artist = "artist"
    }
}
