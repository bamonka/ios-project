//
//  ViewController.swift
//  MusicExpress
//
//  Created by Лексус on 21.04.2021.
//

import UIKit

enum HomeSectionType {
    
    case groupOfDay //0
    case randomTrackOfDayGroup //1
    case recommendedAlbumsTitle //2
    case recommendedAlbums(viewModels: [recommendedAlbumsViewModel]) //3
    case newSongsTitle //4
    case newSongs //5
    case topSongsTitle //6
    case topSongs //7

    
}

class HomeViewController: UIViewController {

    private var collectionView : UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout{sectionIndex, _ ->NSCollectionLayoutSection? in
            return HomeViewController.createSectionLayout(index : sectionIndex)
        }
    )
     
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
        
    }()
    
   // private var sections = [HomeSectionType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        fetchData()
       // configureCollectionView()
        view.addSubview(spinner)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(RecommendedAlbumsCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedAlbumsCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        
    }
    
    private static func createSectionLayout(index: Int) -> NSCollectionLayoutSection{
        switch index {
        
        
        case 0:
            
            // Item
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //Group
            
            
            let firstGroup = NSCollectionLayoutGroup.vertical(
                
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(360)),
                                                        
            subitem: item,
            count: 2)
            
            let secondGroup = NSCollectionLayoutGroup.horizontal(
                
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(360)),
                                                        
            subitem: firstGroup,
            count: 2)
            
            
            //Section
            let section = NSCollectionLayoutSection(group: secondGroup)
            // свойство для горизонтальных групп
           section.orthogonalScrollingBehavior = .continuous
            return section
            
            
        default:
            // Item
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.5)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //Group
            let group = NSCollectionLayoutGroup.vertical(
                
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(360)),
                                                        
            subitem: item,
            count: 1)
            
            //Section
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
    
    var recomAlbums : [Song]?
    private func fetchData() {
        APICaller.shared.getTopSongs { (data) in
            let decoded = try! JSONDecoder().decode([Song].self, from: data)
            self.recomAlbums = decoded
           // print(decoded[0].title)
            self.configureCollectionView()
           // print("https://musicexpress.sarafa2n.ru" + self.recomAlbums![0].poster!.dropFirst(1))
        } failure: { (error) in
            print("error")
        }

     //   sections.append(.recommendedAlbums(viewModels: []))
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedAlbumsCollectionViewCell.identifier, for: indexPath) as? RecommendedAlbumsCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: recomAlbums![indexPath.row])
        return cell
    }
    
}
