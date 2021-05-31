//
//  PlayerViewController.swift
//  MusicExpress
//
//  Created by Лексус on 21.04.2021.
//

import UIKit
import SDWebImage


protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapForward()
    func didTapBackward()
    func didSlideSlider(_ value : Float)
}


class PlayerViewController: UIViewController {
    
    weak var dataSource : PlayerDataSource?
    weak var delegate : PlayerViewControllerDelegate?
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        controlsView.delegate = self
        configureBarButtons()
        
        configure()

    }
    
    private let controlsView = PlayerControlsView()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        controlsView.frame = CGRect(x: 10,
                                    y: imageView.bottom + 15,
                                    width: view.width - 20,
                                    height: view.height - imageView.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 15)
    }
    
    
    private func configure () {
        
        
        
        guard let url = URL(string: "https://musicexpress.sarafa2n.ru" + dataSource!.imageURLstring) else {
            return
        }
        
        
        imageView.sd_setImage(with: url, completed: nil)
        controlsView.configure(with: PlayerControlsViewViewModel(title: dataSource?.songName,
                                                                 subtitle: dataSource?.subtitle))
    }
    

    private func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))

    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc private func didTapAction() {
        // actions
    }

}
// нажатие кнопок в плеере

extension PlayerViewController : PlayerControlsViewDelegate {
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
    
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapPlayPause()    }
    
    func playerControlsViewDidTapPForwardButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapForward()
    }
    
    func playerControlsViewDidTapBackwardButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapBackward()
    }
    
    
}
