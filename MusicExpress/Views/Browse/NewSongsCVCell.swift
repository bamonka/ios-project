//
//  NewSongsCVCell.swift
//  MusicExpress
//
//  Created by Антон Шарин on 08.05.2021.
//

import UIKit

class NewSongsCVCell: UICollectionViewCell {
    
    static let identifier = "NewSongsCVCell"
    
    
    private let durationLabel : UILabel = {
        
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 13,weight: .bold)
       
        label.numberOfLines = 1
        return label
        
    }()
    
    private let artistLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 10,weight: .bold)
       
        label.numberOfLines = 1
        return label
        
    }()
    
    private let trackNameLabel : UILabel = {
        let label = UILabel()
        
        return label
        
    }()
    
    private let trackImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleToFill
        return imageView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistLabel)
        contentView.addSubview(durationLabel)
        contentView.addSubview(trackImage)

        
        // contentView.addSubview(ArtistNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        trackNameLabel.sizeToFit()
        artistLabel.sizeToFit()
        durationLabel.sizeToFit()
        
        
        trackImage.frame = CGRect(x: 0, y: 0, width: 30 , height: 30)
        artistLabel.frame = CGRect(x: 40, y: 5, width: artistLabel.width, height: 20)
        trackNameLabel.frame = CGRect(x: 40, y: 20, width: trackNameLabel.width, height: 20)
        durationLabel.frame = CGRect(x: contentView.right - 35, y: 20, width: durationLabel.width, height: 20)
        
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistLabel.text = nil
        durationLabel.text = nil
        trackImage.image = nil
    }
    
    
    
    
    func configure(with viewmodel: NewSongsCellViewModel)  {
        
        trackNameLabel.text = viewmodel.title
        artistLabel.text = viewmodel.artist
        
        
        var a = 0
        var b = ""


        a = viewmodel.duration%60
        if a < 10 {
            b = String(viewmodel.duration/60)+":"+"0"+String(a)
        } else {b = String(viewmodel.duration/60) + ":" + String(viewmodel.duration%60)}


        
        durationLabel.text = b
        
        do {
            if let image = try APICaller.shared.getAlbumImage(path: viewmodel.poster) {
                trackImage.image = UIImage(data: image)!
                return
            }
        } catch {}
        
        
    }
    
}
