//
//  PlayerControlsView.swift
//  MusicExpress
//
//  Created by Антон Шарин on 27.05.2021.
//

import Foundation
import UIKit


protocol PlayerControlsViewDelegate : AnyObject {
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapPForwardButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapBackwardButton(_ playerControlsView: PlayerControlsView)
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value : Float)

}


struct PlayerControlsViewViewModel {
    let title : String?
    let subtitle: String?
}

final class PlayerControlsView : UIView {
    
    private var isPlaying = true
    
    weak var delegate : PlayerControlsViewDelegate?
    
    private let volumeSlider : UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "This is song name"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "This is song artist"

        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "backward.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34))
        button.setImage(image, for: .normal)

        
        return button
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "forward.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34))
        button.setImage(image, for: .normal)

        
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "pause",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34))
        button.setImage(image, for: .normal)
                                                                                                    
        
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        
        addSubview(volumeSlider)
        volumeSlider.addTarget(self, action: #selector(didSlideSlider), for: .valueChanged)
        
        addSubview(backButton)
        addSubview(forwardButton)
        addSubview(playPauseButton)
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)

        
        clipsToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc  func didSlideSlider(_ slider:UISlider) {
        let value = slider.value
        delegate?.playerControlsView(self, didSlideSlider: value)
    }
    
    @objc private func didTapBack() {
        delegate?.playerControlsViewDidTapBackwardButton(self)
        
    }
    @objc private func didTapNext() {
        delegate?.playerControlsViewDidTapPForwardButton(self)
    }
    @objc private func didTapPlayPause() {
        self.isPlaying = !isPlaying
        delegate?.playerControlsViewDidTapPlayPauseButton(self)
        
        
        //update icon
        
        let pause = UIImage(systemName: "pause.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34))
        let play = UIImage(systemName: "play.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 34))

        playPauseButton.setImage(isPlaying ? pause : play, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 25)
        subtitleLabel.frame = CGRect(x: 0, y: nameLabel.bottom + 10, width: width, height: 25)
        nameLabel.textAlignment = .center
        subtitleLabel.textAlignment = .center

        
        
        
        let buttonSize:CGFloat = 60
        
        
        playPauseButton.frame = CGRect(x: (width - buttonSize)/2, y: subtitleLabel.bottom + 50, width: buttonSize, height: buttonSize)
        backButton.frame = CGRect(x: playPauseButton.left - 55 - buttonSize, y: playPauseButton.top, width: buttonSize, height: buttonSize)
        forwardButton.frame = CGRect(x: playPauseButton.right + 55, y: playPauseButton.top, width: buttonSize, height: buttonSize)

        volumeSlider.frame = CGRect(x: backButton.left, y: playPauseButton.bottom + 20 , width: 110 + (3 * buttonSize), height: 44)
        
    }
    
    
    func configure(with viewModel: PlayerControlsViewViewModel) {
        nameLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
}
