//
//  PlayBackPresenter.swift
//  MusicExpress
//
//  Created by Антон Шарин on 27.05.2021.
//
import AVFoundation
import Foundation
import UIKit


protocol PlayerDataSource : AnyObject {
    var songName : String { get }
    var subtitle : String { get }
    var imageURLstring : String { get }
   

}


final class PlayBackPresenter {
    
    static let shared = PlayBackPresenter()
    
    private var track : Track?
    private var tracks = [Track]()
    
    var currentTrack : Track? //{
   //     if let track = track, tracks.isEmpty,tracksBySong.isEmpty,trackBySong == nil {
  //          return track
  //      } else if !tracks.isEmpty {
  //          return tracks.first
  //      }
        
 //       return nil
 //   }
    
    
    private var title : String = ""
    private var imageUrl: String = ""
    private var artist : String = ""
    
    var player : AVPlayer?
    var playerQueue : AVQueuePlayer?
    
    private var trackBySong : Song?
    private var tracksBySong = [Song]()
    
    var currentTrackBySong : Song? //{
    //    if let track = trackBySong, tracksBySong.isEmpty {
   //         return track
    //    } else if !tracksBySong.isEmpty {
    //        return tracksBySong.first
   //     }
        
  //      return nil
 //   }
    
     func startPlaybackWithSong(
        from viewController: UIViewController,
        track: Song
    ) {
        
        guard let url = URL(string: "https://musicexpress.sarafa2n.ru" + (track.audio ?? "")) else {
                return
        }
        
        player = AVPlayer(url: url)
        player?.volume = 0.5
        
        
        self.trackBySong = track
        self.tracksBySong = []
        self.track = nil
        self.tracks = []
        self.currentTrackBySong = track
        
        
        self.imageUrl = track.album_poster ?? ""
        self.title = track.title ?? ""
        self.artist = track.artist ?? ""
        
        let vc = PlayerViewController()
        vc.title = track.name ?? track.title ?? ""
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.player?.play()
        }
        
    }
    
     func startPlaybackWithTrack(
        from viewController: UIViewController,
        track: Track
    ) {
        guard let url = URL(string: "https://musicexpress.sarafa2n.ru" + (track.audio ?? "")) else {
                return
        }
        
        player = AVPlayer(url: url)
        player?.volume = 0.5
        
        self.track = track
        self.tracks = []
        self.trackBySong = nil
        self.tracksBySong = []
        self.currentTrack = track
       
        self.imageUrl = track.album_poster ?? ""
        self.title = track.title ?? ""
        self.artist = track.artist ?? ""
        
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self

        vc.title = track.title ?? ""
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.player?.play()
        }

    }
    
     func startPlaybackAllWithSong(
        from viewController: UIViewController,
        tracks: [Song]
    ) {
        self.tracksBySong = tracks
        self.trackBySong = nil
        self.track = nil
        self.tracks = []
        
        self.imageUrl = tracks[0].album_poster ?? ""
        
        self.playerQueue = AVQueuePlayer(items: tracks.compactMap({
            
            guard let url = URL(string: "https://musicexpress.sarafa2n.ru" + ($0.audio ?? "")) else {
                return nil
            }
            return AVPlayerItem(url: url)
        }))
        self.playerQueue?.volume = 0
        self.playerQueue?.play()
        
        self.currentTrackBySong = tracks.first
        let vc = PlayerViewController()
        vc.delegate = self
        vc.dataSource = self

        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)


        
    }
     func startPlaybackAllWithTrack(
        from viewController: UIViewController,
        tracks: [Track]
    ) {
        self.tracks = tracks
        self.track = nil
        self.trackBySong = nil
        self.tracksBySong = []
        self.currentTrack = tracks.first
        let vc = PlayerViewController()
        vc.delegate = self
        vc.dataSource = self

        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)


        
    }
    
   
    
}


extension PlayBackPresenter: PlayerViewControllerDelegate {
    
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
    
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
        else if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
            
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty && tracksBySong.isEmpty {
            player?.pause()
            // no playlist or album
        } else if let player = playerQueue {
            playerQueue?.advanceToNextItem()
        }
        
    }
    
    func didTapBackward() {
        if tracks.isEmpty && tracksBySong.isEmpty {
            player?.pause()
            player?.play()
        } else if let player = playerQueue {
          //  playerQueue?.
        }
    }
    
    
}



extension PlayBackPresenter: PlayerDataSource {
    var songName: String {
        return title
    }
    
    var subtitle: String {
        return artist

    }
    
    var imageURLstring: String {
        return imageUrl

    }
    
   
    
   
    
    
}
