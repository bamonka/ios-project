//
//  SearchResultCollectionViewCell.swift
//  MusicExpress
//
//  Created by Лексус on 17.05.2021.
//

import UIKit

class SearchResultCollectionViewCell: UITableViewCell {
    static let identifier = "SearchResultDefaultTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.frame = CGRect(x: 10, y: 0, width: contentView.height, height: contentView.height)
        label.frame = CGRect(x: iconImageView.right + 10, y: 0, width: contentView.width, height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
    }
    
    func configure(width viewModel: SearchResultDefaultTableVeiewCellViewModel) {
        label.text = viewModel.title
        do {
            if let image = try APICaller.shared.getAlbumImage(path: viewModel.imageUrl) {
                iconImageView.image = UIImage(data: image)
                return
            }
        } catch {}
    }
}
