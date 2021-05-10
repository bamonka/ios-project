//
//  GroupOfTheDayCVcell.swift
//  MusicExpress
//
//  Created by Антон Шарин on 07.05.2021.
//

import UIKit

// image url
// https://musicexpress.sarafa2n.ru/artist_posters/764a1e25df46c88fd0f86c944cd514b6.jpeg

class GroupOfTheDayCVcell: UICollectionViewCell {
    
    static let identifier = "GroupOfTheDayCVcell"
    
    private let groupImage:UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleToFill
        
        return imageView
        
    }()
    
    private let groupOfDayLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Группа дня"
       // label.backgroundColor = UIColor(red: 18, green: 20, blue: 22, alpha: 1)
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 1
        return label
        
    }()
    
    private let nameOfGroupOfDay: UILabel = {
        
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 25,weight: .bold)
        label.textColor = .white
        label.numberOfLines = 1
        return label
        
    }()
    
    private let playRandomTrackButton : UIButton = {
        
        let button = UIButton()
        
        button.setTitle("Случайный трек", for: .normal)
        
        button.backgroundColor = UIColor(red: 255, green: 0, blue: 82, alpha: 1)
        button.titleLabel?.font = .systemFont(ofSize: 15)
     
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(groupImage)
        contentView.addSubview(groupOfDayLabel)
        contentView.addSubview(nameOfGroupOfDay)
        contentView.addSubview(playRandomTrackButton)

        
       // contentView.addSubview(ArtistNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        groupOfDayLabel.sizeToFit()
        nameOfGroupOfDay.sizeToFit()
        
        playRandomTrackButton.frame = CGRect(x: contentView.right/3, y: contentView.bottom*0.83, width: contentView.width/3, height: contentView.height/10)
        groupImage.frame = CGRect(x: 0, y: 0, width: contentView.width, height: contentView.height)
        
        groupOfDayLabel.frame = CGRect(x: groupImage.left + 10, y: 7, width: groupOfDayLabel.width, height: 40)
        nameOfGroupOfDay.frame = CGRect(x: groupImage.right - nameOfGroupOfDay.width - 10, y: 7, width: nameOfGroupOfDay.width, height: 40)
        
      //  nameOfGroupOfDay.frame = CGRect(x: albumCoverImage.left,
      //                                y: albumCoverImage.bottom+2,
       //                               width: albumNameLabel.width,
        //                              height: 50)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameOfGroupOfDay.text = nil
        
        groupImage.image = nil
    }

    
    func configure(with viewmodel: groupOfDayCellViewModel) {
       nameOfGroupOfDay.text = viewmodel.name
        
        do {
            if let image = try APICaller.shared.getAlbumImage(path: viewmodel.poster) {
                groupImage.image = UIImage(data: image)!
                return
            }
        } catch {}
        
        // Set default image
    }
    
}
