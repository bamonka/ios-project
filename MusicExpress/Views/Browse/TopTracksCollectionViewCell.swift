//
//  CollectionViewCell.swift
//  MusicExpress
//
//  Created by Лексус on 25.04.2021.
//

import UIKit

class TopTracksCollectionViewCell: UICollectionViewCell {
    static let identifier = "TopTracksCollectionViewCell"
    
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
        label.numberOfLines = 2
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
        
        
        trackImage.frame = CGRect(x: 10, y: (contentView.bottom+contentView.top)/2 - 20, width: 40 , height: 40)
        artistLabel.frame = CGRect(x: 55, y: 15, width: artistLabel.width, height: 20)
        trackNameLabel.frame = CGRect(x: 55, y: 30, width: trackNameLabel.intrinsicContentSize.width, height: 20)
        durationLabel.frame = CGRect(x: contentView.right - 35, y: (contentView.top+contentView.bottom)/2 - 10, width: durationLabel.width, height: 20)
        
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistLabel.text = nil
        durationLabel.text = nil
        trackImage.image = nil
    }
    
    
    
    
    func configure(with viewmodel: TopSongsCellViewModel)  {
        
        trackNameLabel.text = viewmodel.title
        artistLabel.text = viewmodel.artist
        
        
        var a = 0
        var b = ""


        a = viewmodel.duration%60
        if a < 10 {
            b = String(viewmodel.duration/60)+":"+"0"+String(a)
        } else {b = String(viewmodel.duration/60) + ":" + String(viewmodel.duration%60)}


        
        durationLabel.text = b
        
        guard let url = URL(string: "https://musicexpress.sarafa2n.ru" + viewmodel.album_poster) else {
            return
        }
        
        trackImage.sd_setImage(with: url, completed: nil)
        
    }
    
}
