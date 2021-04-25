//
//  ViewController.swift
//  MusicExpress
//
//  Created by Лексус on 21.04.2021.
//

import UIKit

enum BrowseSectionType {
    case albums(viewModels: [AlbumCellViewModel])
    case topTracks(viewModels: [AlbumCellViewModel])
    case topAlbums(viewModels: [AlbumCellViewModel])
}

class HomeViewController: UIViewController {

    private var collectionView : UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout{sectionIndex, _ ->NSCollectionLayoutSection? in
            return HomeViewController.createSectionLayout(index : sectionIndex)
        }
    )
    
    private var sections = [BrowseSectionType]()
     
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings)
        )
        
        configureCollectionView()
        view.addSubview(spinner)
        fetchData()
    }
    
    private func fetchData() {
        let group = DispatchGroup()
        
        group.enter()
        group.enter()
        
        var albums: [Song]?
        var topSongs: [Song]?

        APICaller.shared.getAlbums{ result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let songs):
                albums = songs
                break
            case .failure(let error):
                print(error)
                break
            }
        }
        
        APICaller.shared.getAlbums{ result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let songs):
                topSongs = songs
                break
            case .failure(let error):
                print(error)
                break
            }
        }
        
        group.notify(queue: .main) {
            guard let albums = albums,
                  let topSongs = topSongs else {
                return
            }
            
            self.configureModels(albums: albums, tracks: topSongs)
        }
    }
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configureModels(albums: [Song], tracks: [Song]) {
        sections.append(.albums(viewModels: albums.compactMap({
            return AlbumCellViewModel(
                artistName: $0.artistName ?? "",
                title: $0.title,
                poster: $0.poster ?? ""
            )
        })))
        sections.append(.albums(viewModels: tracks.compactMap({
            return AlbumCellViewModel(
                artistName: $0.artistName ?? "-",
                title: $0.title,
                poster: $0.poster ?? ""
            )
        })))
        collectionView.reloadData()
        // sections.append(.topAlbums(viewModels: []))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(
            RecommendedAlbumsCollectionViewCell.self,
            forCellWithReuseIdentifier: RecommendedAlbumsCollectionViewCell.identifier
        )
        collectionView.register(
            TopTracksCollectionViewCell.self,
            forCellWithReuseIdentifier: TopTracksCollectionViewCell.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        
    }
    
    private static func createSectionLayout(index: Int) -> NSCollectionLayoutSection{
        switch index {
        case 0:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)

            let firstGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(510)
                ),
                subitem: item,
                count: 2
            )
            
            let secondGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(530)
                ),
                subitem: firstGroup,
                count: 2
            )

            let section = NSCollectionLayoutSection(group: secondGroup)

            // свойство для горизонтальных групп
            section.orthogonalScrollingBehavior = .continuous

            return section
        case 1:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

            let firstGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(360)
                ),
                subitem: item,
                count: 5
            )
            
            let secondGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(360)
                ),
                subitem: firstGroup,
                count: 1
            )

            let section = NSCollectionLayoutSection(group: secondGroup)
            // свойство для горизонтальных групп
            section.orthogonalScrollingBehavior = .continuous

            return section
            
        case 2:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

            let firstGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(360)
                ),
                subitem: item,
                count: 4
            )
            
            let secondGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(360)
                ),
                subitem: firstGroup,
                count: 1
            )

            let section = NSCollectionLayoutSection(group: secondGroup)
            // свойство для горизонтальных групп
            section.orthogonalScrollingBehavior = .continuous

            return section
        default:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

            let firstGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(360)
                ),
                subitem: item,
                count: 2
            )
            
            let secondGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(360)
                ),
                subitem: firstGroup,
                count: 2
            )

            let section = NSCollectionLayoutSection(group: secondGroup)
            // свойство для горизонтальных групп
            section.orthogonalScrollingBehavior = .continuous

            return section
        }
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .albums(let model):
            return model.count
        case .topAlbums(let model):
            return model.count
        case .topTracks(let model):
            return model.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        switch type {
        case .albums(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedAlbumsCollectionViewCell.identifier,
                for: indexPath
            ) as? RecommendedAlbumsCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)

            return cell
        case .topAlbums(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedAlbumsCollectionViewCell.identifier,
                for: indexPath
            ) as? RecommendedAlbumsCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)

            return cell
        case .topTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecommendedAlbumsCollectionViewCell.identifier,
                for: indexPath
            ) as? RecommendedAlbumsCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)

            return cell
        }
    }
    
}
