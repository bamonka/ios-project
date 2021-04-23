//
//  TopSongsResponse.swift
//  MusicExpress
//
//  Created by Антон Шарин on 23.04.2021.
//

import Foundation


// приходит с бэка и декодится в это
struct Song: Codable {
    
    let title: String
    let artists : String?
    let id: Int?
    let audio : String?
    let album_poster : String?
    let artist_name : String?
    let poster : String?
  
    
    enum CodingKeys : String, CodingKey {
        case title = "title"
        case id
        case audio = "audio"
        case album_poster = "album_poster"
        case artists = "artists"
        case artist_name = "artist_name"
        case poster = "poster"
        
      
    }
    
}
