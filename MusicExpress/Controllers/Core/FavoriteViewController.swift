//
//  LibraryViewController.swift
//  MusicExpress
//
//  Created by Лексус on 21.04.2021.
//

import UIKit

class FavoriteViewController: UIViewController {
    private let collectionViewSongs = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(
            sectionProvider: {
                _,_ -> NSCollectionLayoutSection?  in
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )
                                                    
                item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

                let firstGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(80)
                    ),
                    subitem: item,
                    count: 1
                )
                                                    
                let section = NSCollectionLayoutSection(group: firstGroup)
                // свойство для горизонтальных групп
        
                return section
            }
        )
    )

    private let noFavoriteImage : UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "No-Favorite-image.png")
        imageView.image = image
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
    private  let letsChangeItLabel: UILabel = {
        let label = UILabel()
        label.text = "У вас пока что нет любимых треков.\nМожет, пора это исправить?"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .systemBlue

        return label
        
    }()
    
    private var viewModels = [TopSongsCellViewModel]()
    
    private func drawEmpty() {
        view.addSubview(noFavoriteImage)
        view.addSubview(letsChangeItLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewSongs.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noFavoriteImage.frame = CGRect(
            x: (view.width - 300) / 2,
            y: (view.height - 300) / 4,
            width: 300,
            height: 300
        )
        
        letsChangeItLabel.frame = CGRect(
            x: (view.width - 300) / 2,
            y: (view.height - 300) / 1.3,
            width: letsChangeItLabel.intrinsicContentSize.width,
            height: 50
        )
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionViewSongs)
        
        collectionViewSongs.register(
            TopTracksCollectionViewCell.self,
            forCellWithReuseIdentifier: TopTracksCollectionViewCell.identifier
        )

        collectionViewSongs.backgroundColor = .systemBackground
        collectionViewSongs.delegate = self
        collectionViewSongs.dataSource = self
        
        APICaller.shared.getFavoriteTracks {
            [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.count == 0 {
                        self?.drawEmpty()
                        return
                    }
                    self?.viewModels = model.compactMap({
                        return TopSongsCellViewModel(
                            id: $0.id ?? 0,
                            title: $0.title ?? "",
                            duration: $0.duration ?? 0,
                            artist: $0.artist ?? "",
                            album_poster: $0.album_poster ?? "",
                            artist_id: $0.artist_id ?? 0,
                            isLiked: $0.is_liked ?? false,
                            isPlus:$0.is_favorite ?? false
                        )
                    })
                    self?.collectionViewSongs.reloadData()
                case.failure(let error):
                    print("failed to get album details", error)
                    break
                }
            }
        }
    }
}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TopTracksCollectionViewCell.identifier,
            for: indexPath
        ) as? TopTracksCollectionViewCell else {
            return UICollectionViewCell ()
        }
        
        cell.configure(with: viewModels[indexPath.row])
       
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // play song
    }
}
