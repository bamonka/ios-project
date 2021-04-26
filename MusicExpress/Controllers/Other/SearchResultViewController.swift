//
//  SearchResultViewController.swift
//  MusicExpress
//
//  Created by Лексус on 21.04.2021.
//

import UIKit

class SearchResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    private var results: SearchReslutResponse?
    
    private let tableView : UITableView = {
        
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
     //   tableView.isHidden = true
        return tableView
        
    }()
    
     let ArtistLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.frame = CGRect(x: 200, y: 200, width: 200, height: 50)
        label.textColor = .black
        label.text = ""
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
       // view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(ArtistLabel)
        
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with results: SearchReslutResponse) {
        self.results = results
        print("123")
        ArtistLabel.text = String(results.artists![0].name!)
        tableView.reloadData()
    
        tableView.isHidden = false
        
    }
    
    func countResults() -> Int {
      
        var done: Int
        var a,b,c : Int
        
        a = results?.albums?.count ?? 0
        b = results?.artists?.count ?? 0
        c = results?.tracks?.count ?? 0
        
        if a+b+c == 0 {
            done = 0
            return done
        } else {
            done = a+b+c
        }
        
        print(done)
        return done
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       
        
     //   return  countResults()
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Foo"
        
        return cell
    }
    
    

}
