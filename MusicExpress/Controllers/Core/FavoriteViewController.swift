//
//  LibraryViewController.swift
//  MusicExpress
//
//  Created by Лексус on 21.04.2021.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    
    
    
    
    private let noFavoriteImage : UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "No-Favorite-image.png")
        imageView.image = image
        imageView.contentMode = .scaleToFill
        imageView.frame = CGRect(x: 50, y: 200, width: 250, height: 200)
        
        return imageView
    }()
    
    private  let letsChangeItLabel: UILabel = {
        let label = UILabel()
        label.text = "У вас пока что нет любимых треков.\nМожет, пора это исправить?"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .systemBlue
        label.frame = CGRect(x: 100, y:420 , width: label.intrinsicContentSize.width, height: 50)
        return label
        
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
       
        view.addSubview(noFavoriteImage)
        view.addSubview(letsChangeItLabel)
        
        // Do any additional setup after loading the view.
    }
    

    

}
