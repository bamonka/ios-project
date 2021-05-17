//
//  SearchResultViewController.swift
//  MusicExpress
//
//  Created by Лексус on 21.04.2021.
//

import UIKit
import SDWebImage

struct SearchSection {
    let title: String
    let results: [Song]
}

class SearchResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var sections: [SearchSection] = []
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(SearchResultCollectionViewCell.self,
                           forCellReuseIdentifier: SearchResultCollectionViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true

        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with results: SearchReslutResponse) {
        self.sections.removeAll()
        if let artists = results.artists {
            self.sections.append(SearchSection(title: "Artists", results: artists))
        }
        if let albums = results.albums {
            self.sections.append(SearchSection(title: "Albums", results: albums))
        }
        if let tracks = results.tracks {
            self.sections.append(SearchSection(title: "Tracks", results: tracks))
        }

        tableView.reloadData()
        tableView.isHidden = sections.isEmpty
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.sections[indexPath.section]
        let result = section.results[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultCollectionViewCell.identifier,
            for: indexPath
        ) as? SearchResultCollectionViewCell else {
            return UITableViewCell()
        }
        
        var viewModel = SearchResultDefaultTableVeiewCellViewModel(
            title: "",
            imageUrl: "",
            artist: ""
        )

        if section.title == "Artists" {
            viewModel = SearchResultDefaultTableVeiewCellViewModel(
                title: result.name ?? "",
                imageUrl: result.poster ?? "",
                artist: ""
            )
        } else if section.title == "Albums" {
            viewModel = SearchResultDefaultTableVeiewCellViewModel(
                title: result.title ?? "",
                imageUrl: result.poster ?? "",
                artist: result.artist_name ?? ""
            )
        } else if section.title == "Tracks" {
            viewModel = SearchResultDefaultTableVeiewCellViewModel(
                title: result.title ?? "",
                imageUrl: result.album_poster ?? "",
                artist: result.artist ?? ""
            )
        }
        
        cell.configure(width: viewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].title
    }
}
