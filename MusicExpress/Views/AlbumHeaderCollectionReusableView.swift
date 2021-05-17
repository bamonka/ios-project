//
//  AlbumHeaderCollectionReusableView.swift
//  MusicExpress
//
//  Created by Антон Шарин on 17.05.2021.
//

import UIKit
import SDWebImage

final class AlbumHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "AlbumHeaderCollectionReusableView"
    
    private let atristNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
        
        
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
        
        
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
        
        
    }()
    
    private let albumImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        addSubview(albumImage)
        addSubview(albumNameLabel)
        addSubview(descriptionLabel)
        addSubview(atristNameLabel)

    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize:CGFloat = height/1.7
        albumImage.frame = CGRect(x: (width - imageSize)/2, y: 10, width: imageSize, height: imageSize)
        
        atristNameLabel.frame = CGRect(x: 10, y: albumImage.bottom - 5, width: width - 20, height: 44)
        albumNameLabel.frame = CGRect(x: 10, y: atristNameLabel.bottom - 15, width: width - 20, height: 44)
        descriptionLabel.textAlignment = .natural
        descriptionLabel.frame = CGRect(x: 10, y: albumNameLabel.bottom - 15, width: width - 20, height: 150)

        
    }
    
    func configure(with viewModel:AlbumHeaderCellViewModel) {
        albumNameLabel.text = viewModel.albumName
        
      APICaller.shared.getDescription(artist_id: viewModel.artist_id ?? 0, completion: { result in
             DispatchQueue.main.async {
                                                                        switch result{
                                                                        
                                                                        case .success(let Gotdescription):
                                                                            self.descriptionLabel.text = Gotdescription.description
                                                                            print("Got description")
                                                                             
                                                                           
                                                                        case.failure(let error):
                                                                            print("failed to get descriptionText", error)
                                                                            break
                                                                        }
                                                                }            }
        )
        atristNameLabel.text = viewModel.artistName
        
        guard let url = URL(string: "https://musicexpress.sarafa2n.ru" + viewModel.poster) else {
            return
        }
        
        albumImage.sd_setImage(with: url, completed: nil)

        
        
    }
    
   
    
}
