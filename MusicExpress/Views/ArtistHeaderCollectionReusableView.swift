//
//  ArtistHeaderCollectionReusableView.swift
//  MusicExpress
//
//  Created by Антон Шарин on 20.05.2021.
//

import UIKit


protocol ArtistHeaderCollectionReusableViewDelegate : AnyObject {
    func artistHeaderCollectionReusableViewDidTapPlayAll(_ header : ArtistHeaderCollectionReusableView)
}

final class ArtistHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "ArtistHeaderCollectionReusableView"
        
    weak var delegate : ArtistHeaderCollectionReusableViewDelegate?

    
    private let atristNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
        
        
    }()
    
    
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
        
        
    }()
    
    private let artistImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let artistAvatar : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let playAllButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.setImage(UIImage(systemName:"play.fill"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        
        return button
    }()
    
    
    // INIT
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        addSubview(artistImage)
        addSubview(artistAvatar)
        addSubview(descriptionLabel)
        addSubview(atristNameLabel)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)

    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func didTapPlayAll () {
        //
        delegate?.artistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize:CGFloat = height/1.7
        artistImage.frame = CGRect(x: (width - imageSize)/2, y: 10, width: imageSize, height: imageSize)
        
        atristNameLabel.frame = CGRect(x: 10, y: artistImage.bottom - 5, width: width - 20, height: 44)
        artistAvatar.frame = CGRect(x: 10, y: atristNameLabel.bottom - 15, width: width - 20, height: 44)
        descriptionLabel.textAlignment = .natural
        descriptionLabel.frame = CGRect(x: 10, y: artistAvatar.bottom - 15, width: width - 20, height: 150)
        playAllButton.frame = CGRect(x: width - 100, y: artistAvatar.top, width: 50, height: 50)
        
    }
    
    func configure(with viewModel:ArtistHeaderCellViewModel) {
        
        atristNameLabel.text = viewModel.artistName
        
        
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
        
        guard let urlImage = URL(string: "https://musicexpress.sarafa2n.ru" + viewModel.poster) else {
            return
        }
        
        artistImage.sd_setImage(with: urlImage, completed: nil)
        
        guard let urlAvatar = URL(string: "https://musicexpress.sarafa2n.ru" + viewModel.avatar) else {
            return
        }
        
        artistAvatar.sd_setImage(with: urlAvatar, completed: nil)

        
        
    }
    
}
