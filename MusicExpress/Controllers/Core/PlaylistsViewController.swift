//
//  PlaylistsViewController.swift
//  MusicExpress
//
//  Created by Антон Шарин on 20.05.2021.
//

import UIKit



class PlaylistsViewController: UIViewController {
    
    
    
    
    private let createPlaylistButton : UIButton = {
        let button = UIButton()
        button.setTitle("Добавить новый \n плейлист", for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .gray
        return button
    }()
    
    
   private let noPlaylistsImage : UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "No-playlists-image.png")
        imageView.image = image
        imageView.contentMode = .scaleToFill
        imageView.frame = CGRect(x: 50, y: 200, width: 250, height: 200)
        
        return imageView
    }()
    
   private let letsChangeItLabel: UILabel = {
        let label = UILabel()
        label.text = "У вас пока что нет плейлистов.\nМожет, пора это исправить?"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .systemBlue
        label.frame = CGRect(x: 100, y:420 , width: label.intrinsicContentSize.width, height: 50)
        return label
        
    }()
    
    @objc func didTapCreatePlaylistButton () {
        //create new playlist
        
        print("Created")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground

        
        view.addSubview(noPlaylistsImage)
        view.addSubview(letsChangeItLabel)
        view.addSubview(createPlaylistButton)
        
        createPlaylistButton.frame = CGRect(x: letsChangeItLabel.left, y: letsChangeItLabel.bottom + 20, width: createPlaylistButton.intrinsicContentSize.width, height: createPlaylistButton.intrinsicContentSize.height)
        createPlaylistButton.addTarget(self, action: #selector(didTapCreatePlaylistButton), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    

   

}
